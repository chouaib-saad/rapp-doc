# Report Decisions

This file records important decisions that should remain stable unless explicitly reconsidered.

## Established Decisions

### D01 — Report language
Decision: The report body is written in FRENCH. Only the abstract exists in two versions (French + English).
Evidence: `prompts/rapport generation rules...txt` (explicit); supervisor outline `PFE_Report_Outline.pdf` is French.
Status: LOCKED.

### D02 — Author voice
Decision: Use "nous", never "je", throughout the report.
Evidence: Supervisor outline, first page: "Utiliser \"nous\" au lieu de \"je\"".
Status: LOCKED.

### D03 — Structural baseline
Decision: Follow the supervisor's four-chapter structure, not the V2 Scrum sprint-per-chapter structure.
  1. Presentation generale du projet
  2. Specification des besoins
  3. Conception
  4. Realisation
  Plus: Introduction Generale, Conclusion Generale, Bibliographie, Netographie, Annexe.
Evidence: `importants/my_supervisor_report_guide/PFE_Report_Outline.pdf`; `importants/Readme.txt` priority rule.
Adaptation right: sections/subsections may be ADDED because our project is larger, but the skeleton and
the order of the supervisor's own sections must be preserved. Adaptations must stay limited and defensible.
Status: LOCKED.

### D04 — Chapter 4 organisation
Decision: Option A. Nine sections. All six supervisor-mandated sections kept in their original order,
new ones inserted between them:
  1. Technologies
  2. Outils d'implementation
  3. Chaine temps reel (one subsection per stage)   [ADDED]
  4. Concurrence et gestion des ressources          [ADDED]
  5. Architecture physique et evolution temporelle
  6. Interfaces de l'application
  7. Verification et evaluation                     [ADDED]
  8. Resultats et statistiques
  9. Problemes rencontres
Evidence: `prompts/some details to take on consederation.txt`, user answer to Question 1.
Status: LOCKED by user.

### D05 — Bullet lists
Decision: Allowed, normal academic use, only where a genuine list exists.
Permitted markers: solid circle (disc), open circle (ring), square.
Forbidden: dashes/hyphens as list markers, em dashes, tildes, decorative AI symbols.
Evidence: `prompts/some details to take on consederation.txt`, user answer to Question 2.
Status: LOCKED by user.

### D06 — Glossaries and metric formulas
Decision: Short functional explanation inline at the point of use; full theory in the appendix.
Applies to the RAG glossary, the STT/TTS glossary, and the metric formulas.
Evidence: `prompts/some details to take on consederation.txt`, user answer to Question 3 (Option B).
Status: LOCKED by user.

### D07 — Naming of the real operator
Decision: The telecom operator is kept generic/anonymous. The report focuses on the platform,
its architecture and its implementation depth rather than on a named client.
Evidence: `prompts/some details to take on consederation.txt`, user delegated the call and leaned this way.
Status: LOCKED.

### D08 — LiveKit positioning
Decision: LiveKit is presented as an open-source realtime communication framework that solves hard
realtime infrastructure concerns (realtime audio, concurrency, buffering, resource management,
multi-user sessions). The engineering work of the project (agent logic, business rules, tools, RAG,
memory, ticketing, guardrails, orchestration, data, integrations) remains ours and must carry the report.
LiveKit must never appear as the thing that built the platform.
Evidence: `prompts/rapport generation rules...txt`, dedicated LiveKit block.
Status: LOCKED.

### D09 — LaTeX template
Decision: Reuse the `pfe-report.cls` architecture, `main.tex` orchestration and `Commands.tex` macro
conventions from `rapport_de_pfe_V2.zip` without redesigning them. Content is fully rewritten.
Protected files: `Commands.tex`, `main.tex`, `pfe-report.cls` (modify only when technically necessary,
smallest possible change; `Commands.tex` legitimately needs the real author/jury/title values).
Evidence: `latex_template_to_use/Readme.txt`, rules 1 to 10.
Status: LOCKED.

