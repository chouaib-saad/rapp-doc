# Report Content Plan

What the report must SAY, chapter by chapter, and where each element comes from.
Formatting concerns live in `07_TEMPLATE_RULES.md`. Structure lives in `01_REPORT_ROADMAP.md`.

## Writing standard

  * French throughout. "nous", never "je".
  * No code blocks, no snippets. Behaviour, workflows, architecture, measurements.
  * No em dashes, no tildes, no hyphens used as list markers or as punctuation dashes.
    Bullets allowed: disc, circle, square.
  * Never reintroduce a concept already introduced. Each chapter carries its own information.
  * Every figure and table introduced by its reference in the prose.
  * Terminology fixed: "la plateforme", "le système", "la solution proposée". Never a marketing
    name, never "MVP", "prototype", "première version".
  * Concepts explained briefly at the point of use; full theory in the appendices.

---

## Chapitre 1 — Présentation générale du projet

### 1.1 Organisme d'accueil
Content: Amsys Consulting, founded 2009, international technology consulting and engineering,
three service lines (IT engineering, automated solutions, business consulting), European and
Asian expansion, a dedicated AI and machine learning practice, information-security and quality
framework, cloud partnerships, and how that framework shaped the project's security boundaries,
observability practices and infrastructure choices.
Source: `prompts/some details to take on consederation.txt` (user-supplied prose, to be
rewritten and improved, not pasted).
Figure: logo (fig placeholder).

### 1.2.1 Cadre général
Content: the telecom customer-relations domain. Volume of routine interactions, the channels in
use, where a voice assistant fits. Introduce the operating constraint that governs everything
that follows: a spoken exchange only feels natural below a latency ceiling, which turns every
downstream design decision into a budget question.
Rule: no technology names yet, no architecture yet.

### 1.2.2 Problématique
Content: routine requests dominate the volume; existing channels rely on interactive voice
response trees, agent scripts and ticket escalation; consequences are waiting time, repeated
identification, transfers between departments, and reformulating the request at each transition.
Two consequences: operational (advisor time spent on predictable tasks) and commercial (friction
drives dissatisfaction and churn in a market where switching is easy).
Add what V2 missed: the trust problem. An automated system that can move money or provision a
line cannot be allowed to decide freely, so the real problem is not only automation but
automation that can be proven correct afterwards.

### 1.2.3 Solution proposée
Content: a self-hosted conversational platform that handles frequent requests end to end in
natural speech, in French, Arabic and English; grounds its answers in the operator's own
documentation; submits every consequential action to deterministic business rules before
execution; records each decision in a tamper-evident ledger; and escalates to a human with the
complete dossier when the situation requires it.
Keep it to the idea. No architecture, no component names.

### 1.2.4 Objectifs
Content: objectives phrased so that chapter 2 can turn each one into requirements, and chapter 4
can show each one satisfied. Draft set:
  * resolve frequent requests autonomously in natural spoken dialogue
  * hold a real-time conversational rhythm, interruptions included
  * ground every factual answer in the operator's documentation rather than model memory
  * subject every sensitive action to deterministic rules producing an explicit verdict
  * make every consequential act traceable and verifiable after the fact
  * hand over to a human with full context when autonomy is not appropriate
  * remain self-hosted and open where that preserves control over data and evolution
Source: README.md objectives, architecture rules 4 and 5, PROJECT_RECAP.md.

### 1.3 Étude de l'existant
Content: mandatory table système existant / avantages / inconvénients. Candidates: classic IVR
and scripted contact-centre tooling as the incumbent baseline, then PolyAI, Cognigy, Parloa as
the market solutions. For each: what it does well, and what it does not expose (managed service,
opaque reasoning chain, low-code ceiling on orchestration depth, no explicit deterministic policy
surface, no self-hosting). Close by stating which drawbacks the proposed solution addresses,
because the supervisor requires that this table be answered in chapter 4.
Source: V2 chapter 1 survey. MUST be re-verified against public information before any factual
claim about a vendor is kept, and rewritten in our own words.
Table: comparison. Figure: none needed.

### 1.4 Chronologie
Content: Gantt over mars to août 2026. Phases derived from the real increments: cadrage and
study, architecture foundations, real-time voice chain, domain services and the decision chain,
knowledge and retrieval, integration with ticketing and escalation, interfaces, observability
and hardening.
Evidence: 112 numbered versions, one branch per version, 260 commits, a version document per
increment in `docs/versions/`.
Figure: Gantt placeholder.

### 1.5 Processus de développement
Content: iterative and incremental lifecycle. Why it was appropriate: the target behaviour could
not be fully specified in advance because it depended on measurements that only exist once a
stage runs; each increment therefore had to be built, measured and either kept or replaced. Give
the concrete shape: one increment equals one numbered version, one branch, one version document,
one revertible change set. Mention the discipline that came with it (a change that touches a
load-bearing mechanism gets its own commit and its own note).
Figure: iterative and incremental cycle placeholder.
Table: possibly increments grouped by theme.

