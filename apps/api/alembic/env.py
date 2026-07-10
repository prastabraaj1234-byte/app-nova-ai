import asyncio
import os
import sys
from logging.config import fileConfig

# Ensure apps/api is always in sys.path so 'src' can be imported regardless of working directory
api_root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
if api_root not in sys.path:
    sys.path.insert(0, api_root)

from sqlalchemy import pool
from sqlalchemy.engine import Connection
from sqlalchemy.ext.asyncio import async_engine_from_config
from alembic import context
from src.config import settings
from src.database import Base
# Import all models so Base.metadata contains the full schema definitions
from src.models import *

config = getattr(context, "config", None)

if config is not None and getattr(config, "config_file_name", None) is not None:
    fileConfig(config.config_file_name)

target_metadata = Base.metadata

def get_database_url() -> str:
    """Retrieve database URL authoritatively from Pydantic settings.DATABASE_URL.
    
    In accordance with ADR-001 and local development architecture, Alembic and
    FastAPI share the exact same Settings-driven DATABASE_URL configuration.
    Any static placeholder or hardcoded override in alembic.ini is ignored so that
    the environment configuration remains authoritative.
    """
    url = settings.DATABASE_URL
    # Ensure async drivers are used for online async migrations
    if url.startswith("postgresql://"):
        url = url.replace("postgresql://", "postgresql+asyncpg://", 1)
    elif url.startswith("sqlite://") and not url.startswith("sqlite+aiosqlite://"):
        url = url.replace("sqlite://", "sqlite+aiosqlite://", 1)
    return url

def run_migrations_offline() -> None:
    """Run migrations in 'offline' mode."""
    url = get_database_url()
    context.configure(
        url=url,
        target_metadata=target_metadata,
        literal_binds=True,
        dialect_opts={"paramstyle": "named"},
    )

    with context.begin_transaction():
        context.run_migrations()

def do_run_migrations(connection: Connection) -> None:
    context.configure(connection=connection, target_metadata=target_metadata)
    with context.begin_transaction():
        context.run_migrations()

async def run_async_migrations() -> None:
    """In this scenario we need to create an Engine and associate a connection with the context."""
    configuration = config.get_section(config.config_ini_section, {})
    configuration["sqlalchemy.url"] = get_database_url()

    connectable = async_engine_from_config(
        configuration,
        prefix="sqlalchemy.",
        poolclass=pool.NullPool,
    )

    async with connectable.connect() as connection:
        await connection.run_sync(do_run_migrations)

    await connectable.dispose()

def run_migrations_online() -> None:
    """Run migrations in 'online' mode."""
    asyncio.run(run_async_migrations())

if getattr(context, "_proxy", None) is not None:
    if context.is_offline_mode():
        run_migrations_offline()
    else:
        run_migrations_online()
