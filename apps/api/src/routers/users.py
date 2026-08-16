"""
User management API endpoints for Nova AI Backend Gateway.
Enforces strict tenant isolation: callers can only read/modify their own User profile (`/me`).
"""
from datetime import datetime
from typing import Optional
from fastapi import APIRouter, Depends, HTTPException, status
from pydantic import BaseModel
from sqlalchemy.ext.asyncio import AsyncSession

from src.database import get_db
from src.models.user import User
from src.auth.dependencies import get_current_active_user
from src.auth.rate_limit import auth_rate_limiter

router = APIRouter(prefix="/api/v1/users", tags=["users"])


class UserResponse(BaseModel):
    id: str
    email: Optional[str] = None
    display_name: Optional[str] = None
    status: str
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True


class UserUpdateRequest(BaseModel):
    display_name: Optional[str] = None


@router.get(
    "/me",
    response_model=UserResponse,
    dependencies=[Depends(auth_rate_limiter)],
    summary="Get current user profile"
)
async def get_my_profile(
    current_user: User = Depends(get_current_active_user)
) -> UserResponse:
    """Return canonical profile of the currently authenticated active user."""
    return UserResponse.model_validate(current_user)


@router.patch(
    "/me",
    response_model=UserResponse,
    dependencies=[Depends(auth_rate_limiter)],
    summary="Update current user profile"
)
async def update_my_profile(
    update_data: UserUpdateRequest,
    current_user: User = Depends(get_current_active_user),
    db: AsyncSession = Depends(get_db)
) -> UserResponse:
    """Update profile metadata (e.g. display_name) for current user."""
    if update_data.display_name is not None:
        current_user.display_name = update_data.display_name

    db.add(current_user)
    await db.commit()
    await db.refresh(current_user)
    return UserResponse.model_validate(current_user)
