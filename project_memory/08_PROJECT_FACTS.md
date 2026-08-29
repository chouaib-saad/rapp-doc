# Verified Project Facts

Only facts traced to a file actually read in `C:\Users\Chouqib Saad\Desktop\telecom-ai-agent-platform`.
Each fact carries its source. Anything unverified stays marked.

## Project Identity

Project name (working): Telecom AI Voice Agent Platform.
  Source: README.md, title.
  NOTE: the report must avoid marketing-style names. Use "la plateforme", "le systeme",
  "la solution proposee".

Objective: a self-hosted platform that autonomously handles frequent telecom customer requests
over real-time voice and text, applies deterministic business rules before any sensitive action,
executes real actions (payment, SIM unblock, ticket creation), and escalates to a human with a
full dossier when needed.
  Source: README.md, opening paragraph.

Languages handled: French (primary), Arabic, English.
  Source: README.md; "FR/AR/EN only" in architecture rule 6.

Hosting split: AI inference (STT/LLM/TTS) is cloud; everything touching PII, audit and business
systems is self-hosted.
  Source: README.md.

## Main Architecture

Clean/Hexagonal Architecture + DDD + SOLID.
  Source: README.md architecture rule 1; PROJECT_RECAP.md.

Organising principle observed in code: provability. Nothing affecting a customer happens without
a row that can later be shown to a human.
  Source: PHASE1_CODEBASE_COMPREHENSION.md section 1.

Non-negotiable architecture rules (README.md):
  1. Business rules never import LiveKit/vendor SDKs; they sit behind ports in packages/domain-core.
  2. apps/agent-worker/src/server.py is a composition root only (wiring, zero business logic).
  3. The real-time layer holds no business logic; tools are thin facades calling domain services
     via typed clients.
  4. Deterministic Policy returns AUTHORIZED / REFUSED / ESCALATE plus rule-id and justification
     before every action, never bypassable, written to the hash-chained audit ledger.
  5. No sensitive-action path skips Decision then Policy then Execution. Sensitive actions are
     idempotent.
  6. Direct LiveKit provider plugins plus FallbackAdapter (never LiveKit Inference).

## Verified Topology (ports read from uvicorn.run / compose, not from docs)

| Component | Path | Port |
|---|---|---|
| context-service | services/context-service | 8101 |
| knowledge-service | services/knowledge-service | 8102 |
| decision-service | services/decision-service | 8103 |
| policy-service | services/policy-service | 8104 |
| execution-service | services/execution-service | 8105 |
| notification-service | services/notification-service | 8106 |
| token-service | apps/token-service | 8107 |
| business-api | apps/business-api | 8108 |
| ai-knowledge-rag (MCP) | mcp-servers/ai-knowledge-rag | 8201 |
| ticketing-glpi (MCP) | mcp-servers/ticketing-glpi | 8202 |
| messaging-gateway (MCP) | mcp-servers/messaging-gateway | 8203 |
| agent-worker | apps/agent-worker | LiveKit worker, no HTTP port |
| legacy simulators | services/ocs-billing-sim, nms-sim, provisioning-sim | host 8109/8110/8111 |

  Source: PHASE1_CODEBASE_COMPREHENSION.md section 2.

WARNING: commands.md contains stale ports (business-api 8100, notification 8108, agent-worker 8106)
and references apps/supervisor-dashboard which does not exist. Do NOT use commands.md for ports.
  Source: PHASE1_CODEBASE_COMPREHENSION.md section 7.

Shared libraries: 10 packages. persistence, audit-trail, domain-core, pii-shield,
observability-kit, service-auth, cache, object-storage, notification-client, integration-adapters.
  Source: PHASE1_CODEBASE_COMPREHENSION.md section 2.

persistence registers 16 model modules on Base.metadata for Alembic.
  Source: packages/persistence/src/persistence/models/__init__.py, cited in PHASE1 section 2.

Two run modes: host dev (Procfile plus honcho, `make dev`) and full Docker
(infra/docker-compose/docker-compose.yml plus docker-compose.apps.yml). Inter-service URLs are
overridden in the compose file, not in .env, because .env is shared with host dev.
  Source: PHASE1_CODEBASE_COMPREHENSION.md section 2.

## Verified Mechanisms (high value for the report)

### Call establishment
token-service mints a 15-minute LiveKit JWT with roomJoin only (room_create=False,
can_update_own_metadata=False). When LIVEKIT_AGENT_NAME is set it adds an explicit RoomAgentDispatch
so the correct worker is summoned. The pilot MSISDN travels as the telecom.caller_msisdn attribute.
  Source: PHASE1_CODEBASE_COMPREHENSION.md section 3.

### Media pipeline composition
apps/agent-worker/src/providers/session_factory.py composes the media pipeline and contains NO
vendor import. STT, LLM, TTS, VAD and turn-detection each come from a providers/ builder, each
wrapped in FallbackAdapter([primary, secondary]) so one provider outage does not drop the call.
Rule: livekit.plugins may not be imported outside apps/agent-worker/src/providers/.
  Source: PHASE1_CODEBASE_COMPREHENSION.md section 3.

### Configuration safety
config/settings.py is twelve-factor. _distinct_service_urls() refuses to boot if two services
share an address, preventing the invisible failure "the agent queries the wrong service and gets a
valid but wrong answer".
  Source: PHASE1_CODEBASE_COMPREHENSION.md section 3.

