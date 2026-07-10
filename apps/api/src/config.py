import os
from typing import List
from pydantic_settings import BaseSettings, SettingsConfigDict
from pydantic import Field, field_validator, model_validator

class Settings(BaseSettings):
    """
    Typed configuration and environment loading for Nova AI Backend Gateway.
    Loads from environment variables or '.env' file if present.
    """
    model_config = SettingsConfigDict(
        env_file=os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), ".env"),
        env_file_encoding="utf-8",
        extra="ignore",
    )

    # Environment
    ENVIRONMENT: str = Field(default="local", description="Runtime environment: local, development, staging, production")
    DEBUG: bool = Field(default=True, description="Enable debug mode and verbose log outputs")

    # Server Configuration
    HOST: str = Field(default="0.0.0.0", description="Server bind host")
    PORT: int = Field(default=8000, description="Server bind port")
    MAX_REQUEST_SIZE_BYTES: int = Field(default=10485760, description="Maximum request body size in bytes (default 10MB)")

    # Database Configuration
    DATABASE_URL: str = Field(
        default="sqlite+aiosqlite:///:memory:",
        description="Async SQLAlchemy database connection string"
    )
    DATABASE_POOL_SIZE: int = Field(default=10, description="SQLAlchemy connection pool size")
    DATABASE_MAX_OVERFLOW: int = Field(default=20, description="SQLAlchemy max pool overflow")
    DATABASE_POOL_TIMEOUT: int = Field(default=30, description="SQLAlchemy pool timeout in seconds")

    # CORS Configuration
    ALLOWED_ORIGINS: str = Field(
        default="http://localhost:8088,http://localhost:3000,http://localhost:8000,capacitor://localhost",
        description="Comma-separated list of allowed CORS origins"
    )

    # Future Phase Placeholders (Optional in Phase 1A)
    GEMINI_API_KEY: str = Field(default="", description="Google Gemini API Key placeholder")
    FIREBASE_PROJECT_ID: str = Field(default="", description="Firebase Project ID placeholder")

    @property
    def cors_origins_list(self) -> List[str]:
        if not self.ALLOWED_ORIGINS:
            return []
        return [origin.strip() for origin in self.ALLOWED_ORIGINS.split(",") if origin.strip()]

    @field_validator("DATABASE_URL")
    @classmethod
    def validate_database_url(cls, v: str) -> str:
        if not v or "://" not in v:
            raise ValueError("Configuration Error: Malformed DATABASE_URL connection string.")
        # Ensure postgresql urls use asyncpg driver
        if v.startswith("postgresql://"):
            return v.replace("postgresql://", "postgresql+asyncpg://", 1)
        elif v.startswith("sqlite://") and not v.startswith("sqlite+aiosqlite://"):
            return v.replace("sqlite://", "sqlite+aiosqlite://", 1)
        return v

    @model_validator(mode="after")
    def validate_production_fail_closed(self) -> "Settings":
        """
        Enforce fail-closed security for production and staging environments.
        Prevent starting with placeholder secrets, default passwords, wildcard CORS, or debug mode.
        """
        if self.ENVIRONMENT.lower() in ("production", "prod", "staging"):
            if self.DEBUG:
                raise ValueError("Configuration Error: DEBUG mode cannot be enabled in production environment.")
            if "*" in self.cors_origins_list:
                raise ValueError("Configuration Error: Wildcard CORS origin ('*') is not allowed in production environment.")
            if not self.DATABASE_URL.startswith("postgresql+asyncpg://"):
                raise ValueError("Configuration Error: Production environment requires an async PostgreSQL database URL (postgresql+asyncpg://...).")
            
            lower_url = self.DATABASE_URL.lower()
            for bad_pwd in (":postgres@", ":password@", ":123456@", ":admin@", ":root@", ":secret@"):
                if bad_pwd in lower_url:
                    raise ValueError("Configuration Error: Default or unsafe database password detected in production DATABASE_URL.")
            
            for placeholder in ("your_", "placeholder", "dummy", "simulated", "test_key"):
                if placeholder in self.GEMINI_API_KEY.lower() or placeholder in self.FIREBASE_PROJECT_ID.lower():
                    raise ValueError("Configuration Error: Placeholder secrets cannot be used in production environment.")
        return self

# Singleton settings instance
settings = Settings()