---

## Chapitre 2 — Spécification des besoins

### 2.1 Acteurs
Primary: Client, Conseiller, Superviseur, Administrateur.
Secondary (external systems the platform interacts with): the ticketing system, the telecom
business systems, the notification channel.
Note: the roles Conseiller, Superviseur and Administrateur are backed by the real role gates
(`require_role`, `requireRole`) and by the advisor registry and availability data.
Table: actors and their responsibilities.

### 2.2 Besoins fonctionnels
Grouped by theme, each expressed from the actor's standpoint, each traceable to a real
capability:
  * conversation: initiate a voice or text exchange, keep session continuity across turns,
    understand the request, ask a single precise clarification when ambiguous, switch spoken
    language on request, interrupt the assistant at any moment
  * context: retrieve the customer profile, subscription and recent history automatically
  * knowledge: answer documentary questions grounded in the operator's corpus, and abstain when
    the corpus does not answer
  * action: verify identity before a sensitive operation, obtain an explicit verdict, execute the
    approved action once and only once, confirm it verbally
  * ticketing: consult existing tickets, create, update and close tickets against the ticketing
    system
  * escalation: recognise when a human is required, transfer the call when an advisor is free,
    otherwise negotiate and reserve a callback slot and notify the advisor with the dossier
  * supervision: consult call history and transcripts, inspect decisions and verdicts, manage the
    knowledge base, manage advisors and availability, manage rules and policies, verify the audit
    chain
Table: functional requirements with identifiers, reused as the traceability spine in chapter 4.

### 2.3 Besoins non fonctionnels
Only the ones the platform genuinely exercises, each attached to a concrete mechanism so the
section is defensible rather than a generic list:
  * Performance and real-time behaviour: latency budget across the spoken chain
  * Reliability and availability: provider fallback chains, degraded modes
  * Robustness and fault tolerance: an outage on one provider must not drop the call
  * Security and privacy: role-based access, data ownership isolation, masking of personal data
  * Auditability and traceability: verdict identifiers, tamper-evident chain
  * Scalability: concurrent conversations and concurrent agent execution
  * Interoperability: standard interfaces towards the ticketing and telecom systems
  * Portability: containerised runtime
  * Maintainability and extensibility: ports and adapters, replaceable providers
  * Testability: isolated deterministic components
  * Usability: natural spoken interaction, French first
Source: the NFR list in `prompts/rapport generation rules...txt`, filtered against real
mechanisms. Do NOT import the clinical/robotics examples from that list.
Table: non-functional requirements against the mechanism that satisfies each one.

### 2.4 Cas d'utilisation
General diagram, then three detailed ones. Selected for maximum coverage of the system's real
value:
  * CU1 "Obtenir une réponse documentaire" — covers conversation, context, retrieval, abstention
  * CU2 "Exécuter une opération sensible" — covers identity verification, the decision chain, the
    explicit verdict, idempotent execution, audit. This is the most important use case and gets
    the fullest textual description.
  * CU3 "Escalader vers un conseiller humain" — covers advisor availability, transfer, callback
    negotiation, notification with dossier.
Each: use-case diagram, textual description (acteurs, préconditions, scénario nominal,
scénarios alternatifs, postconditions), and a system sequence diagram of the nominal scenario.

---

## Chapitre 3 — Conception

### 3.1.1 Architecture logique
Layered hexagonal design: the domain core holds business rules and defines ports; adapters
implement those ports towards the outside world; the real-time layer is an entry adapter holding
no business logic. Bounded contexts: conversation, knowledge, decision and policy, execution,
ticketing, notification, identity and access, supervision.
Explicitly present the rule that business rules never depend on a vendor SDK, and the rule that
the real-time entry point is a composition root only.
No technology names in this subsection, per the supervisor.
Figures: layered architecture; package diagram; component diagram.

### 3.1.2 Diagrammes de classes
Three, each answering a different question:
  * the persona hierarchy: a base conversational agent holding the shared behaviour (turn
    observation, sentiment scoring, conversation logging, closing protocol, language policy,
    abstention rule) and the specialised personas deriving from it. Include the contract
    enforcement idea: a persona cannot be instructed to use a capability it does not own.
  * the decision and policy model: action, context, rule, verdict with its identifier and
    justification, and the rule set composition.
  * the knowledge model: document, version, chunk, index point, retrieval result.
Design patterns to surface implicitly through the diagrams: Strategy (sentiment scorer, and the
provider builders), Adapter (external systems), Composite/Chain (the rule set), Facade (the
tools), Singleton-like accessors for the typed clients.
Figures: three class diagrams.