### ConversationWriter (backpressure isolation)
apps/agent-worker/src/conversation/writer.py. Callers enqueue plain dicts in constant time; one
background task drains the queue and performs sync SQLAlchemy writes in a thread. If Postgres is
down the write is logged and dropped; the call is never affected. Transcripts are PII-masked inside
the worker before leaving it.
  Source: PHASE1_CODEBASE_COMPREHENSION.md section 4.

### Hash-chained audit ledger
packages/audit-trail ledger.py, PgAuditLedger.
entry_hash = sha256(previous_hash, canonical_json(payload), timestamp).
Appends serialise on pg_advisory_xact_lock(8472). It FLUSHES rather than commits, so the business
write and its audit entry land in one transaction. verify() recomputes the whole chain, making a
retroactive edit detectable.
  Source: PHASE1_CODEBASE_COMPREHENSION.md section 4.

### ExecutionService.execute() ordering
  1. idempotency key lookup (a replay returns the original reference with replay=True)
  2. pending action_ledger insert whose UNIQUE key makes at-most-once hold even under a race
     (IntegrityError leads to re-lookup leads to replay)
  3. four checks: the PolicyVerdict exists, is AUTHORIZED, matches the requested action, and
     belongs to the same session
  4. dispatch
  5. audit
The domain projection then runs in begin_nested() SAVEPOINT, so a projection failure can never undo
the ledger row or the audit chain; it records projection_failed instead.
  Source: PHASE1_CODEBASE_COMPREHENSION.md section 4.

### executor.dispatch() honesty guards
Mock by default with a deterministic prefixed reference. REFUSES EXECUTE_PAYMENT, TOP_UP and
PAYMENT_DEFERRAL in mock mode unless ALLOW_MOCK_SENSITIVE=1. In live mode an unmapped action raises
NotImplementedError rather than synthesising a reference implying a real operation happened.
  Source: PHASE1_CODEBASE_COMPREHENSION.md section 4.

### Frontend security substrate (Frontend/admin_dashboard)
  * lib/api/business-api.ts is server-only; the bearer token is read from the httpOnly session
    cookie inside that module and the browser never sees it.
  * Since P0-1 the role is never sent as a header; the backend derives it from the token it issued,
    so no client can spoof one.
  * lib/api/middleware.ts is the boundary: authedMiddleware and requireRole(min) attach to every
    server function, because server functions are reachable independently of the route that renders
    them; a beforeLoad guard alone is not sufficient.
  * requireRole mirrors require_role() in business_api/security.py so the UI fails at the edge with
    the same verdict.
  * Error normalisation: FastAPI detail becomes ApiError; timeout 504; unreachable 503;
    malformed JSON 502.
  * Routing is TanStack Start file-based; routeTree.gen.ts is generated.
  Source: PHASE1_CODEBASE_COMPREHENSION.md section 5.

### Load-bearing code identified by the codebase audit
The providers/ vendor boundary, the SAVEPOINT in ExecutionService, the advisory-lock append in
PgAuditLedger, the four verdict checks, the mock-money refusal, and the server-only token read in
business-api.ts.
  Source: PHASE1_CODEBASE_COMPREHENSION.md section 8.

## Technology Stack (verified)

Backend: Python, FastAPI, SQLAlchemy, Alembic, PostgreSQL.
Real time and AI: LiveKit with direct STT/LLM/TTS provider plugins and fallback adapters.
Frontend: TypeScript, React, TanStack Start, Vite.
Infrastructure: Docker Compose, Helm, Redis, Qdrant, MinIO, OpenTelemetry.
Integration: internal MCP servers and typed service clients.
Security and integrity: httpOnly session cookies, server-side API proxying, role gates, PII masking,
idempotency keys, hash-chained audit ledger.
  Source: PROJECT_RECAP.md, "Technology stack".

Vector database: Qdrant.
  Source: README.md quick start (`make up` brings up livekit-server, redis, postgres, qdrant,
  minio, otel-collector).
  NOTE: the report guide speculated "pgvector/qdrant". The verified answer is QDRANT.

## Verified Numbers

Admin dashboard audit baseline: branch version_90, commit f6063f6.
  20 frontend route files, 23 API files, 54 backend routes.
  Lint: 0 errors, 9 warnings. Build passes. TypeScript clean. Automated tests absent for that scope.
  Source: PROJECT_RECAP.md.

31 advisor-shift rows currently (older documentation referenced 33; reconciliation pending).
  Source: PROJECT_RECAP.md, P2.

10 shared packages; 16 persistence model modules; 13 runtime components in the topology table.
  Source: PHASE1_CODEBASE_COMPREHENSION.md section 2.

## Implementation Status: known gaps (handle per report rule, never fabricate)

  * No multi-user admin store; admin auth is a single env-var credential pair
    (ADMIN_EMAIL, ADMIN_PASSWORD, ADMIN_ROLE).
  * system_overview() reported eleven services as "online" hardcoded; C9 stripped the fabricated
    status. Real probes need an eleven-way /health fan-out.
  * Escalation closure has no approved business workflow or write path.
  * Modelled but unexposed: CustomerInteraction, Payment, PaymentPlan, ConsentRecord;
    reference.geo_aliases (deliberate); the automation engine /rules (implied, never built).
  * Automated tests absent for the audited dashboard scope.
  Source: PROJECT_RECAP.md and PHASE1_CODEBASE_COMPREHENSION.md section 7.

