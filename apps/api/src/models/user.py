import uuid
from datetime import datetime, timezone
from sqlalchemy import Column, DateTime, String
from src.database import Base

class User(Base):
    __tablename__ = "users"

    id = Column(String(128), primary_key=True, index=True, comment="UUID matching Firebase UID")
    email = Column(String(255), unique=True, index=True, nullable=True)
    display_name = Column(String(255), nullable=True)
    status = Column(String(32), default="ACTIVE", nullable=False, comment="ACTIVE, SUSPENDED, DELETING")
    created_at = Column(DateTime(timezone=True), default=lambda: datetime.now(timezone.utc), nullable=False)
    updated_at = Column(
        DateTime(timezone=True),
        default=lambda: datetime.now(timezone.utc),
        onupdate=lambda: datetime.now(timezone.utc),
        nullable=False
    )