### 3.1.3 Bases de données
Entity-association model over the real schemas. The persistence layer registers 16 model
modules. Present the main domains: conversation and call sessions, turns and transcripts;
knowledge documents, chunks, ingestion jobs and the synchronisation outbox; ticketing;
advisors, availability and callbacks; decisions, verdicts and the action ledger; the audit
chain; reference catalogues.
Explain the two deliberate asymmetries: the knowledge index is derived and rebuildable while the
relational store is the system of record, and the ticketing projection is a read model while the
external ticketing system stays authoritative.
Figure: entity-association diagram. Table: main entities and their role.

### 3.2.1 Séquence
  * an end-to-end conversational turn, from spoken input to spoken answer
  * a sensitive action: context assembly, decision proposal, binding verdict, conditional
    execution, audit entry
Figures: two sequence diagrams.

### 3.2.2 Activités
  * documentary ingestion: parse, extract metadata, segment, encode, persist, synchronise
  * retrieval: dense gate, sparse co-gate, rank fusion, relevance gate, abstention branch
Figures: two activity diagrams.

### 3.2.3 États-transitions
  * conversation lifecycle
  * ticket lifecycle (the real vocabulary: open, in_progress, pending, resolved, closed)
Figures: two state diagrams.

### 3.3 Conception du système agentique [ADD]
  * what an agent is here, and the reasoning pipeline: interpret, plan, decide, act under
    constraint. Keep it short and concrete.
  * the specialist decomposition and why it exists: three declared domains (facturation, gestion
    de compte, technique) plus a triage persona and a manager persona; the domain table as the
    single source of truth so a domain can never be named in a prompt without the matching
    capability; deterministic spoken transition lines so the handover sentence is not left to
    the model
  * context construction: what enters an agent's working context and on what condition
    (customer profile, conversation history, verified identity state, ticket history on demand,
    retrieved knowledge on demand, business constraints, available capabilities)
  * memory: short-term conversational continuity versus the longer-term brief carried across
    interactions
  * guardrails and determinism: why the model does not decide sensitive matters; the explicit
    verdict vocabulary; the traceable rule identifier; the sentiment signal as an additional
    input to escalation
  * the progression from prompt engineering to context engineering to the surrounding harness,
    and why a single large prompt is insufficient at this complexity
Figures: agent reasoning pipeline; multi-agent orchestration and handover; context assembly;
guardrail decision flow.

### 3.4 Conception de la sécurité et du contrôle d'accès [ADD]
Centralised authentication, then role-based authorisation; separate client portal and
administration console; server-side enforcement as the real boundary with interface guards only
improving the experience; ownership isolation so a customer can only reach their own data;
step-up identity verification for sensitive telecom operations, which is a separate concern from
portal authentication; the decision, policy, execution and audit chain as the inner protection;
fail-closed behaviour when authorisation information is missing.
Source: the security block in `prompts/rapport generation rules...txt`, cross-checked against the
real substrate in PHASE1 section 5 and `08_PROJECT_FACTS.md`.
Figures: authentication and authorisation model; permission matrix table.

---

## Chapitre 4 — Réalisation

### 4.1 Technologies
Grouped by role, each with a sentence on why it is there. Backend and domain services, the
real-time framework, the data stores, the vector index, the object store, the messaging and
integration surfaces, the frontends, the observability stack, the containerisation.
LiveKit positioning per decision D08.
Table: technologies by layer with their role.

### 4.2 Outils d'implémentation
Development hardware and software environment, version control and the branch-per-increment
discipline, the container toolchain, the testing tooling, the API exploration tooling.
Table: hardware; table: software.

### 4.3 La chaîne temps réel [ADD]
One subsection per stage. Each follows the same shape so the chapter reads as one argument:
role of the stage, how it is realised, what was measured, what alternatives were considered,
what the choice cost. Stages: session establishment and transport; voice activity detection and
turn taking; transcription; reasoning; documentary retrieval under real-time constraint; speech
synthesis; interruption handling and the end-to-end latency budget.
Every provider chain is real and verified in `08_PROJECT_FACTS.md`.
Figures: real-time chain overview; per-stage latency contribution; provider comparison curves.
Tables: provider comparison per stage; latency budget.

### 4.4 Concurrence et gestion des ressources [ADD]
Agent workers and their lifecycle; concurrent conversations; isolation of concurrent operations
within a single call through operation identity, so two operations in the same conversation can
never overwrite one another; the separation of the durable write path from the voice path so
that a storage incident degrades the record and never the call; memory and buffer considerations.
Figure: concurrency and worker lifecycle.

### 4.5 Architecture physique et évolution temporelle
Deployment diagram over the real container topology (6 infrastructure services and 16 application
containers, verified). Then a timing diagram for a complete conversational exchange.
Figures: deployment diagram; timing diagram.

### 4.6 Interfaces de l'application
See the screenshot inventory below.