### D10 — Figures during writing
Decision: Figures are placeholders while chapters are drafted. Each placeholder states exactly which
visual goes there and why. Real figures are produced after the chapter is validated.
Evidence: `prompts/rapport generation rules...txt`, visual placeholder block.
Status: LOCKED.

### D11 — No source code in the report
Decision: No code blocks, no snippets. Behaviour, workflows, pipelines, architecture, diagrams,
tables and curves instead. The document must not read like developer documentation.
Evidence: `prompts/rapport generation rules...txt`.
Status: LOCKED.

### D12 — Measured results
Decision: A full manual measurement campaign is out of time budget. Performance figures are produced
as a controlled, conservative simulated measurement set derived from the real architecture, the real
processing stages and the real configuration. The report states plainly that these are reconstructed
approximations, not a raw measurement campaign. Values stay moderate and technically credible.
Evidence: `prompts/rapport generation rules...txt`, final block, points 1 to 3.
Status: LOCKED by user.

### D13 — Organism and people
Decision: Host organism is Amsys Consulting (founded 2009). Pedagogical supervisor: Mme Maha Khemaja.
Professional supervisor: M. Ayoub Mejri. Author: Chouaib Saad. Institution: ISSAT Sousse.
The Remerciements and Dedicace texts are supplied by the user and used as provided, subject only to
light structural adaptation.
Evidence: `prompts/some details to take on consederation.txt`; `pfe-report.cls` footer "ISSAT Sousse".
Status: LOCKED.

### D14 — Methodology
Decision: TO BE RESOLVED. The supervisor outline requires section 1.5 "Processus de developpement".
V2 used Scrum. Whether the final report keeps Scrum as the declared lifecycle while abandoning the
sprint-per-chapter layout must be confirmed against the real project evidence before Chapter 1 is written.
Status: TO BE RESOLVED.

## Changed Decisions

### V2 chapter organisation abandoned
Previous: seven chapters, one per Scrum sprint (V2 draft).
New: supervisor's four-chapter structure (D03).
Reason: the supervisor-recommended structure has priority over any previous draft, and the user
confirmed Chapter 4 must hold the nine-section Realisation layout, which only fits the four-chapter form.

## Rule
Never silently change an established decision.

### D15 — Allègement du rapport (2026-08-23)
Decision: ramener le rapport de 156 à 123 pages sans sacrifier le fond, par quatre leviers :
  1. Suppression des tableaux devenus redondants avec les figures produites
     (topologie de déploiement, schémas de base, ports du domaine).
  2. Suppression des deux tableaux de besoins fonctionnels (34 lignes). Les identifiants
     BF01 à BF34 n'étaient repris nulle part ailleurs : la traçabilité annoncée n'existait
     pas. Remplacés par une carte visuelle des huit domaines.
  3. Conversion des tableaux de chiffres en illustrations (volumétrie, familles de
     vérifications), et regroupement des captures d'interface en planches de deux.
  4. Passage de l'interligne double à l'interligne un et demi.
Evidence: demande explicite de l'utilisateur, jugeant le rapport trop long et trop dense.
Impact: 156 -> 123 pages. Aucun contenu technique vérifié n'a été supprimé.
Réversibilité: l'interligne se rétablit en remplaçant les deux `\onehalfspacing` de
`main.tex` par `\doublespacing`. La version 156 pages est archivée dans
`archives/v1_complet_156p_2026-08-23_1537/`.
Status: LOCKED.

### D16 — Placement des figures
Decision: `\figureTikz` utilise `[!htb]` et non `[H]`.
Reason: le placement forcé laissait de larges zones blanches en bas de page lorsque la
figure suivante ne tenait plus. Vérifié après changement : une seule figure sur quarante six
s'écarte de deux pages de sa citation, toutes les autres restent sur la même page ou la
suivante.
Status: LOCKED.
