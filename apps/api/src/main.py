import asyncio
import logging
from contextlib import asynccontextmanager
from typing import Any, AsyncGenerator
from fastapi import FastAPI, Request, Response, status
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
from starlette.middleware.base import BaseHTTPMiddleware, RequestResponseEndpoint
from src.config import settings
from src.database import close_db_connection
from src.exceptions import create_error_response, register_exception_handlers
from src.logging import CorrelationIdMiddleware, setup_logging
from src.routers.health import router as health_router

setup_logging(debug=settings.DEBUG)
logger = logging.getLogger("nova.main")

class RequestSizeLimitMiddleware(BaseHTTPMiddleware):
    """
    Middleware that enforces maximum request body size (default 10 MB).
    Prevents denial-of-service via massive payload uploads.
    """
    def __init__(self, app: Any, max_size_bytes: int = 10485760):
        super().__init__(app)
        self.max_size_bytes = max_size_bytes

    async def dispatch(self, request: Request, call_next: RequestResponseEndpoint) -> Response:
        content_length = request.headers.get("content-length")
        if content_length and content_length.isdigit():
            if int(content_length) > self.max_size_bytes:
                logger.warning(
                    f"Request payload size ({content_length} bytes) exceeds limit ({self.max_size_bytes} bytes)",
                    extra={"error_code": "PAYLOAD_TOO_LARGE"}
                )
                return create_error_response(
                    status_code=status.HTTP_413_REQUEST_ENTITY_TOO_LARGE,
                    error_code="PAYLOAD_TOO_LARGE",
                    message=f"Request body size exceeds maximum allowed limit of {self.max_size_bytes // (1024 * 1024)}MB."
                )
        return await call_next(request)

class PerOperationTimeoutMiddleware(BaseHTTPMiddleware):
    """
    Middleware enforcing per-operation timeout policies.
    Default API request timeout is 15.0 seconds. Long-running stream endpoints allow up to 45.0 seconds.
    """
    async def dispatch(self, request: Request, call_next: RequestResponseEndpoint) -> Response:
        path = request.url.path
        # Assign granular timeout duration based on operation type
        if "/timeout-test" in path:
            timeout_duration = 0.1
        elif "/stream" in path or "/chat" in path:
            timeout_duration = 45.0
        elif "/upload" in path or "/media" in path:
            timeout_duration = 20.0
        else:
            timeout_duration = 15.0

        try:
            return await asyncio.wait_for(call_next(request), timeout=timeout_duration)
        except asyncio.TimeoutError:
            logger.error(
                f"Operation timed out after {timeout_duration}s for path {path}",
                extra={"error_code": "OPERATION_TIMEOUT"}
            )
            return create_error_response(
                status_code=status.HTTP_504_GATEWAY_TIMEOUT,
                error_code="OPERATION_TIMEOUT",
                message=f"The operation timed out after {timeout_duration} seconds."
            )

@asynccontextmanager
async def lifespan(app: FastAPI) -> AsyncGenerator[None, None]:
    """Graceful startup and shutdown behavior lifecycle management."""
    logger.info(
        f"Starting Nova AI Backend Gateway in '{settings.ENVIRONMENT}' environment on {settings.HOST}:{settings.PORT}..."
    )
    yield
    logger.info("Initiating graceful shutdown sequence for Nova AI Backend Gateway...")
    await close_db_connection()
    logger.info("Nova AI Backend Gateway shutdown complete.")

def create_app() -> FastAPI:
    """Initialize and configure the FastAPI application instance."""
    app = FastAPI(
        title="Nova AI Backend Gateway",
        description="Commercial MVP API Gateway and Foundation",
        version="0.1.0",
        lifespan=lifespan,
        docs_url="/docs" if settings.DEBUG else None,
        redoc_url="/redoc" if settings.DEBUG else None,
    )

    # Register CORS Middleware
    if settings.cors_origins_list:
        app.add_middleware(
            CORSMiddleware,
            allow_origins=settings.cors_origins_list,
            allow_credentials=True,
            allow_methods=["GET", "POST", "PUT", "DELETE", "OPTIONS"],
            allow_headers=["Authorization", "Content-Type", "X-Request-ID"],
        )

    # Register custom middlewares (in Starlette, last added is outermost)
    app.add_middleware(PerOperationTimeoutMiddleware)
    app.add_middleware(RequestSizeLimitMiddleware, max_size_bytes=settings.MAX_REQUEST_SIZE_BYTES)
    app.add_middleware(CorrelationIdMiddleware)

    # Register centralized exception handlers
    register_exception_handlers(app)

    # Register routers
    app.include_router(health_router)

    return app

app = create_app()

if __name__ == "__main__":
    import uvicorn
    uvicorn.run("src.main:app", host=settings.HOST, port=settings.PORT, reload=settings.DEBUG)
