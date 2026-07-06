# ADR-001: Foundation Architecture & Technology Stack

**Date**: 2026-07-06  
**Status**: Approved in Principle / Pending Phase 0 Implementation Kickoff  
**Context**: Transform the existing Nova AI Flutter prototype into a persistent, secure, emotionally intelligent, commercial MVP while rejecting unnecessary infrastructure sprawl (no Kubernetes, Kafka, Redis, microservices, GraphQL, or WebSockets).

---

## 1. Executive Summary & Selected Stack

We select the following concrete technology stack for the Nova AI Commercial MVP:

| Layer | Selected Technology | Rationale & Architectural Role |
| :--- | :--- | :--- |
| **Client Application** | **Flutter + Riverpod + GoRouter** | Preserves existing Apple-grade UI design tokens while migrating from runtime memory to repository-backed state. |
| **Authentication** | **Firebase Authentication** | Industry-standard, secure JWT token issuance supporting anonymous onboarding, Google/Apple Sign-In, and seamless client integration. |
| **Backend Gateway** | **FastAPI (Python 3.11+)** | Asynchronous API gateway orchestrating AI model providers, vector embeddings, strict Pydantic schema validation, and database ownership. |
| **Primary Relational DB** | **PostgreSQL with `pgvector`** | ACID-compliant relational domain models combined with vector similarity search for companion cognitive memory retrieval. |
| **Managed DB Hosting** | **Supabase (Managed PostgreSQL)** | Low-cost, highly scalable managed database providing native `pgvector`, automated daily backups, and connection pooling. |
| **Media Object Storage** | **Supabase Storage** | S3-compatible object storage integrated into our managed database project for companion avatars, memory snapshots, and audio logs. |
| **Local Client Cache** | **Drift (SQLite)** | Type-safe, relational offline-first local database for chat caching and sync queues. Explicitly replaces `SharedPreferences`. |
| **Push & Crash** | **Firebase FCM & Crashlytics** | Unified real-time push notifications and production stability telemetry. |
| **AI Provider Access** | **Google Gemini via Nova Backend Only** | All AI calls route strictly through FastAPI using an `AIProvider` abstraction. Client NEVER holds AI secrets. |
| **Streaming Chat Protocol**| **Server-Sent Events (SSE)** | Simpler, more resilient HTTP/2 unidirectional token streaming than WebSockets; zero stateful connection overhead. |
| **Backend Deployment** | **Google Cloud Run** | Serverless container hosting scaling to zero; automatic HTTPS; estimated MVP cost $0–$15/mo with minimal operational overhead. |

---

## 2. Granular Per-Operation Timeout & Retry Policies

We reject a single global AI timeout. To ensure system resilience and prevent cascading resource exhaustion, FastAPI enforces granular per-operation timeout and retry policies:

| Operation Type | Timeout Duration | Retry Policy | Idempotency Requirement |
| :--- | :---: | :--- | :--- |
| **Streaming Chat Initial Connection** | 5.0s | 2 retries (Exponential backoff + jitter) | N/A (Handshake phase) |
| **Streaming Chat Total Duration** | 45.0s | No retry once token stream begins | N/A (Streamed chunk delivery) |
| **Cognitive Memory Extraction** | 10.0s | 3 retries (Exponential backoff + jitter) | Idempotent task key required |
| **Vector Embedding Generation** | 5.0s | 3 retries (Exponential backoff + jitter) | Idempotent (hash of text content) |
| **Input / Output Safety Moderation** | 3.0s | 2 retries (Exponential backoff + jitter) | Idempotent |
| **Image Generation (Provisional)** | 20.0s | 1 retry (Only on 5xx provider gateway errors) | Required `generation_request_id` |
| **Signed Media Upload / Download** | 15.0s | 3 retries (Exponential backoff + jitter) | S3 ETag / MD5 validation |
| **Future Speech-to-Text (STT)** | 10.0s | 2 retries | Required audio payload hash |
| **Future Text-to-Speech (TTS)** | 10.0s | 2 retries | Required text hash + voice profile |
| **Future Real-time Voice Connection** | 5.0s | 2 retries (Connection handshake) | N/A |

*Retry Rule*: Retries must use bounded exponential backoff with full jitter **only** for retryable failures (network timeouts, 429 rate limits, 503 service unavailable). Non-idempotent operations must never be retried without explicit idempotency keys.

---

## 3. Global AI Kill Switch & Runtime Configuration (No Redis)

We explicitly prohibit Redis. To implement a global emergency kill switch and runtime feature flags without external caching clusters, we use a PostgreSQL-backed runtime configuration table named `system_settings`:

```sql
CREATE TABLE system_settings (
    key VARCHAR(64) PRIMARY KEY,
    value JSONB NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_by UUID REFERENCES users(user_id)
);
```

- **Mechanism**: When an emergency occurs (e.g., billing spike or provider outage), an administrator sets `key = 'AI_EMERGENCY_KILL_SWITCH'` to `value = true` in PostgreSQL.
- **Performance & Caching Strategy**: The FastAPI backend reads `system_settings` and caches values in process memory with a strict, bounded **5-second Time-To-Live (TTL)**. This eliminates per-request database overhead while guaranteeing that emergency kill switches take effect across all container instances within 5 seconds without requiring Cloud Run redeployments.