### 4.7 Vérification et évaluation [ADD]
The test suites that exist and what each protects; deterministic-behaviour testing; abstention
and hallucination-prevention testing; concurrency and idempotency testing; provider-failure
exercises through deliberate fault injection; multilingual acceptance testing.
Table: test families against the property each one protects.

### 4.8 Résultats et statistiques
The measurement set per decision D12, stated plainly as a reconstructed and conservative
approximation derived from the real stages and configuration, not a raw campaign.
Real measured data available and to be used as such: the retrieval calibration table, the
cross-encoder inversion measurement, the language asymmetry figures.
Figures: latency distribution; retrieval quality comparison; gate effect before and after.
Tables: end-to-end latency breakdown; retrieval quality.

### 4.9 Problèmes rencontrés
Real, documented difficulties and how they were resolved. Strong candidates, all verified:
  * the silent retrieval downgrade that made the assistant look grounded while answering from
    term overlap, and the decision that a silent downgrade is worse than an outage
  * the cosine inversion where an off-domain question outranked a correct Arabic answer, and why
    no threshold could fix it
  * the cross-language asymmetry that makes a single global threshold tighter for Arabic
  * the frustration model that was simultaneously too sensitive and too forgiving
  * the configuration hazard where two services could resolve to the same address, and the
    start-up guard added against it
  * the sensitive-action replay problem and the fields that had to be excluded from operation
    identity because they legitimately change between an attempt and its retry
Each told as observation, analysis, decision, result.

---

## SCREENSHOT INVENTORY for 4.6 (decided, verified against the real route files)

Verified: the administration console has 20 route files and the customer portal has 15.
Selection rule applied: keep only the surfaces that demonstrate a core capability of the
platform. Excluded on purpose: about, help, preferences, profile, signup, logout, settings,
index redirects. These add no engineering value to the report.

### 4.6.1 Portail client (4 captures)
  1. `_portal/assistant` — the voice session in progress. THE flagship capture: it shows the
     live conversational surface, the transcript and the session state.
  2. `_portal/billing` — invoices and balance, the surface behind the billing domain.
  3. `_portal/requests` — the customer's tickets and callbacks, the visible output of the
     ticketing and escalation chain.
  4. `_portal/activity` — interaction history, the customer-side view of the durable record.
  Optional fifth if a good capture exists: `_portal/security` for identity and access.

### 4.6.2 Console d'administration et de supervision (8 captures)
  5. `overview` — the operational overview, the entry point of supervision.
  6. `calls` — call history with duration, language and the transcript view. Shows the durable
     conversation record.
  7. `decisions` — decision and verdict inspection. The single most important administration
     capture: it makes the deterministic chain visible.
  8. `policies` — management of the business rules and guardrails.
  9. `knowledge` — the documentary corpus, its versions and its ingestion state.
 10. `escalations` — escalations and their dossier.
 11. `availability` (with `advisors`) — advisor registry and availability slots, the backing of
     callback negotiation.
 12. `audit` — the integrity chain and its verification. Strong evidence of the provability
     principle.
  Secondary, include if the section still has room: `analytics`, `tickets`, `customers`
  (customer 360), `agents`.

### 4.6.3 Systèmes intégrés (2 captures)
 13. The external ticketing system showing a ticket created by the platform, side by side with
     the same ticket in the console. This proves the integration is real rather than simulated.
 14. The vector index or object store console showing the indexed corpus.

### 4.6.4 Supervision et observabilité (3 captures)
 15. Grafana dashboard of the real-time chain.
 16. Prometheus targets and a metric query.
 17. Distributed trace of one conversational exchange showing the per-stage contribution.
     TO BE CONFIRMED that traces are exposed in a viewable form.

### 4.6.5 Environnement d'exécution (1 capture)
 18. The container topology running, showing the infrastructure and application services
     together. Backs the deployment diagram of 4.5 with real evidence.

TOTAL: 18 captures, 4 optional extras.
All are placeholders until the user supplies the images. Each placeholder in the LaTeX source
names the exact route or surface required so nothing is ambiguous at capture time.

NOT INCLUDED and why: MailHog appears in the workspace guide but does NOT exist anywhere in the
real project (no compose service, no reference in source, only generic SMTP settings). It must
not appear in the report.

---

## Content Not Yet Verified

  * Vendor claims about PolyAI, Cognigy and Parloa: re-verify before use in 1.3.
  * Whether distributed traces are exposed in a viewable interface: affects capture 17.
  * Bibliography mechanism used by the template (manual thebibliography or a .bib file).
  * Jury names and defence date for the cover page and `Commands.tex`.

## Writing Dependencies

  * Section 4.6 requires the user's screenshots.
  * Section 4.8 requires the measurement set to be constructed first (decision D12).
  * Introduction Générale and Conclusion Générale require all four chapters to be final.
