import pytest
from unittest.mock import patch
from httpx import AsyncClient

@pytest.mark.asyncio
async def test_liveness_endpoint(async_client: AsyncClient):
    """Verify that liveness endpoint returns HTTP 200 and ok status."""
    response = await async_client.get("/healthz")
    assert response.status_code == 200
    data = response.json()
    assert data["status"] == "ok"
    assert "request_id" in data

@pytest.mark.asyncio
async def test_liveness_v1_alias(async_client: AsyncClient):
    """Verify alias /api/v1/health/liveness."""
    response = await async_client.get("/api/v1/health/liveness")
    assert response.status_code == 200
    assert response.json()["status"] == "ok"

@pytest.mark.asyncio
async def test_liveness_remains_healthy_when_db_unavailable(async_client: AsyncClient):
    """Verify liveness remains healthy HTTP 200 even when database check returns False."""
    with patch("src.routers.health.check_db_readiness", return_value=False):
        response = await async_client.get("/healthz")
        assert response.status_code == 200
        assert response.json()["status"] == "ok"

@pytest.mark.asyncio
async def test_readiness_success(async_client: AsyncClient):
    """Verify readiness returns success when database dependency is healthy."""
    with patch("src.routers.health.check_db_readiness", return_value=True):
        response = await async_client.get("/readyz")
        assert response.status_code == 200
        data = response.json()
        assert data["status"] == "ready"
        assert data["database"] == "ok"
        assert "request_id" in data

@pytest.mark.asyncio
async def test_readiness_failure_controlled(async_client: AsyncClient):
    """Verify readiness returns HTTP 503 controlled failure when database is unavailable."""
    with patch("src.routers.health.check_db_readiness", return_value=False):
        response = await async_client.get("/readyz")
        assert response.status_code == 503
        data = response.json()
        assert data["status"] == "unhealthy"
        assert data["database"] == "unavailable"
        assert "request_id" in data
