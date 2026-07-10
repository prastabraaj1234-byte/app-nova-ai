import asyncio
import pytest
from src.utils.retry import retry_async

@pytest.mark.asyncio
async def test_retry_success_after_failures():
    """Verify function retries on allowed exception and succeeds before max retries."""
    attempt_count = 0

    @retry_async(max_retries=3, base_delay_seconds=0.01, max_delay_seconds=0.1, retryable_exceptions=(ConnectionError,))
    async def flaky_operation():
        nonlocal attempt_count
        attempt_count += 1
        if attempt_count < 3:
            raise ConnectionError("Temporary network drop")
        return "SUCCESS"

    result = await flaky_operation()
    assert result == "SUCCESS"
    assert attempt_count == 3

@pytest.mark.asyncio
async def test_retry_does_not_retry_unlisted_exceptions():
    """Verify decorator does NOT retry exceptions not included in retryable_exceptions."""
    attempt_count = 0

    @retry_async(max_retries=3, base_delay_seconds=0.01, retryable_exceptions=(ConnectionError,))
    async def failing_operation():
        nonlocal attempt_count
        attempt_count += 1
        raise ValueError("Invalid argument - should not be retried")

    with pytest.raises(ValueError, match="Invalid argument"):
        await failing_operation()
    assert attempt_count == 1  # Exactly 1 attempt, zero retries!

@pytest.mark.asyncio
async def test_retry_exhausted_raises_exception():
    """Verify function raises exception once max_retries is exceeded."""
    attempt_count = 0

    @retry_async(max_retries=2, base_delay_seconds=0.01, retryable_exceptions=(TimeoutError,))
    async def always_timeout():
        nonlocal attempt_count
        attempt_count += 1
        raise TimeoutError("Gateway timeout")

    with pytest.raises(TimeoutError, match="Gateway timeout"):
        await always_timeout()
    assert attempt_count == 3  # Initial try + 2 retries = 3 attempts
