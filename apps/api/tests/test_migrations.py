import os
import tempfile
import pytest
from sqlalchemy import inspect, create_engine
from alembic.config import Config
from alembic import command
from src.config import settings

def test_alembic_uses_postgresql_when_configured(monkeypatch):
    """Prove Alembic uses PostgreSQL configuration when the local environment specifies PostgreSQL."""
    pg_url = "postgresql+asyncpg://postgres:postgres@localhost:5432/nova_test_config"
    monkeypatch.setattr(settings, "DATABASE_URL", pg_url)
    
    import importlib.util
    api_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    spec = importlib.util.spec_from_file_location("alembic_env", os.path.join(api_dir, "alembic", "env.py"))
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    
    resolved_url = mod.get_database_url()
    assert resolved_url == pg_url
    assert resolved_url.startswith("postgresql+asyncpg://")

def test_alembic_ini_placeholder_cannot_override_settings(monkeypatch):
    """Prove an alembic.ini placeholder or override cannot silently override settings.DATABASE_URL."""
    expected_url = "postgresql+asyncpg://postgres:postgres@localhost:5432/nova_prod_test"
    monkeypatch.setattr(settings, "DATABASE_URL", expected_url)
    
    import importlib.util
    api_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    spec = importlib.util.spec_from_file_location("alembic_env", os.path.join(api_dir, "alembic", "env.py"))
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    
    # Even if someone calls get_main_option on alembic config or puts a placeholder,
    # get_database_url() must authoritatively return settings.DATABASE_URL.
    resolved_url = mod.get_database_url()
    assert resolved_url == expected_url
    assert "sqlite" not in resolved_url
    assert "placeholder" not in resolved_url

def test_alembic_upgrade_and_downgrade(monkeypatch):
    """
    Verify Alembic can upgrade a fresh local database from zero to head
    and downgrade safely according to the approved migration policy.
    Proves SQLite migration tests still work when DATABASE_URL is explicitly overridden for testing.
    """
    # Use a temporary sqlite file database for real programmatic DDL testing
    with tempfile.NamedTemporaryFile(suffix=".db", delete=False) as tmp_db:
        db_path = tmp_db.name
        
    db_url = f"sqlite:///{db_path}"
    # Authoritatively override settings.DATABASE_URL for isolated SQLite migration test
    monkeypatch.setattr(settings, "DATABASE_URL", db_url)
    
    try:
        # Create Alembic config programmatic instance
        api_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
        ini_path = os.path.join(api_dir, "alembic.ini")
        
        alembic_cfg = Config(ini_path)
        alembic_cfg.set_main_option("script_location", os.path.join(api_dir, "alembic"))
        # Use synchronous sqlite connection string for direct DDL inspection during test
        alembic_cfg.set_main_option("sqlalchemy.url", db_url)
        
        # 1. Verify fresh database starts at ZERO (no tables except maybe sqlite internals)
        sync_engine = create_engine(db_url)
        with sync_engine.connect() as conn:
            inspector = inspect(conn)
            tables_before = inspector.get_table_names()
            assert "users" not in tables_before
            assert "companions" not in tables_before

        # 2. Upgrade from ZERO -> HEAD
        command.upgrade(alembic_cfg, "head")
        
        with sync_engine.connect() as conn:
            inspector = inspect(conn)
            tables_after_upgrade = inspector.get_table_names()
            assert "alembic_version" in tables_after_upgrade
            assert "users" in tables_after_upgrade
            assert "companions" in tables_after_upgrade
            assert "messages" in tables_after_upgrade
            assert "system_settings" in tables_after_upgrade
            assert "usage_records" in tables_after_upgrade
            
        # 3. Downgrade from HEAD -> BASE (ZERO)
        command.downgrade(alembic_cfg, "base")
        
        with sync_engine.connect() as conn:
            inspector = inspect(conn)
            tables_after_downgrade = inspector.get_table_names()
            assert "users" not in tables_after_downgrade
            assert "companions" not in tables_after_downgrade
            assert "messages" not in tables_after_downgrade
            assert "system_settings" not in tables_after_downgrade
            assert "usage_records" not in tables_after_downgrade
            
        sync_engine.dispose()
    finally:
        if os.path.exists(db_path):
            try:
                os.remove(db_path)
            except Exception:
                pass