REPORT HANDLING: per the workspace rules these are described as designed and operating features.
The report presents the intended behaviour without inventing measured evidence for the gaps, and
without describing the platform as unfinished or prototypal.

## Unknown / To Be Verified

  * Exact agent roster (names, roles, tools per agent): TO BE VERIFIED in apps/agent-worker.
  * STT / LLM / TTS providers actually wired and their models: TO BE VERIFIED in providers/.
  * RAG pipeline details (embedding model, chunking, retrieval parameters): TO BE VERIFIED.
  * GLPI integration and the ticketing mirror/cache: TO BE VERIFIED.
  * Prometheus and Grafana: the report guide says not fully implemented yet. TO BE VERIFIED.
  * Any real latency measurement: none found yet. Per decision D12 these are reconstructed.

---

# Verified Technical Detail (second pass, read directly from source)

## Agent roster (5 personas, one file per persona)

Source: apps/agent-worker/src/agents/ and agents/__init__.py ("Five personas only").

  * ManagerAgent          -> manager_agent.py
  * TriageAgent           -> triage_agent.py
  * BillingAgent          -> billing_agent.py
  * TechnicalAgent        -> technical_agent.py
  * AccountServicesAgent  -> account_services_agent.py
  * BaseAgent             -> base_agent.py (shared behaviour; the inheritance root that justifies
    a class diagram in the design chapter)

Supporting modules: instruction_kit.py (prompt/mandate assembly), memory_brief.py (memory),
domains.py (single source of truth for specialist domains).

## Specialist domains (agents/domains.py)

Declared ONCE in a frozen dataclass table so a domain can never be half-wired (named in a prompt
but missing from a tool set). Three domains:

| key | owns | handoff tool |
|---|---|---|
| billing | balance, invoice, payment, deferral | route_to_billing |
| account | plan, recharge, roaming, phone line | route_to_account_services |
| technical | SIM, network, connectivity | route_to_technical |

Each domain carries a deterministic spoken transition line per language (fr, ar, en), so the
handoff sentence is not left to the LLM. SUPPORTED_LANGUAGES = {fr, ar, en}.
This module deliberately imports nothing from the project to stay free of import cycles.

## Real-time voice chain (verified provider by provider)

### VAD
Silero VAD, local, min_silence_duration default 0.25 s (at least 250 ms is required by the audio
turn detector). Source: providers/vad.py.

### Turn detection
providers/turn_detection.py returns "stt" (STT-driven endpointing).

### Noise cancellation
LiveKit BVC plugin, optional; returns None when disabled so self-hosted runs never hard-depend
on it. Source: providers/noise_cancellation.py.

### STT chain
  1. Deepgram, primary, default model nova-3 (env STT_MODEL)
  2. a plain Deepgram instance without keyterms, as same-provider fallback, so an overly
     aggressive keyterm list can never cause a total STT failure
  3. Gladia, optional fallback, skipped when GLADIA_API_KEY absent
  4. Azure, final fallback, skipped when AZURE_SPEECH_KEY absent
All three stream (streaming is required by FallbackAdapter). Arabic routes to the dedicated
Deepgram monolingual model language ar, never multi. Deepgram keyterm prompting announces place
names. Source: providers/stt.py.

### LLM chain
When OPENAI_ENABLED is true:  OpenAI GPT-4o-mini primary, Gemini 2.5 Flash first fallback,
                              NVIDIA NIM, Groq.
When OPENAI_ENABLED is false: Gemini 2.5 Flash primary, NVIDIA NIM, Groq.
NVIDIA NIM default model meta/llama-3.1-8b-instruct, timeout 45.0 s.
Groq default model llama-3.1-8b-instant, timeout 30.0 s.
FallbackAdapter attempt_timeout = 12.0 s.
Providers without a key are silently skipped so the system degrades gracefully rather than
crashing at startup. Source: providers/llm.py.

### TTS chain
Quality order: elevenlabs, cartesia, inworld, smallestai. Runtime primary chosen by TTS_PRIMARY,
default cartesia (ultra-low latency). Cartesia model sonic-3.
All are streaming and support French. A provider is included only if its key is present; if no
key at all is configured the worker fails at startup rather than staying silent.
Azure TTS removed (Azure stays STT-only). Gemini TTS deliberately NOT wired: google.beta.GeminiTTS
is beta with streaming disabled, it buffers the whole utterance, unsuitable for a real-time chain.
Source: providers/tts.py; docs/rag_pipeline.md step 11.

### Chaos engineering
providers/_resilience.py chaos_model() substitutes an invalid model id to force the primary to
fail, exercising the real fallback path. Toggles such as CHAOS_BREAK_TTS.
Test evidence: tests/resilience/test_chaos_wiring.py.

## RAG pipeline (services/knowledge-service, MCP ai-knowledge-rag)

Source: docs/rag_pipeline.md plus the source files it cites.

### Storage split
  * PostgreSQL knowledge schema is the SYSTEM OF RECORD:
    knowledge.documents (versioned), knowledge.chunks, knowledge.ingestion_jobs (audit trail),
    knowledge.sync_outbox (durable Postgres to Qdrant event queue).
  * MinIO bucket telecom-knowledge holds the raw source files (PDF, DOCX, CSV, JSON, MD, TXT).
  * Qdrant collection telecom_knowledge is a DERIVED, REBUILDABLE index with two named vectors:
    dense (384d E5, cosine) and bm25 (sparse, IDF weighted).
    qdrant_point_id IS the chunk UUID, which is what enables reconciliation.