---

## 4. Corrected Firebase Session Revocation & Secure Deletion-Status Receipt Architecture

We explicitly acknowledge that Firebase JWT access tokens remain valid until their 1-hour expiration. Therefore, session revocation cannot rely on Firebase Admin SDK alone. We enforce a **Secure 6-Stage Durable Deletion & Revocation Workflow**:

1. **Transactional Status Change**: When a user initiates account deletion (`DELETE /api/v1/users/me/account`), the backend starts an ACID PostgreSQL transaction setting `user.status = 'DELETING'` and generates a cryptographically secure, high-entropy 256-bit random hex receipt token (`secrets.token_hex(32)`).
2. **Firebase Refresh Token Revocation**: The backend invokes Firebase Admin SDK `auth.revokeRefreshTokens(uid)` to prevent the client from obtaining new access tokens.
3. **Mandatory Backend Account Status Verification**: On **every** authenticated protected backend request, FastAPI's authentication middleware verifies the Firebase Bearer token AND enforces the canonical Nova user account status in PostgreSQL (cached in process memory with a 10-second TTL or queried via connection pool).
4. **Immediate API Blocking**: Any request from a user whose account status is `DELETING`, `SUSPENDED`, or `DELETED` is immediately rejected with `HTTP 403 Forbidden (Account Disabled)`.
5. **Durable Deletion Outbox Execution**: Within the deletion transaction, the backend inserts a job into `deletion_jobs` enumerating all target Supabase Storage object URIs. A background worker processes deletions with retry tracking.
6. **Secure Deletion-Status Receipt Architecture**:
   - *HTTP Protocol*: **POST request body only** (`POST /api/v1/users/deletion-status` with JSON body `{"receipt_token": "<token>"}`). URL query parameters are explicitly banned to prevent token leakage in HTTP access logs or referer headers.
   - *Database Storage*: We store **only the SHA-256 hash** of the receipt token in `deletion_jobs.receipt_token_hash`. The raw token is returned once to the client and never stored.
   - *Expiration*: Receipt tokens expire after **7 days** (`expires_at`).
   - *Rate Limiting*: Enforce a strict rate limit of **5 requests per minute per IP and per receipt hash** to prevent brute-force guessing.
   - *Log Redaction*: FastAPI middleware automatically redacts any payload field named `receipt_token` so raw tokens never appear in application or system logs.
   - *Uniform Response*: If a receipt token is unknown, invalid, or expired, the backend returns a generic `HTTP 404 Not Found` with JSON `{"status": "NOT_FOUND_OR_EXPIRED"}` without revealing whether the token ever existed.

---

## 5. Three-State Git Repository & Secret Scanning Strategy

To ensure safe execution without assumptions, all engineering automation and secret scanning must dynamically adapt to one of three inspected project states:

| Inspected State | Git Mutation Policy | Backup / Checkpoint Strategy | Secret Scanning Mode (Gitleaks) |
| :--- | :--- | :--- | :--- |
| **Case A: Not a Git Repo**<br>*(Current Nova State)* | **Zero Git commands**. No `git init`, no branching, no remotes, no commits. | Complete filesystem copy outside project dir (e.g., `..\nova_ai_backup\`) excluding only `build/` & `.dart_tool/`. | **Filesystem / No-Git Mode**: `gitleaks detect --no-git --redact --report-path ...` (Scans working files only; zero git history scan). |
| **Case B: Local Git Repo (No Remote)** | Safe branch checkpointing allowed. No remote additions or pushes. | Record clean commit SHA (`CHECKPOINT_SHA.txt`); branch from SHA; reset to SHA on rollback. | **Local History Mode**: `gitleaks detect --redact --report-path ...` (Scans local commit history without `--no-git`). |
| **Case C: Existing Remote** | **STOP immediately**. Do not push, mutate, or delete branches. | Report remote name, domain, and exposure status for manual user audit. | **Full History Mode**: Scans full local and remote tracking history with redaction. |

---

## 6. Foundational Production Engineering in Phase 1

Production engineering is not bolted on at the end. **Phase 1** must establish these core foundations before Phase 2 begins:
- **Structured JSON Logging**: Every backend request outputs structured logs with automated correlation IDs (`x-request-id`).
- **Centralized Exception Handling**: Global FastAPI exception middleware catching domain errors and converting them into uniform, sanitized JSON error responses without stack trace leakage.
- **Health & Readiness Endpoints**: `/api/v1/health/liveness` and `/api/v1/health/readiness` monitoring database connectivity and pgvector extension status.
- **Environment Isolation**: Strict configuration separation across Local, Development, and Production using `pydantic-settings`.
- **AI Telemetry & Emergency Kill Switch**: Centralized token/cost accounting per user and the PostgreSQL-backed `system_settings` kill switch capable of instantly suspending all LLM provider calls across the platform within 5 seconds.

---

## 7. Provisional Status of Visual Identity Provider

**IMPORTANT**: While Phase 4 mentions potential image generation technologies (Replicate, Flux-Dev, IP-Adapter), **the Visual Identity provider and technical approach remain provisional pending ADR-002 review and explicit user approval.** No provider-specific image generation code will be implemented until ADR-002 is thoroughly evaluated and signed off.
