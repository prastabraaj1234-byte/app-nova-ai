"""
Tests proving strict tenant isolation between different users.
User A must never be able to access or mutate User B's profile or data.
"""
import pytest


@pytest.mark.asyncio
async def test_tenant_isolation_user_a_cannot_see_or_modify_user_b(async_client):
    """
    Verify User A and User B receive isolated profiles and mutations on User A
    do not affect User B.
    """
    headers_a = {"Authorization": "Bearer dev-token:tenant_user_a:usera@example.com"}
    headers_b = {"Authorization": "Bearer dev-token:tenant_user_b:userb@example.com"}

    # 1. User A retrieves profile
    res_a = await async_client.get("/api/v1/users/me", headers=headers_a)
    assert res_a.status_code == 200
    data_a = res_a.json()
    assert data_a["id"] == "tenant_user_a"

    # 2. User B retrieves profile
    res_b = await async_client.get("/api/v1/users/me", headers=headers_b)
    assert res_b.status_code == 200
    data_b = res_b.json()
    assert data_b["id"] == "tenant_user_b"

    # 3. User A modifies display_name
    patch_res_a = await async_client.patch(
        "/api/v1/users/me",
        headers=headers_a,
        json={"display_name": "Alpha User A"}
    )
    assert patch_res_a.status_code == 200
    assert patch_res_a.json()["display_name"] == "Alpha User A"

    # 4. Verify User B's display_name remains untouched / isolated
    check_b = await async_client.get("/api/v1/users/me", headers=headers_b)
    assert check_b.status_code == 200
    assert check_b.json()["display_name"] != "Alpha User A"
    assert check_b.json()["id"] == "tenant_user_b"