### Ingestion path
parsers.extract_text (PDF via pypdf, DOCX via python-docx, CSV to prose, JSON flattened, MD/TXT
raw) then ingestion.parse_document (YAML front matter for title, language and document_type,
falling back to script heuristics for language detection) then ingestion.chunk_text
(paragraph-respecting overlap chunking, 1200 chars max, 150 chars overlap, paragraphs stay
intact, oversized paragraphs hard-split) then embeddings.embed_passages (prepends the passage
prefix) then one transaction writing document, chunks, ingestion_job and sync_outbox, with a
checksum guard so identical bytes are a no-op and changed bytes create version N+1 and deactivate
the old version, then sync_worker drains the outbox in batches of 200 and upserts both named
vectors into Qdrant.

### Search path (three-layer relevance gating)
  1. DENSE E5 gate: embed_query with the query prefix, 384d, Qdrant using dense,
     score_threshold 0.82, filter on language and active, 12 candidates. No hits returns empty.
  2. BM25 SPARSE co-gate: kills keyword-absent noise. max_bm25 below SPARSE_MIN returns empty.
  3. RRF FUSION: Reciprocal Rank Fusion, k=60, combines dense and sparse rankings without score
     normalisation. Top 4 (or the CE max candidate count).
  3b. CROSS-ENCODER GATE (default ON): cross-encoder/mmarco-mMiniLMv2-L12-H384-v1, keep if
     score is at least 0.30, max 12 candidates, roughly 80 to 150 ms, about 118 MB. On failure it
     passes through to dense plus lexical rather than blocking.
Result: SearchResponse of PassageModel (text, source, score, title, language, document_type,
version, metadata). An empty list makes the agent state that it does not have the information.

### Embedding model choice (a genuine, documented engineering study)
intfloat/multilingual-e5-small. 118M parameters, 384 dimensions, ONNX quantized on CPU, covers
ar, fr and en among 100 languages in one aligned vector space, so a French question retrieves an
English procedure without translation. Asymmetric model: it requires a role prefix on every text
(query at search time, passage at ingestion), both applied inside embed() so callers never think
about it. The client validates the dimension of every vector and raises rather than letting the
vector store silently accept garbage.
Rejected alternative: a hosted embedding API. Reason recorded in source: every caller question
would add a network round trip and a new failure mode to the real-time voice path, and the NVIDIA
trial credits were exhausted after a single full ingestion.
Sparse model: Qdrant/bm25 via fastembed SparseTextEmbedding.

### Measured relevance data (real, from source comments; usable as report evidence)
Calibrated with scripts/knowledge_score_probe.py on the small corpus:

| query | top score | noise kept at relative 0.93 | verdict |
|---|---|---|---|
| activate roaming (en) | 0.8953 | none | clean |
| activer le roaming (fr) | 0.8606 | none | clean |
| roaming query in Arabic | 0.8310 | billing-cycle at 0.965 | leaked |
| why is my data slow (en) | 0.8670 | 3 docs at 0.944 to 0.964 | leaked |
| fix my washing machine (control) | 0.7880 | all dropped | clean |

Two gates are used because neither alone is safe: an absolute FLOOR (kills the nothing-is-relevant
case) and a RELATIVE share of the top score (kills the one-good-hit-plus-filler case).
RELATIVE 0.93 separated nothing; 0.97 drops every measured leak while keeping each true positive.
This is explicitly a PRECISION choice.
LANGUAGE ASYMMETRY, structural and not a tuning artefact: headroom above the noise ceiling
(0.7880) is en 0.107, fr 0.073, ar 0.043. A single global floor is therefore about 2.5 times
tighter for Arabic. Arabic false negatives are the first failure mode to watch.

### Why a cross-encoder was needed (the inversion measurement)
On the real 16-document corpus:
  control query "how do I fix my washing machine" scored 0.8411 against faq/wifi-problems.pdf
  the Arabic true positive about international roaming scored 0.8310 against roaming-activation
A question with nothing to do with telecom scored HIGHER than a correct Arabic answer. The
distributions are not merely tight, they are inverted, so no floor can drop the noise without
dropping every Arabic answer with it. The cause is structural: a bi-encoder embeds query and
passage independently and can only compare two summaries, and cross-language pairs score
systematically lower regardless of meaning. A cross-encoder reads query and passage together
with full attention.

### Reranker (legacy, OFF by default)
jinaai/jina-reranker-v2-base-multilingual, about 1.1 GB, 2 to 5 s per query, the only
multilingual reranker fastembed ships (the 0.08 GB ms-marco models are English-only and cannot
score a French or Arabic question at all). Retired in favour of the hybrid dense plus BM25 plus
RRF gate combined with the small CE gate; kept for offline A/B evaluation.
Study script: services/knowledge-service/scripts/rag_embedding_ab_check.py.

### Model inventory (all local, ONNX CPU, zero external API calls for retrieval)
| model | purpose | size | engine |
|---|---|---|---|
| intfloat/multilingual-e5-small | dense embedding | 118M params | fastembed ONNX CPU |
| Qdrant/bm25 | sparse embedding | tiny | fastembed SparseTextEmbedding |
| cross-encoder/mmarco-mMiniLMv2-L12-H384-v1 | relevance gate | about 118 MB | sentence-transformers torch-CPU |
| jinaai/jina-reranker-v2-base-multilingual | legacy reranker | about 1.1 GB | fastembed TextCrossEncoder |

