"""
Authentication rate limiter dependency to prevent brute-force and token validation flooding.
"""
import time
from collections import defaultdict
from fastapi import HTTPException, Request, status

class AuthRateLimiter:
    """
    In-memory sliding window rate limiter for auth operations.
    Limits requests per IP address within a configurable window.
    """
    def __init__(self, max_requests: int = 60, window_seconds: int = 60):
        self.max_requests = max_requests
        self.window_seconds = window_seconds
        self.requests = defaultdict(list)

    async def __call__(self, request: Request):
        client_ip = request.client.host if request.client else "unknown"
        now = time.time()
        window_start = now - self.window_seconds

        # Clean old timestamps
        self.requests[client_ip] = [
            ts for ts in self.requests[client_ip] if ts > window_start
        ]

        if len(self.requests[client_ip]) >= self.max_requests:
            raise HTTPException(
                status_code=status.HTTP_429_TOO_MANY_REQUESTS,
                detail="Too many authentication requests. Please try again later."
            )

        self.requests[client_ip].append(now)

auth_rate_limiter = AuthRateLimiter(max_requests=100, window_seconds=60)
