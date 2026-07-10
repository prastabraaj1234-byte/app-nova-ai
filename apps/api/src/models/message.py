import uuid
from datetime import datetime, timezone
from sqlalchemy import Column, DateTime, ForeignKey, String, Text
from src.models.types import VectorType
from src.database import Base

class Message(Base):
    __tablename__ = "messages"

    id = Column(String(36), primary_key=True, default=lambda: str(uuid.uuid4()), index=True)
    conversation_id = Column(String(36), nullable=False, index=True)
    companion_id = Column(String(36), ForeignKey("companions.id", ondelete="CASCADE"), nullable=False, index=True)
    user_id = Column(String(128), ForeignKey("users.id", ondelete="CASCADE"), nullable=False, index=True)
    role = Column(String(32), nullable=False, comment="user or assistant")
    content = Column(Text, nullable=False)
    # Stored as JSON/list of floats for cross-db compatibility in SQLite, native vector(768) in PostgreSQL
    embedding = Column(VectorType(dim=768), nullable=True)
    created_at = Column(DateTime(timezone=True), default=lambda: datetime.now(timezone.utc), nullable=False, index=True)