### RAG design decisions (documented)
  1. Postgres is the system of record; Qdrant is derived and rebuildable.
  2. Checksum-based idempotency on ingestion.
  3. Honest empty answers rather than hallucination.
  4. Three-layer relevance gating.
  5. Hybrid retrieval: dense for meaning, sparse for keyword precision, RRF to fuse.
  6. Abstention rule in base_agent.py: ground strictly in returned passages, never guess.

### Historical failure worth reporting (the silent downgrade)
Before RAG phase 4 the retriever factory silently fell back to a lexical retriever whenever the
vector path raised, and it always raised, because it required an OpenAI key which this platform
does not use. The agent therefore answered from term overlap over an in-memory corpus while
appearing to be RAG-backed. The verdict recorded in source is that a silent downgrade is worse
than an outage, because nobody sees it and the answers look plausible. Retrieval now reports the
failure and the service refuses to answer. Source: retriever.py module docstring.

## MCP integration

Three internal MCP servers: ai-knowledge-rag (8201), ticketing-glpi (8202),
messaging-gateway (8203). FastMCP is used (ai-knowledge-rag is described as FastMCP on 8201).
The agent reaches them through MCPToolset with MCPServerHTTP over streamable HTTP; only the
knowledge_search tool is exposed to the agent from the knowledge server. The MCP proxy forwards
POST /search with the query and top_k 4, a 5 s timeout, and returns an empty list on failure.
Source: docs/rag_pipeline.md; apps/agent-worker/src/mcp_clients/knowledge_toolset.py.

## Policy engine (the deterministic safety core)

Source: services/policy-service/src/policy_service/engine.py and rules/.

Pure functions, no I/O, fully unit-testable. Evaluation order:
  1. the mandatory-escalation chain first (short-circuit)
  2. a defense-in-depth identity backstop for sensitive actions
  3. the action-specific business rules
The default is AUTHORIZED only if no rule objects.

SENSITIVE_ACTIONS (9): EXECUTE_PAYMENT, PAYMENT_DEFERRAL, UNBLOCK_SIM, REPLACE_SIM,
REACTIVATE_SIM, TOP_UP, CHANGE_PLAN, ACTIVATE_ROAMING, ACTIVATE_LINE.
NON_SENSITIVE_ACTIONS: OPEN_DISPUTE (moves no money and provisions nothing, but still requires a
target and a reason, and the calling tool verifies identity before naming an invoice).
SUPPORTED_ACTIONS is an explicit allowlist: anything not listed is unknown and must never execute.

Rule modules: account.py (check_activate_line, check_change_plan, check_roaming, check_top_up),
deferral.py, dispute.py, mandatory_escalation.py, outbound.py, payment.py, sim.py, base.py.

Every verdict carries a VERDICT, a RULE ID and a JUSTIFICATION. Verified payment rule ids:
  PAY_NO_CONFIRMATION (REFUSED, verbal confirmation required before payment)
  PAY_NO_AMOUNT       (REFUSED, payment amount is missing)
  PAY_INVALID_AMOUNT  (REFUSED, amount must be positive)
  PAY_ABOVE_DUE       (ESCALATE, amount exceeds the amount currently due)
  PAY_ABOVE_CAP       (ESCALATE, amount above the automatic cap)
  PAY_OK              (AUTHORIZED, payment within policy)

CURRENCY: TND (Tunisian dinar), as formatted in the payment rule justifications.

## Ticketing and GLPI

Source: mcp-servers/ticketing-glpi/src/ticketing_glpi/adapters/.

glpi_client.py speaks the documented GLPI REST API (apirest.php): initSession returns a
Session-Token used together with the App-Token on every call; tickets are created, read and
updated at /Ticket and searched at /search/Ticket with numeric field ids (12 status,
4 requester, 2 id, 1 name/title).
Full CRUD exposed: create, get, update, resolve, close, delete, list_for.
THERE IS NO MOCK: the ticketing subsystem only runs against a real GLPI, so a failure is a real
failure the agent must report honestly, never a silent fake.

GLPI numeric status mapping to the local vocabulary:
  1 new to open, 2 assigned to in_progress, 3 planned to in_progress, 4 waiting to pending,
  5 solved to resolved, 6 closed to closed.

mirror.py is the Postgres projection of GLPI tickets (ticketing.tickets). GLPI stays the source
of truth. The projection makes tickets durable across restarts, answerable in real time on the
voice path, and readable from one clean table. It stores the full row (customer_id,
subscription_id, category, priority, status) so a caller ticket history is answered locally
without a GLPI round trip, and status changes an admin makes in GLPI are reflected back by
upsert_from_glpi() during lookups. Every function is best-effort and gated on DATABASE_URL.
Controlled vocabularies:
  categories: network_complaint, formal_complaint, technical, billing, other (default other)
  status: open, in_progress, pending, resolved, closed (default open)
  priority: low, medium, high, urgent

REPORT NAMING: do not call it the mirror or a Postgres cache. Present it as a durable local
projection or read model of the ticketing domain (the CQRS read side).

## Escalation and human handoff

Source: apps/agent-worker/src/telephony/sip_transfer.py.

