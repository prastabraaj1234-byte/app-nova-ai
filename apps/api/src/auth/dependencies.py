"""
FastAPI security dependencies for authentication, user provisioning, and tenant isolation.
"""
from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from src.database import get_db
from src.models.user import User
from src.auth.provider import auth_provider

security_scheme = HTTPBearer(auto_error=False)


async def get_current_user(
    credentials: HTTPAuthorizationCredentials | None = Depends(security_scheme),
    db: AsyncSession = Depends(get_db)
) -> User:
    """
    Extract token from Authorization header, verify identity via AuthProvider,
    and return the canonical User database model.
    Automatically provisions new users on first login (Just-In-Time provisioning).
    Enforces account status policies (ACTIVE only).
    """
    if not credentials or not credentials.credentials:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Missing Authorization Bearer token"
        )

    auth_user = await auth_provider.verify_token(credentials.credentials)

    # Query canonical User from database
    result = await db.execute(select(User).where(User.id == auth_user.uid))
    user = result.scalar_one_or_none()

    if not user:
        # Just-In-Time provisioning of canonical user account
        user = User(
            id=auth_user.uid,
            email=auth_user.email,
            display_name=auth_user.display_name,
            status="ACTIVE"
        )
        db.add(user)
        await db.commit()
        await db.refresh(user)

    # Enforce server-side account status
    if user.status != "ACTIVE":
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail=f"Account status is {user.status}. Access denied."
        )

    return user


async def get_current_active_user(
    current_user: User = Depends(get_current_user)
) -> User:
    """Dependency that guarantees the caller is an authenticated ACTIVE user."""
    return current_user
