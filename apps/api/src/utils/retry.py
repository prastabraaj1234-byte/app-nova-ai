import asyncio
import logging
import random
from functools import wraps
from typing import Any, Callable, Coroutine, Tuple, Type, TypeVar

logger = logging.getLogger("nova.utils.retry")

T = TypeVar("T")

def retry_async(
    max_retries: int = 3,
    base_delay_seconds: float = 0.5,
    max_delay_seconds: float = 10.0,
    retryable_exceptions: Tuple[Type[Exception], ...] = (Exception,),
) -> Callable[[Callable[..., Coroutine[Any, Any, T]]], Callable[..., Coroutine[Any, Any, T]]]:
    """
    Decorator for async functions implementing bounded exponential backoff with full jitter.
    ONLY retries exceptions explicitly listed in `retryable_exceptions`.
    """
    def decorator(func: Callable[..., Coroutine[Any, Any, T]]) -> Callable[..., Coroutine[Any, Any, T]]:
        @wraps(func)
        async def wrapper(*args: Any, **kwargs: Any) -> T:
            attempt = 0
            while True:
                try:
                    return await func(*args, **kwargs)
                except retryable_exceptions as exc:
                    attempt += 1
                    if attempt > max_retries:
                        logger.error(
                            f"Function '{func.__name__}' failed after {max_retries} retries. Raising exception.",
                            exc_info=exc,
                            extra={"attempt": attempt, "max_retries": max_retries}
                        )
                        raise exc
                    
                    # Calculate bounded exponential backoff: base * 2^(attempt - 1)
                    exponential_backoff = min(max_delay_seconds, base_delay_seconds * (2 ** (attempt - 1)))
                    # Apply full jitter: random value between 0 and calculated exponential backoff
                    sleep_time = random.uniform(0.1, exponential_backoff)
                    
                    logger.warning(
                        f"Retryable exception in '{func.__name__}' (attempt {attempt}/{max_retries}). "
                        f"Retrying in {sleep_time:.2f}s... Error: {str(exc)}",
                        extra={"attempt": attempt, "sleep_time": round(sleep_time, 2)}
                    )
                    await asyncio.sleep(sleep_time)
        return wrapper
    return decorator