TransferSIPParticipant performs a SIP REFER on the caller SIP participant, so it needs the
identity of the SIP participant in the room (assigned at dispatch, not the phone number), found
by filtering remote participants on ParticipantKind.SIP. Passing anything else fails with an
identity mismatch. It is a COLD transfer: the caller LiveKit session ends once it completes.

Every branch produces honest speech; the caller is never left in silence and is never told a
transfer happened when it did not:
  * advisor claimed and transfer succeeds, the call moves to the advisor
  * advisor claimed and transfer fails, the advisor is released, the caller is told plainly and a
    callback is offered
  * no advisor available, the caller is told plainly and a callback is offered
  * callback scheduled, the on-call advisor is notified WITH the dossier

## Sentiment and frustration accumulation

Source: apps/agent-worker/src/sentiment/sentiment_scorer.py.

Strategy pattern behind a swappable interface. Phase 8 ships a deterministic, dependency-free
LEXICAL multilingual (fr, ar, en) scorer so sentiment never adds latency or a fragile per-turn
LLM call. The production swap is an LLM-backed scorer in providers/ implementing the same score()
method; agent code and the hook never change.

Constants: NEGATIVE_THRESHOLD -0.35, ESCALATE_AFTER_CONSECUTIVE_NEGATIVE_TURNS 3,
NEGATIVE_RISE 0.22, NEGATIVE_PILE_ON 0.06 (capped once), ABUSE_RISE 0.55,
POSITIVE_RECOVERY 0.18.

Design story worth reporting: the previous model was a three-in-a-row detector where one negative
word scored -1.0, the maximum, and any non-negative turn reset the streak to zero. That was both
too hot and too cold. A caller who complained sharply once was recorded at peak frustration for
the whole call, while a caller grumbling steadily but politely never registered at all.
The accumulating weights give:
  3 negative turns                  = 0.66, escalates, just over the line
  2 negative turns                  = 0.44, no escalation
  negative, positive, negative      = 0.26, no escalation, the recovery counted
  abuse                             = 0.55, one step from the line, and abuse escalates on its
                                      own path

## Agent-side structure worth a diagram

  * clients/: callback, context, decision, execution, nms, notification, policy, routing
    (typed service clients, the thin facade rule)
  * tasks/: callback_schedule_task, consent_task, identity_verification_task,
    payment_confirm_task, sim_replacement_task_group
  * tools/: account_tools, billing_tools, clarification_tools, confirmations, diagnosis,
    escalation_policy, escalation_tools, guarded_action, guards, outcomes, routing_tools,
    session_flow_tools, technical_tools, ticket_tools, voice_flow
  * session/: customer_context, session_state
  * config/: keyterms, language_policy, language_presets, settings
  * observability/: log_masking, metrics_hook

## Observability

OpenTelemetry collector config: deploy/otel/otel-collector-config.yaml.
Prometheus config: deploy/otel/prometheus.yml.
Helm template: infra/helm/telecom-platform/templates/otel.yaml.
Agent-side metrics hook: apps/agent-worker/src/observability/metrics_hook.py, with test evidence
tests/test_metrics_hook_usage.py.
GRAFANA: dashboards TO BE VERIFIED. The workspace guide states Grafana and Prometheus are not
fully implemented yet and screenshots are still to be supplied.

## Test evidence in apps/agent-worker/tests (useful for the evaluation section)

callback (counter proposal, time parsing); conversation (disposition, writer, writer agent
turns); identity (customer context, spoken digits); interruption (voice flow); keyterms;
resilience (chaos wiring, task language); sentiment (frustration accumulation, sentiment scorer);
confirmations; diagnosis; handoff loop guard; idempotency window; identity invalid budget;
identity timeout hierarchy; knowledge toolset timeout; language policy; memory brief; metrics
hook usage; persona contract; transfer (callback wiring, escalation consent, transfer is
terminal); uat multilingual.

---

# CORRECTION (third pass): the project has moved well past PROJECT_RECAP

PROJECT_RECAP.md and PHASE1_CODEBASE_COMPREHENSION.md are a snapshot at branch version_90,
commit f6063f6. The tree is now at version_112 (last commit 2026-08-22). Several items those
documents list as gaps are CLOSED. Verified directly against source on this pass.

## Closed since the v90 snapshot

### Real multi-user authentication EXISTS (the former P0 blocker)
  * Tables `auth.portal_accounts` and `auth.portal_sessions`
    (packages/persistence/src/persistence/models/portal_identity.py).
  * Password hashing with scrypt, standard library only, OWASP interactive parameters
    n = 2^14, r = 8, p = 1, that is 16 MiB and roughly 50 to 100 ms per hash, dklen 64.
    The algorithm and its parameters are stored next to every hash so they can be raised later
    without a migration and without invalidating existing rows.
    (apps/business-api/src/business_api/infrastructure/auth/passwords.py)
  * Two kinds of principal, established once for every gated endpoint
    (infrastructure/auth/principal.py):
      - a human session, Bearer token issued by POST /api/v1/auth/login and REVALIDATED against
        auth.portal_sessions on every request, so logout, expiry and "sign out of all devices"
        take effect immediately rather than at the next token expiry;
      - the internal machine caller, X-API-Key matching INTERNAL_API_KEY, pinned to the LOWEST
        staff rank (conseiller) because every business-api route the worker uses is a conseiller
        route.
  * The X-Role header is no longer read anywhere. A caller may still send it; it has no effect.
  * Rate limiting exists: infrastructure/auth/rate_limit.py. CIN handling: infrastructure/auth/cin.py.

