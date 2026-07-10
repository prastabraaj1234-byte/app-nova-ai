from datetime import datetime, timezone
from sqlalchemy import Column, DateTime, String
from src.database import Base

class SystemSettings(Base):
    """
    PostgreSQL-backed runtime configuration table.
    Enforces the global AI Emergency Kill Switch without Redis.
    """
    __tablename__ = "system_settings"

    key = Column(String(128), primary_key=True, index=True)
    value = Column(String(512), nullable=False)
    updated_at = Column(
        DateTime(timezone=True),
        default=lambda: datetime.now(timezone.utc),
        onupdate=lambda: datetime.now(timezone.utc),
        nullable=False
    )
    updated_by = Column(String(128), default="system", nullable=False)
