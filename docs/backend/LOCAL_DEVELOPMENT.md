# Nova AI Backend Gateway: Local Development Guide

This guide documents the local development setup for the Nova AI Commercial MVP backend gateway (**Phase 1A**). All services run locally without requiring paid cloud infrastructure.

---

## Prerequisites
- **Python:** Version range `>=3.11,<3.14` (verified on **Python 3.13.7**).
- **Docker & Docker Compose:** Required if running local PostgreSQL + pgvector database container.

---

## 1. Environment Setup
Navigate to the backend monorepo directory and create an isolated Python virtual environment:

```powershell
cd apps/api
python -m venv venv
.\venv\Scripts\activate
pip install --upgrade pip
pip install -r requirements.txt
```

---

## 2. Configuration & Safe Placeholder Management
Copy the example environment template to create your local `.env` configuration file:

```powershell
copy .env.example .env
```

> [!IMPORTANT]
> **SECRET MANAGEMENT RULE:** Never commit your `.env` file or paste real credentials (such as `GEMINI_API_KEY` or database passwords) into Git commits, chat sessions, or bug reports. The `.gitignore` file is pre-configured to block `.env` across the entire workspace.
>
> When real credentials become necessary in subsequent phases, open `apps/api/.env` locally in your editor and replace the placeholder values (`your_gemini_api_key_placeholder`, etc.).

---

## 3. Database & pgvector Setup (Zero Cloud Cost)
We use a maintained, version-pinned PostgreSQL 16 image pre-configured with the `pgvector` extension (`pgvector/pgvector:pg16`).

Start the local database container:
```powershell
docker-compose up -d postgres
```

Verify database container liveness:
```powershell
docker-compose ps
```

---

## 4. Running Database Migrations
We use **Alembic** with asynchronous SQLAlchemy (`asyncpg`) to manage relational schemas:

Apply all schema migrations from zero to head:
```powershell
alembic upgrade head
```

To downgrade or roll back one migration step (in local development or disposable test environments only):
```powershell
alembic downgrade -1
```

To roll back all tables to an empty database (zero, in local development only):
```powershell
alembic downgrade base
```

> **IMPORTANT PRODUCTION ROLLBACK POLICY**:  
> In staging and production environments, `alembic downgrade` must **never** be used as a routine rollback mechanism due to irreversible data loss risks. Production schema management must strictly follow:
> 1. **Backward-Compatible Migrations:** All changes must maintain compatibility with running application instances.
> 2. **Expand/Migrate/Contract Strategy:** Multi-phase rollouts for breaking schema modifications.
> 3. **Mandatory Database Backups:** Automated full backups taken before applying risky migrations.
> 4. **Forward-Fix Rollback:** If a migration introduces issues, resolve via a new corrective forward migration rather than destructive downgrades.
> 5. **Explicit Reviewed Procedures:** Any exception requiring manual rollback must undergo formal engineering review.

---

## 5. Starting the Local Server
Run the FastAPI development server with hot-reloading enabled:

```powershell
uvicorn src.main:app --reload --host 0.0.0.0 --port 8000
```

Once running, you can access:
- **Liveness Probe:** `http://localhost:8000/healthz` or `http://localhost:8000/api/v1/health/liveness`
- **Readiness Probe:** `http://localhost:8000/readyz` or `http://localhost:8000/api/v1/health/readiness`
- **Interactive API Docs:** `http://localhost:8000/docs` (when `DEBUG=true`)

---

## 6. Running Automated Tests
The backend includes a comprehensive Pytest automated test suite using async test clients and isolated in-memory SQLite/PostgreSQL databases:

Run all unit, integration, and migration tests:
```powershell
pytest
```

Run tests with verbose output and short summary:
```powershell
pytest -v -ra
```

---

## 7. Shutdown Procedure
To shut down the local development environment cleanly:
1. Stop the FastAPI development server (`Ctrl+C` in the terminal running `uvicorn`).
2. Stop the local PostgreSQL database container:
```powershell
cd apps/api
docker-compose down
```
3. Deactivate the Python virtual environment:
```powershell
deactivate
```