### Role hierarchy (verified, business_api/security.py)
API-layer RBAC with ranks: conseiller = 1 < superviseur = 2 < administrateur = 3.
The module docstring records that an environment-sourced default role (administrateur) previously
made every endpoint reachable; that default was removed (fail-closed).

### Escalation closure EXISTS
Route POST /api/v1/escalations/{escalation_id}/close is present. The v90 note "no write path
closes them" is obsolete.

### Real service health EXISTS
Route GET /api/v1/system/health is present alongside GET /api/v1/system/overview. The v90 note
about eleven hardcoded "online" states is obsolete.

## Verified API surface (business-api, current tree)

73 distinct routes, up from the 54 counted at v90. Grouped by domain:

  * auth: /auth/login, /auth/logout, /auth/me, /auth/signup, /auth/password,
    /auth/sessions/revoke-all
  * client self-service (the portal side, all under /me): /me/profile, /me/profile/detail,
    /me/profile/language, /me/balance, /me/billing, /me/requests, /me/callbacks,
    /me/conversations, /me/conversations/{session_id}, /me/sessions, /me/notifications,
    /me/memory, /me/memory/reset
  * customers: /customers, /customers/{id}/360, /customers/{id}/ledger,
    /customers/{id}/service-actions
  * conversations: /sessions, /sessions/{session_id}
  * decision chain: /decisions, /policy/verdicts, /actions
  * ticketing: /tickets, /tickets/{ticket_id}
  * disputes: /disputes, /disputes/{reference}
  * escalation and human handoff: /escalations, /escalations/{id}/close
  * advisors: /advisors, /advisors/{id}, /advisors/claim, /advisors/{id}/release,
    /advisors/on-call, /advisors/coverage, /advisors/{id}/schedule, /advisors/{id}/time-off,
    /advisors/time-off/{time_off_id}
  * callbacks: /callbacks, /callbacks/slots, /callbacks/check, /callbacks/reserve,
    /callbacks/claim, /callbacks/stats, /callbacks/{id}/cancel, /callbacks/{id}/complete
  * knowledge: handled by knowledge-service (/search, /knowledge/upload, /knowledge/documents)
  * audit and integrity: /audit/entries, /audit/verify, /jobs/integrity, /jobs/retention
  * supervision and analytics: /kpis, /analytics/trend, /telemetry/timeline, /agents/activity,
    /system/health, /system/overview
  * network: /outages, /outages/{outage_id}
  * reference catalogues: /reference/business-rules, /reference/business-rules/{rule_id},
    /reference/catalogs/{catalog}, /reference/products, /reference/products/{product_code},
    /reference/recharges, /reference/recharges/{code}, /reference/geo-areas,
    /reference/geo-areas/{area_code}
  * notifications: /notifications
  * health: /health

Note the client-side memory endpoints /me/memory and /me/memory/reset: the customer can consult
and reset what the platform remembers of them. That is a genuine and reportable privacy control.

## Frontend route inventory (verified by file listing)

Administration console (Frontend/admin_dashboard/src/routes), 20 route files:
  __root, index, login, overview, calls, customers, tickets, escalations, callbacks, advisors,
  availability, knowledge, policies, decisions, disputes, audit, analytics, agents,
  notifications, reference, settings.

Customer portal (Frontend/customer_portal/src/routes), 15 files:
  __root, index, login, signup, logout, _portal, and under _portal: assistant, billing, services,
  requests, activity, profile, security, preferences, about, help.

## Development-history evidence (for the chronology and the methodology section)

  * 260 commits, first on 2026-07-01, most recent on 2026-08-22.
  * Version branches up to version_112.
  * 59 version documents in docs/versions/, numbered 52 to 112.
  * The git repository was created on 2026-07-01, which is LATER than the start of the project
    (mars 2026). It records the consolidation phase, not the whole internship. Do not present the
    git dates as the project duration.

## Container topology (verified from the two compose files)

Infrastructure (infra/docker-compose/docker-compose.yml), 6 services:
  livekit-server, redis, postgres, qdrant, minio, otel-collector.
  Named volumes: postgres-data, minio-data, qdrant-data.

Applications (docker-compose.apps.yml), 16 services:
  context-service, knowledge-service, decision-service, policy-service, execution-service,
  notification-service, token-service, business-api, ai-knowledge-rag, ocs-billing-sim, nms-sim,
  provisioning-sim, ticketing-glpi, messaging-gateway, agent-worker, knowledge-models.

## NEGATIVE FINDING, important

MailHog does NOT exist anywhere in the project: not in either compose file, not in any source
file, not in .env.example. Only generic EMAIL_FROM and SMTP_HOST settings exist.
The workspace guide mentions MailHog; that mention is NOT supported by the code.
MailHog must NOT appear in the report.

---

# AJOUT VERIFIE (2026-08-24) : palier d'observabilite Prometheus et Grafana

Source : infra/observability/ (README.md, prometheus.yml, grafana/),
infra/docker-compose/docker-compose.observability.yml, Makefile.

