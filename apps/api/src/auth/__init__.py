"""
Authentication abstractions, security dependencies, and rate limiters for Nova AI Backend Gateway.
"""
from src.auth.provider import AuthProvider, FirebaseAuthProvider, AuthUser, auth_provider
from src.auth.dependencies import get_current_user, get_current_active_user
from src.auth.rate_limit import auth_rate_limiter

__all__ = [
    "AuthProvider",
    "FirebaseAuthProvider",
    "AuthUser",
    "auth_provider",
    "get_current_user",
    "get_current_active_user",
    "auth_rate_limiter",
]
