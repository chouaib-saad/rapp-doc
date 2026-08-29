# Report Roadmap

## Objective
Complete structure of the final report. Baseline is the supervisor outline
(`importants/my_supervisor_report_guide/PFE_Report_Outline.pdf`). Every deviation is tagged and
justified. Tags: [SUP] supervisor-mandated, [ADD] project-specific addition, [OPT] optional.

## Global parameters (locked)

  * Language: French. Abstract in French and English.
  * Voice: "nous", never "je". [SUP]
  * Target volume: 90 to 120 pages.
  * Methodology declared: processus itératif et incrémental.
  * Project period: mars à août 2026.
  * Every figure and table is introduced by its reference in the prose. [SUP]
  * Citations with \cite at the point of use. [SUP]
  * No code blocks. Diagrams, tables, curves and prose instead.
  * Figures are placeholders during drafting; each placeholder names the exact visual required.

## Front Matter

  * Page de garde (existing PDF, `chapters/00-PageDeGarde.pdf`)
  * Remerciements [SUP] — text supplied by the user, used as provided
  * Dédicace [SUP] — text supplied by the user, used as provided
  * Résumé (FR) / Abstract (EN) — two versions, per the user instruction
  * Table des matières [SUP]
  * Liste des figures [SUP]
  * Liste des tableaux [SUP]
  * Liste des abréviations [ADD, template provides `acronym`]
  * Introduction Générale [SUP] — exactly three paragraphs: the domain, the subject of the
    internship, the announcement of the report plan

## Chapitre 1 — Présentation générale du projet   [SUP]

Purpose: situate the project. Who the host organisation is, what problem exists, what we propose,
what we commit to deliver, how the work was organised in time.

Sections:
  * Introduction (unnumbered) [SUP]
  * 1.1 Présentation de l'organisme d'accueil [SUP]
  * 1.2 Présentation du projet [SUP]
      - 1.2.1 Cadre général du projet [SUP]
      - 1.2.2 Problématique [SUP]
      - 1.2.3 Solution proposée [SUP]
      - 1.2.4 Objectifs [SUP]
  * 1.3 Étude de l'existant [SUP] — mandatory table: système existant / avantages / inconvénients
  * 1.4 Chronologie [SUP] — Gantt over mars to août 2026
  * 1.5 Processus de développement [SUP] — itératif et incrémental
  * Conclusion (unnumbered) [SUP]

Figures: logo of the organisation; Gantt; iterative-incremental cycle diagram.
Tables: comparison of existing solutions.
Evidence: `prompts/some details...txt` (organisation prose), V2 chapter 1 (existing-solutions
survey, to be re-verified and rewritten), git history (112 versions, 260 commits).
Dependencies: none. Written first.

## Chapitre 2 — Spécification des besoins   [SUP]

Purpose: turn the objectives into actors, requirements and use cases. No technology names yet.

Sections:
  * Introduction [SUP]
  * 2.1 Acteurs [SUP]
  * 2.2 Besoins fonctionnels [SUP]
  * 2.3 Besoins non fonctionnels [SUP] — drawn from the NFR list in the guide, only those the
    platform actually exercises, each tied to a concrete platform mechanism
  * 2.4 Diagrammes de cas d'utilisation [SUP]
      - 2.4.1 Diagramme général [SUP]
      - 2.4.2 Cas d'utilisation détaillé 1 [SUP] + description textuelle + diagramme de séquence
        système
      - 2.4.3 Cas d'utilisation détaillé 2 [SUP] idem
      - 2.4.4 Cas d'utilisation détaillé 3 [SUP] idem
  * Conclusion [SUP]

Candidate actors: Client, Conseiller, Superviseur, Administrateur, plus the external systems
(GLPI, systèmes télécom) as secondary actors.
Candidate detailed use cases (the three most important, to be fixed in the content plan):
  UC-A "Résoudre une demande courante par la voix"
  UC-B "Exécuter une action sensible" (the Decision, Policy, Execution invariant)
  UC-C "Escalader vers un conseiller humain"
Figures: general use-case diagram; three detailed use-case diagrams; three system sequence
diagrams.
Tables: actors; functional requirements; non-functional requirements.
Dependencies: chapter 1 objectives.

## Chapitre 3 — Conception   [SUP]

Purpose: how the system is designed, independently of the technologies. The supervisor is
explicit that technology names do not belong in 3.1.1.

