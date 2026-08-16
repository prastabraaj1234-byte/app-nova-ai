"""
Authentication provider abstractions for verifying incoming ID tokens.
Supports Firebase Authentication ID tokens and local development/test tokens.
"""
import abc
from dataclasses import dataclass
from typing import Optional
from fastapi import HTTPException, status
from src.config import settings

@dataclass
class AuthUser:
    """Represent an authenticated user identity extracted from ID token."""
    uid: str
    email: Optional[str] = None
    display_name: Optional[str] = None


class AuthProvider(abc.ABC):
    """Abstract base class for authentication token verifiers."""

    @abc.abstractmethod
    async def verify_token(self, token: str) -> AuthUser:
        """
        Verify bearer token string and return AuthUser.
        Raises HTTPException(401) if token is invalid or expired.
        """
        pass


class FirebaseAuthProvider(AuthProvider):
    """
    Firebase Authentication token verifier.
    Supports secure dev tokens ('dev-token:uid:email') when AUTH_DEV_MODE is enabled
    for isolated local Pytest and offline MVP verification without cloud credentials.
    """

    def __init__(self):
        self._admin_initialized = False

    async def verify_token(self, token: str) -> AuthUser:
        if not token or not token.strip():
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Authentication credentials missing or empty string"
            )

        token = token.strip()

        # Handle local development / testing tokens when enabled
        if getattr(settings, "AUTH_DEV_MODE", True):
            if token.startswith("dev-token:"):
                parts = token.split(":")
                if len(parts) >= 2 and parts[1].strip():
                    uid = parts[1].strip()
                    email = parts[2].strip() if len(parts) >= 3 else f"{uid}@example.com"
                    return AuthUser(uid=uid, email=email, display_name=uid)

        # Attempt Firebase Admin verification if initialized / available
        try:
            import firebase_admin
            from firebase_admin import auth as firebase_auth

            if not self._admin_initialized:
                try:
                    firebase_admin.get_app()
                except ValueError:
                    # Not initialized yet
                    pass

            decoded_token = firebase_auth.verify_id_token(token)
            return AuthUser(
                uid=decoded_token["uid"],
                email=decoded_token.get("email"),
                display_name=decoded_token.get("name")
            )
        except ImportError:
            # firebase_admin not installed or not active
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Firebase ID token verification unavailable. Check authentication configuration."
            )
        except Exception as exc:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail=f"Invalid authentication token: {str(exc)}"
            )

# Global singleton provider instance
auth_provider = FirebaseAuthProvider()
