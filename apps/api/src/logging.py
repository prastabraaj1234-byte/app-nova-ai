import json
import logging
import re
import time
import uuid
from contextvars import ContextVar
from datetime import datetime, timezone
from typing import Any, Dict
from fastapi import Request, Response
from starlette.middleware.base import BaseHTTPMiddleware, RequestResponseEndpoint

# Strict alphanumeric regex preventing CRLF log injection and limiting length to 64 chars
VALID_REQUEST_ID_REGEX = re.compile(r"^[a-zA-Z0-9_\-\.]{1,64}$")

# ContextVar to store and propagate correlation X-Request-ID across async tasks
request_id_ctx_var: ContextVar[str] = ContextVar("request_id", default="n/a")

def get_request_id() -> str:
    """Retrieve the current async context correlation X-Request-ID."""
    return request_id_ctx_var.get()

class StructuredJsonFormatter(logging.Formatter):
    """Formats log records into structured JSON dictionaries."""
    def format(self, record: logging.LogRecord) -> str:
        log_obj: Dict[str, Any] = {
            "timestamp": datetime.fromtimestamp(record.created, tz=timezone.utc).isoformat(),
            "level": record.levelname,
            "logger": record.name,
            "message": record.getMessage(),
            "x_request_id": get_request_id(),
        }
        
        # Add extra fields if present
        if hasattr(record, "method"):
            log_obj["method"] = getattr(record, "method")
        if hasattr(record, "path"):
            log_obj["path"] = getattr(record, "path")
        if hasattr(record, "status_code"):
            log_obj["status_code"] = getattr(record, "status_code")
        if hasattr(record, "duration_ms"):
            log_obj["duration_ms"] = getattr(record, "duration_ms")
        if hasattr(record, "error_code"):
            log_obj["error_code"] = getattr(record, "error_code")
            
        if record.exc_info:
            log_obj["exception"] = self.formatException(record.exc_info)
            
        return json.dumps(log_obj)

def setup_logging(debug: bool = False) -> None:
    """Configure root logger to output structured JSON format to console."""
    root_logger = logging.getLogger()
    root_logger.setLevel(logging.DEBUG if debug else logging.INFO)
    
    # Remove existing handlers to prevent duplicate output
    for handler in list(root_logger.handlers):
        root_logger.removeHandler(handler)
        
    console_handler = logging.StreamHandler()
    console_handler.setFormatter(StructuredJsonFormatter())
    root_logger.addHandler(console_handler)

class CorrelationIdMiddleware(BaseHTTPMiddleware):
    """
    Middleware that generates or validates X-Request-ID, binds it to contextvars,
    logs request/response lifecycle in structured JSON, and appends X-Request-ID to response headers.
    """
    async def dispatch(self, request: Request, call_next: RequestResponseEndpoint) -> Response:
        # Extract existing X-Request-ID and validate against strict regex
        req_id = request.headers.get("X-Request-ID", "").strip()
        if not req_id or not VALID_REQUEST_ID_REGEX.match(req_id):
            req_id = str(uuid.uuid4())
            
        # Bind to async context variable
        token = request_id_ctx_var.set(req_id)
        start_time = time.perf_counter()
        
        logger = logging.getLogger("nova.access")
        
        try:
            response = await call_next(request)
            duration_ms = round((time.perf_counter() - start_time) * 1000, 2)
            
            # Attach X-Request-ID header to outbound response
            response.headers["X-Request-ID"] = req_id
            
            # Log successful request
            logger.info(
                f"HTTP {request.method} {request.url.path} completed in {duration_ms}ms",
                extra={
                    "method": request.method,
                    "path": request.url.path,
                    "status_code": response.status_code,
                    "duration_ms": duration_ms,
                }
            )
            return response
        except Exception as exc:
            duration_ms = round((time.perf_counter() - start_time) * 1000, 2)
            logger.error(
                f"HTTP {request.method} {request.url.path} failed with unhandled exception",
                exc_info=exc,
                extra={
                    "method": request.method,
                    "path": request.url.path,
                    "status_code": 500,
                    "duration_ms": duration_ms,
                }
            )
            raise exc
        finally:
            request_id_ctx_var.reset(token)