Sections:
  * Introduction [SUP]
  * 3.1 Vue statique de l'application [SUP]
      - 3.1.1 Architecture logique du logiciel [SUP] — hexagonal/clean layering, ports and
        adapters, bounded contexts; package diagram and component diagram
      - 3.1.2 Diagrammes de classes [SUP] — the persona hierarchy rooted on the base agent; the
        deterministic policy engine; the knowledge/retrieval model
      - 3.1.3 Bases de données [SUP] — entity-association model over the real schemas
        (conversation, knowledge, ticketing, reference and the rest of the 16 model modules)
  * 3.2 Vue dynamique de l'application [SUP]
      - 3.2.1 Diagrammes de séquence [SUP] — end-to-end voice turn; sensitive action chain
      - 3.2.2 Diagrammes d'activités [SUP] — RAG ingestion; RAG retrieval with its three gates
      - 3.2.3 Diagrammes états-transitions [SUP] — conversation lifecycle; ticket lifecycle
  * 3.3 Conception du système agentique [ADD] — justified: the multi-agent orchestration, the
    persona contract, context and memory construction, and the guardrail layer are the core
    design contribution and have no home in a purely static/dynamic split
  * 3.4 Conception de la sécurité et du contrôle d'accès [ADD] — justified: authentication,
    RBAC, data ownership isolation, step-up identity verification and auditability are design
    decisions, not implementation details
  * Conclusion [SUP]

Figures: layered/hexagonal architecture; package diagram; component diagram; class diagrams (3);
entity-association diagram; sequence diagrams (2); activity diagrams (2); state diagrams (2);
agent orchestration diagram; agent reasoning pipeline; context assembly diagram; security model
diagram.
Dependencies: chapter 2 use cases.

## Chapitre 4 — Réalisation   [SUP, nine sections, order locked by decision D04]

Purpose: what was actually built, with what, how fast it runs, how it was verified.

Sections:
  * Introduction [SUP]
  * 4.1 Technologies [SUP]
  * 4.2 Outils d'implémentation [SUP]
  * 4.3 La chaîne temps réel [ADD] — one subsection per stage, each with its role, its
    measurement and its provider study
      - 4.3.1 Établissement de la session et transport temps réel (WebRTC, jeton, dispatch)
      - 4.3.2 Détection d'activité vocale et gestion des tours de parole
      - 4.3.3 Transcription (STT): chaîne de repli, métriques WER/RTF, choix du modèle
      - 4.3.4 Raisonnement (LLM): TTFT, fenêtre de contexte, appel d'outils, chaîne de repli
      - 4.3.5 Récupération documentaire (RAG) en contrainte temps réel
      - 4.3.6 Synthèse vocale (TTS): streaming, TTFB, choix du fournisseur
      - 4.3.7 Gestion des interruptions et budget de latence de bout en bout
  * 4.4 Concurrence et gestion des ressources [ADD] — agent workers, isolation of concurrent
    operations, idempotency keys, buffers, CPU/RAM, dynamic worker lifecycle
  * 4.5 Architecture physique et évolution temporelle [SUP] — deployment diagram, timing diagram
  * 4.6 Interfaces de l'application [SUP] — client portal, admin dashboard, observability
    surfaces; screenshots to be supplied
  * 4.7 Vérification et évaluation [ADD] — test suites, agent evaluations, guardrail tests,
    chaos/fallback exercises
  * 4.8 Résultats et statistiques [SUP] — latency breakdown, retrieval quality, comparison curves
  * 4.9 Problèmes rencontrés [SUP]
  * Conclusion [SUP]

Figures: deployment diagram; timing diagram; latency budget chart; STT/LLM/TTS comparison curves;
retrieval quality curves; interface screenshots.
Tables: technologies; hardware/software environment; provider comparisons; latency breakdown;
retrieval measurements; test coverage.
Dependencies: chapter 3 design; screenshots from the user; the measurement set built per D12.

## End Matter

  * Conclusion Générale [SUP] — exactly three paragraphs: application context within the host
    organisation, summary of the work achieved, genuinely feasible perspectives
  * Bibliographie [SUP] — numbered, author, title, venue, date; \cite at point of use
  * Nétographie [SUP] — numbered, URL, consultation date
  * Annexes [SUP]
      - Annexe A: glossaire et fondements de la recherche augmentée par récupération
      - Annexe B: glossaire et formules de la chaîne vocale (WER, CER, MER, WIL, DER, RTF,
        MOS, MCD, PESQ, STOI, TTFT/TTFB, SNR)
      - Annexe C: concepts des systèmes agentiques et ingénierie du contexte
      - Annexe D: modèle détaillé d'authentification, d'autorisation et d'audit

## Writing order

  1. Chapitre 1
  2. Chapitre 2
  3. Chapitre 3
  4. Chapitre 4
  5. Introduction Générale and Conclusion Générale (written last so they match the real content)
  6. Résumé / Abstract
  7. Annexes
  8. Bibliographie and Nétographie (accumulated while writing, finalised at the end)
  9. Liste des abréviations (accumulated while writing)

Rationale for writing the general introduction last: it must announce the plan exactly as the
plan ended up, and the supervisor requires paragraph 3 to announce the report structure.

## Dependencies on information still to be supplied

  * Interface screenshots for section 4.6 (`screenshots_for_plateform_graphana_promptheuse/` is
    currently empty apart from its readme).
  * Grafana and Prometheus dashboards: to be confirmed and captured.
  * Jury member names and the defence date for `Commands.tex` and the cover page.

## Roadmap Rules

  * Do not invent chapter content.
  * Update this roadmap when the structure changes.
  * Keep planned structure separate from completed content.
