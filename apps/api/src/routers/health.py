from fastapi import APIRouter, Response, status
from fastapi.responses import JSONResponse
from src.database import check_db_readiness
from src.logging import get_request_id

router = APIRouter(tags=["Health & Readiness"])

@router.get("/healthz", summary="Liveness Probe")
@router.get("/api/v1/health/liveness", summary="Liveness Probe")
async def liveness_check() -> JSONResponse:
    """
    Instant in-memory liveness check.
    Confirms the FastAPI process is running and able to handle requests.
    """
    return JSONResponse(
        status_code=status.HTTP_200_OK,
        content={
            "status": "ok",
            "request_id": get_request_id(),
        }
    )

@router.get("/readyz", summary="Readiness Probe")
@router.get("/api/v1/health/readiness", summary="Readiness Probe")
async def readiness_check() -> JSONResponse:
    """
    Dependency readiness probe.
    Returns HTTP 200 only when required dependencies (database) are ready.
    Returns HTTP 503 Service Unavailable when database connection is down.
    """
    db_ready = await check_db_readiness()
    
    if db_ready:
        return JSONResponse(
            status_code=status.HTTP_200_OK,
            content={
                "status": "ready",
                "database": "ok",
                "request_id": get_request_id(),
            }
        )
    else:
        return JSONResponse(
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
            content={
                "status": "unhealthy",
                "database": "unavailable",
                "request_id": get_request_id(),
            }
        )
