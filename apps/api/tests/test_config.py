import pytest
from pydantic import ValidationError
from src.config import Settings

def test_local_environment_defaults():
    """Verify local development can use local-only defaults safely."""
    settings = Settings(ENVIRONMENT="local", DEBUG=True, DATABASE_URL="sqlite+aiosqlite:///:memory:")
    assert settings.ENVIRONMENT == "local"
    assert settings.DEBUG is True

def test_production_fails_when_debug_true():
    """Verify production mode fails startup if DEBUG is True."""
    with pytest.raises(ValidationError) as exc_info:
        Settings(
            ENVIRONMENT="production",
            DEBUG=True,
            DATABASE_URL="postgresql+asyncpg://user:SecurePass123!@db.host.com/prod_db",
            ALLOWED_ORIGINS="https://nova.ai"
        )
    assert "DEBUG mode cannot be enabled in production" in str(exc_info.value)

def test_production_fails_with_wildcard_cors():
    """Verify production mode fails startup if wildcard '*' is in ALLOWED_ORIGINS."""
    with pytest.raises(ValidationError) as exc_info:
        Settings(
            ENVIRONMENT="production",
            DEBUG=False,
            DATABASE_URL="postgresql+asyncpg://user:SecurePass123!@db.host.com/prod_db",
            ALLOWED_ORIGINS="https://nova.ai, *"
        )
    assert "Wildcard CORS origin ('*') is not allowed in production" in str(exc_info.value)

def test_production_fails_with_default_db_password():
    """Verify production mode fails startup if default DB password (like :postgres@) is used."""
    with pytest.raises(ValidationError) as exc_info:
        Settings(
            ENVIRONMENT="production",
            DEBUG=False,
            DATABASE_URL="postgresql+asyncpg://postgres:postgres@localhost:5432/nova_db",
            ALLOWED_ORIGINS="https://nova.ai"
        )
    assert "Default or unsafe database password detected in production" in str(exc_info.value)

def test_production_fails_with_placeholder_secrets():
    """Verify production mode fails startup if placeholder secrets are used."""
    with pytest.raises(ValidationError) as exc_info:
        Settings(
            ENVIRONMENT="production",
            DEBUG=False,
            DATABASE_URL="postgresql+asyncpg://user:SecurePass123!@db.host.com/prod_db",
            ALLOWED_ORIGINS="https://nova.ai",
            GEMINI_API_KEY="your_gemini_api_key_placeholder"
        )
    assert "Placeholder secrets cannot be used in production" in str(exc_info.value)

def test_malformed_database_url_fails():
    """Verify malformed database connection string raises ValidationError."""
    with pytest.raises(ValidationError) as exc_info:
        Settings(DATABASE_URL="invalid_connection_string_without_protocol")
    assert "Malformed DATABASE_URL connection string" in str(exc_info.value)
