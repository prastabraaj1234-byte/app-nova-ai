import logging
from datetime import datetime, timezone
from typing import Any, Dict, List, Optional
from fastapi import FastAPI, Request
from fastapi.exceptions import RequestValidationError
from fastapi.responses import JSONResponse
from starlette.exceptions import HTTPException as StarletteHTTPException
from src.logging import get_request_id

logger = logging.getLogger("nova.exceptions")

class NovaApiException(Exception):
    """Base exception class for Nova AI API domains."""
    def __init__(
        self,
        status_code: int = 500,
        error_code: str = "INTERNAL_SERVER_ERROR",
        message: str = "An unexpected error occurred.",
        details: Optional[Any] = None,
    ):
        super().__init__(message)
        self.status_code = status_code
        self.error_code = error_code
        self.message = message
        self.details = details

class ResourceNotFoundException(NovaApiException):
    def __init__(self, resource_type: str = "Resource", resource_id: str = ""):
        super().__init__(
            status_code=404,
            error_code="RESOURCE_NOT_FOUND",
            message=f"{resource_type} not found." if not resource_id else f"{resource_type} with ID '{resource_id}' not found."
        )

class UnauthorizedException(NovaApiException):
    def __init__(self, message: str = "Authentication required or invalid token."):
        super().__init__(
            status_code=401,
            error_code="UNAUTHORIZED",
            message=message
        )

class ForbiddenException(NovaApiException):
    def __init__(self, message: str = "You do not have permission to access this resource."):
        super().__init__(
            status_code=403,
            error_code="FORBIDDEN",
            message=message
        )

class RateLimitExceededException(NovaApiException):
    def __init__(self, message: str = "Rate limit exceeded. Please retry later."):
        super().__init__(
            status_code=429,
            error_code="RATE_LIMIT_EXCEEDED",
            message=message
        )

class DatabaseUnavailableException(NovaApiException):
    def __init__(self, message: str = "Database connection temporarily unavailable."):
        super().__init__(
            status_code=503,
            error_code="DATABASE_UNAVAILABLE",
            message=message
        )

def create_error_response(
    status_code: int,
    error_code: str,
    message: str,
    details: Optional[Any] = None,
) -> JSONResponse:
    """Helper to generate consistent API JSON error responses."""
    payload: Dict[str, Any] = {
        "error": {
            "code": error_code,
            "message": message,
            "request_id": get_request_id(),
            "timestamp": datetime.now(timezone.utc).isoformat(),
        }
    }
    if details is not None:
        payload["error"]["details"] = details
        
    return JSONResponse(status_code=status_code, content=payload)

def register_exception_handlers(app: FastAPI) -> None:
    """Register custom exception handlers with the FastAPI application."""
    
    @app.exception_handler(NovaApiException)
    async def nova_api_exception_handler(request: Request, exc: NovaApiException) -> JSONResponse:
        if exc.status_code >= 500:
            logger.error(f"NovaApiException: {exc.error_code} - {exc.message}", extra={"error_code": exc.error_code})
        else:
            logger.warning(f"NovaApiException: {exc.error_code} - {exc.message}", extra={"error_code": exc.error_code})
            
        return create_error_response(
            status_code=exc.status_code,
            error_code=exc.error_code,
            message=exc.message,
            details=exc.details,
        )

    @app.exception_handler(RequestValidationError)
    async def validation_exception_handler(request: Request, exc: RequestValidationError) -> JSONResponse:
        # Sanitize Pydantic errors to prevent leaking sensitive context
        sanitized_details: List[Dict[str, Any]] = []
        for error in exc.errors():
            loc = " -> ".join(str(x) for x in error.get("loc", []))
            sanitized_details.append({
                "field": loc,
                "message": error.get("msg", "Invalid value"),
                "type": error.get("type", "validation_error"),
            })
            
        logger.warning("Request validation failed", extra={"error_code": "VALIDATION_ERROR"})
        return create_error_response(
            status_code=422,
            error_code="VALIDATION_ERROR",
            message="The request payload failed validation.",
            details=sanitized_details,
        )

    @app.exception_handler(StarletteHTTPException)
    async def http_exception_handler(request: Request, exc: StarletteHTTPException) -> JSONResponse:
        error_code = "HTTP_ERROR"
        if exc.status_code == 404:
            error_code = "NOT_FOUND"
        elif exc.status_code == 405:
            error_code = "METHOD_NOT_ALLOWED"
        elif exc.status_code == 401:
            error_code = "UNAUTHORIZED"
        elif exc.status_code == 403:
            error_code = "FORBIDDEN"
        elif exc.status_code == 413:
            error_code = "PAYLOAD_TOO_LARGE"
            
        return create_error_response(
            status_code=exc.status_code,
            error_code=error_code,
            message=str(exc.detail),
        )

    @app.exception_handler(Exception)
    async def generic_exception_handler(request: Request, exc: Exception) -> JSONResponse:
        # Log the full stack trace server-side for debugging
        logger.critical("Unhandled internal exception caught", exc_info=exc, extra={"error_code": "INTERNAL_SERVER_ERROR"})
        
        # Never expose stack trace, credentials, connection strings, or internal implementation details to client!
        return create_error_response(
            status_code=500,
            error_code="INTERNAL_SERVER_ERROR",
            message="An internal server error occurred. Please contact support or retry later.",
        )
