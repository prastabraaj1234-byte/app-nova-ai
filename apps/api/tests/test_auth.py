"""
Tests for authentication, just-in-time user provisioning, and account status enforcement.
"""
import pytest
from httpx import AsyncClient, ASGITransport
from sqlalchemy import select
from src.main import app
from src.database import get_db
from src.models.user import User


@pytest.mark.asyncio
async def test_auth_missing_token_returns_401(async_client):
    response = await async_client.get("/api/v1/users/me")
    assert response.status_code == 401
    assert "Missing Authorization Bearer token" in response.text


@pytest.mark.asyncio
async def test_auth_jit_user_provisioning(async_client):
    """Prove that sending a valid dev token auto-provisions canonical User record in ACTIVE state."""
    headers = {"Authorization": "Bearer dev-token:test_user_alpha:alpha@example.com"}
    response = await async_client.get("/api/v1/users/me", headers=headers)
    assert response.status_code == 200
    data = response.json()
    assert data["id"] == "test_user_alpha"
    assert data["email"] == "alpha@example.com"
    assert data["status"] == "ACTIVE"


@pytest.mark.asyncio
async def test_auth_rejects_suspended_user(async_client, db_session):
    """Prove that an account with SUSPENDED status is rejected with HTTP 403."""
    suspended_user = User(
        id="user_suspended",
        email="suspended@example.com",
        status="SUSPENDED"
    )
    db_session.add(suspended_user)
    await db_session.commit()

    headers = {"Authorization": "Bearer dev-token:user_suspended:suspended@example.com"}
    response = await async_client.get("/api/v1/users/me", headers=headers)
    assert response.status_code == 403
    assert "Account status is SUSPENDED" in response.text


@pytest.mark.asyncio
async def test_auth_rejects_deleting_user(async_client, db_session):
    """Prove that an account in DELETING state is rejected with HTTP 403."""
    deleting_user = User(
        id="user_deleting",
        email="deleting@example.com",
        status="DELETING"
    )
    db_session.add(deleting_user)
    await db_session.commit()

    headers = {"Authorization": "Bearer dev-token:user_deleting:deleting@example.com"}
    response = await async_client.get("/api/v1/users/me", headers=headers)
    assert response.status_code == 403
    assert "Account status is DELETING" in response.text
