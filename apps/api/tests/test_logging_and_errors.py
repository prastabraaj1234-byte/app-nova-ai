import pytest
from unittest.mock import patch
from httpx import AsyncClient
from fastapi import APIRouter
from src.main import app
from src.exceptions import ResourceNotFoundException

import asyncio

# Add temporary router for testing error redaction, payload size, and timeout limits
mock_error_router = APIRouter(prefix="/test-error")

@mock_error_router.get("/500")
async def raise_unhandled_error():
    raise RuntimeError("SECRET_PASSWORD_123_DO_NOT_LEAK connection string postgresql://secret@localhost")

@mock_error_router.get("/custom-404")
async def raise_custom_404():
    raise ResourceNotFoundException("Companion", "comp-999")

@mock_error_router.post("/upload-test")
async def dummy_upload():
    return {"status": "ok"}

@mock_error_router.get("/timeout-test")
async def dummy_sleep():
    await asyncio.sleep(0.5)
    return {"status": "awake"}

app.include_router(mock_error_router)

@pytest.mark.asyncio
async def test_correlation_id_propagation(async_client: AsyncClient):
    """Verify X-Request-ID is preserved from request to response headers and body."""
    test_id = "req_custom_correlation_888"
    response = await async_client.get("/healthz", headers={"X-Request-ID": test_id})
    assert response.status_code == 200
    assert response.headers.get("X-Request-ID") == test_id
    assert response.json()["request_id"] == test_id

@pytest.mark.asyncio
async def test_correlation_id_generation(async_client: AsyncClient):
    """Verify a valid UUID X-Request-ID is generated when header is missing."""
    response = await async_client.get("/healthz")
    assert response.status_code == 200
    req_id = response.headers.get("X-Request-ID")
    assert req_id is not None
    assert len(req_id) > 20
    assert response.json()["request_id"] == req_id

@pytest.mark.asyncio
async def test_correlation_id_security_replaces_invalid_id(async_client: AsyncClient):
    """Verify X-Request-ID containing CRLF or special characters is replaced with new UUIDv4."""
    malicious_id = "req_inject\r\nLog: Spoofed"
    response = await async_client.get("/healthz", headers={"X-Request-ID": malicious_id})
    assert response.status_code == 200
    returned_id = response.headers.get("X-Request-ID")
    assert returned_id != malicious_id
    assert "\r" not in returned_id
    assert "\n" not in returned_id
    assert len(returned_id) > 20

@pytest.mark.asyncio
async def test_standardized_404_error_schema(async_client: AsyncClient):
    """Verify 404 returns standardized API error schema."""
    response = await async_client.get("/nonexistent-endpoint")
    assert response.status_code == 404
    data = response.json()
    assert "error" in data
    err = data["error"]
    assert err["code"] == "NOT_FOUND"
    assert "request_id" in err
    assert "timestamp" in err
    assert "traceback" not in data
    assert "exc_info" not in data

@pytest.mark.asyncio
async def test_custom_exception_schema(async_client: AsyncClient):
    """Verify custom ResourceNotFoundException formatting."""
    response = await async_client.get("/test-error/custom-404")
    assert response.status_code == 404
    err = response.json()["error"]
    assert err["code"] == "RESOURCE_NOT_FOUND"
    assert "comp-999" in err["message"]

@pytest.mark.asyncio
async def test_500_error_redaction(async_client: AsyncClient):
    """Verify unhandled 500 errors never expose stack traces, secrets, or connection strings."""
    response = await async_client.get("/test-error/500")
    assert response.status_code == 500
    data = response.json()
    assert "error" in data
    err = data["error"]
    assert err["code"] == "INTERNAL_SERVER_ERROR"
    assert err["message"] == "An internal server error occurred. Please contact support or retry later."
    # Ensure zero leakage of secret or exception string
    content_str = response.text
    assert "SECRET_PASSWORD_123" not in content_str
    assert "postgresql://secret" not in content_str
    assert "RuntimeError" not in content_str
    assert "traceback" not in content_str.lower()

@pytest.mark.asyncio
async def test_request_size_limit_rejection(async_client: AsyncClient):
    """Verify payloads exceeding configured limit return HTTP 413 with safe error schema and X-Request-ID."""
    response = await async_client.post(
        "/test-error/upload-test",
        content=b"x" * 100,
        headers={"Content-Length": "15000000", "X-Request-ID": "req_size_test_123"}
    )
    assert response.status_code == 413
    data = response.json()
    assert data["error"]["code"] == "PAYLOAD_TOO_LARGE"
    assert response.headers.get("X-Request-ID") == "req_size_test_123"

@pytest.mark.asyncio
async def test_controlled_timeout_response(async_client: AsyncClient):
    """Verify long-running operations exceeding timeout budget return HTTP 504 with safe error schema and X-Request-ID."""
    response = await async_client.get(
        "/test-error/timeout-test",
        headers={"X-Request-ID": "req_timeout_test_456"}
    )
    assert response.status_code == 504
    data = response.json()
    assert data["error"]["code"] == "OPERATION_TIMEOUT"
    assert response.headers.get("X-Request-ID") == "req_timeout_test_456"
