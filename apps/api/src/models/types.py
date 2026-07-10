import json
import sqlalchemy as sa
from sqlalchemy import types, cast

class PGVector(types.UserDefinedType):
    """PostgreSQL pgvector UserDefinedType for SQLAlchemy."""
    cache_ok = True

    def __init__(self, dim: int | None = None):
        self.dim = dim

    def get_col_spec(self, **kw):
        if self.dim is not None:
            return f"vector({self.dim})"
        return "vector"

    def bind_expression(self, bindvalue):
        return cast(cast(bindvalue, types.String), self)

    def result_processor(self, dialect, coltype):
        def process(value):
            if value is not None and isinstance(value, str):
                try:
                    return [float(x) for x in json.loads(value)]
                except Exception:
                    pass
            return value
        return process

class VectorType(types.TypeDecorator):
    """
    Cross-database vector type: stores as JSON in SQLite (for local offline testing),
    and uses native vector type with casting in PostgreSQL (production source of truth).
    """
    impl = types.JSON
    cache_ok = True

    def __init__(self, dim: int | None = None):
        super().__init__()
        self.dim = dim

    def load_dialect_impl(self, dialect):
        if dialect.name == "postgresql":
            return dialect.type_descriptor(PGVector(dim=self.dim))
        return dialect.type_descriptor(types.JSON())

    def process_bind_param(self, value, dialect):
        if dialect.name == "postgresql" and value is not None and not isinstance(value, str):
            return json.dumps(value)
        return value