## Composants

  * Prometheus v2.55.0, port 127.0.0.1:9090, intervalle de collecte 15 s,
    delai d'expiration 10 s, retention 15 jours, etiquette externe platform=telecom-ai-agent.
  * Grafana 11.3.0, port 127.0.0.1:3001 (3000 dans le conteneur).
    Source de donnees et tableaux de bord provisionnes par fichiers, uid fixe "prometheus",
    allowUiUpdates false. Pas d'inscription, pas d'acces anonyme.
  * Commandes : `make observability`, `make observability-down`, `make metrics`.
  * Generateur des tableaux de bord : scripts/build_dashboards.py.

## Cibles collectees

Un seul job "telecom-services" avec trois paliers d'etiquettes :
  * tier=platform : context 8101, knowledge 8102, decision 8103, policy 8104,
    execution 8105, notification 8106, token 8107, business-api 8108
  * tier=worker : agent-worker:8112 (expose depuis un fil prometheus_client et non une route
    ASGI ; c'est la SEULE source des TTFA/TTFT, des bascules de fournisseur et des escalades)
  * tier=simulator : ocs-billing-sim:8107, nms-sim:8108, provisioning-sim:8109
    (ports CONTENEUR, differents des ports publies 8109/8110/8111)
Plus un job "prometheus" sur lui meme.
Le collecteur OTel n'est deliberement PAS une cible : il n'est pas demarre par
`make observability`, une cible perpetuellement rouge apprendrait a ignorer le rouge.

12 services appellent instrument_app() : agent-worker, business-api, token-service,
context, decision, execution, knowledge, notification, policy, nms-sim, ocs-billing-sim,
provisioning-sim.

## Les neuf familles de mesures

telecom_http_requests_total (service, method, route, status)
telecom_http_request_duration_seconds (service, method, route)
telecom_policy_verdicts_total (action, verdict, rule)
telecom_actions_total (action, status)
telecom_escalations_total (trigger)
telecom_notifications_total (channel, status)
telecom_provider_fallbacks_total (component)
telecom_voice_ttfa_seconds (language)
telecom_voice_ttft_seconds (language)

## Maitrise de la cardinalite

L'etiquette route porte le GABARIT du routeur et non le chemin resolu ; une requete non
appariee tombe dans un unique seau <unmatched>. Les autres etiquettes proviennent de
vocabulaires bornes, et _bounded tronque toute valeur venue de l'exterieur.
Consequence : aucune donnee personnelle ne peut atteindre une etiquette, ce qui autorise a
exposer /metrics sans INTERNAL_API_KEY (comme /health), les ports restant sur la boucle locale.

## Les deux tableaux de bord (titres reels, en francais)

1. "Plateforme, sante des services" : Vue d'ensemble, Services actifs, Requetes/s, Erreurs 5xx,
   Latence p95, Trafic, Debit par service, Erreurs 5xx par service, Latence, p95 par service,
   Routes les plus lentes (p95). 11 panneaux.
2. "Agent IA, decisions, actions et voix" : Autorises, Refuses, Escalades, Part autorisee,
   Verdicts dans le temps, Repartition, Regles qui refusent le plus, Regles qui escaladent le
   plus, Actions executees, Rejeux idempotents, Projections en echec, Actions par type et issue,
   Escalades par declencheur, Notifications non delivrees par canal, Bascules de fournisseur,
   TTFA p95, TTFT p95, Appels mesures, TTFA par langue, TTFT par langue. 24 panneaux.

Chaque panneau declare son propre message d'etat vide, en distinguant un resultat
(aucune erreur) d'une absence d'entree (aucun appel sur la periode). Un ratio ne s'affiche
jamais a 0 % quand rien ne s'est produit : le denominateur est protege par > 0.

## Ce qui a change par rapport a l'etat anterieur

Auparavant, l'identifiant de correlation ET les metriques etaient conditionnes a la presence
d'un collecteur OTel et a OTEL_EXPORTER_OTLP_ENDPOINT. En deploiement par defaut, aucun
collecteur : aucune requete ne portait d'identifiant, les instruments ecrivaient dans le vide,
rien n'etait collecte. Les deux sont desormais inconditionnels (bibliotheque standard seule
pour la correlation, exposition /metrics pour les mesures). Les fonctions d'enregistrement
ecrivent dans LES DEUX destinations : activer OTLP ajoute les traces sans deplacer les metriques.

## Identifiant de correlation

Ordre de resolution : X-Correlation-ID ou X-Request-ID de l'appelant ; sinon l'identifiant de
trace d'un traceparent W3C ; sinon un identifiant de 32 caracteres hexadecimaux. Lie a un
contextvar, il suit le handler, les clients appeles et les taches d'arriere plan, figure dans
chaque ligne de journal et est renvoye dans la reponse. Il n'est PAS conserve au dela de la
requete : une connexion persistante sert plusieurs requetes et un contextvar non reinitialise
attribuerait a la requete N+1 l'identifiant de la requete N.
Limite connue : la ligne d'acces d'Uvicorn est ecrite apres le retour du middleware et affiche
un tiret ; son contenu est deja une serie Prometheus.

## Incidence sur le rapport

Nombre de conteneurs : 22 -> 24 (6 infrastructure, 16 applicatifs, 2 observabilite).
Mis a jour dans : figure de deploiement, figure de volumetrie, section 4.5.1, resume FR et EN,
conclusion generale, conclusion du chapitre 4.
Nouvelle sous-section 4.5.2 "Chaine d'observabilite" (4 sous-parties).
Nouvelle planche de captures ui-observabilite ; planche ui-exploit reorientee vers la collecte.
