# Open Tasks

Active after Phase 2 + final reading + Phase 5 figure 1. No LaTeX build in sandbox.

## Critical
- [ ] Cover page (user redoes in French, provides PDF `chapters/00-PageDeGarde.pdf`).
- [ ] Jury + defence date in `Commands.tex` (`À PRÉCISER` for dateSoutenance / juryPresident).

## High Priority — Phase 5 diagrams (ONE at a time)
- [x] **Figure 1: fig-cycle-iteratif.svg** — exact supervisor image inserted, text aligned.
- [x] **Figure 2:** fig-deploiement (Ch4) — EXACT user SVG + architectural table/text.
- [x] **Figure 3:** fig-cu-general (Ch2) — EXACT user SVG, FULL PAGE, back-office/RBAC text adapted. CONFIRMED.
- [x] **Figure 4:** fig-cu-doc (Ch2) — EXACT user SVG named 'Obtenir une réponse fondée sur les connaissances'; Ch2 rename + table/prose adapted (context, knowledge base). CONFIRMED.
- [x] **Figure 5:** fig-cu-action (Ch2) — EXACT user SVG 'Réalisation d'une opération sécurisée'; Ch2 table/prose adapted (CIN, journal d'audit, issues). CONFIRMED.
- [x] **Figure 6:** fig-cu-escalade (Ch2) — EXACT user SVG 'Gestion d'une demande d'assistance humaine'; Ch2 renamed + table/prose adapted (ticket de suivi, notification). CONFIRMED.
- [x] **Figure 7:** fig-seq-doc (Ch2) — EXACT user sequence SVG; case renamed 'Recherche et génération d'une réponse fondée sur les connaissances'; Ch2 adapted. CONFIRMED.
- [x] **Figure 8:** fig-seq-action (Ch2) — EXACT user sequence SVG; Ch2 case renamed 'Réalisation d'une opération sécurisée'; seq intro + invariant integrated. CONFIRMED.
- [x] **Figure 9:** fig-seq-escalade (Ch2) — EXACT user sequence SVG; Ch2 case renamed BACK to 'Escalade vers un conseiller humain'; seq intro adapted to 6 participants/alt/ticket. CONFIRMED. fig-cu-escalade.svg title line updated.
- [x] **Figure 10:** fig-classes-domaine (Ch3) — EXACT user class diagram; Ch3 §Modèle du domaine adapted to aggregates/value objects/enums. CONFIRMED (b779191). Post-confirm: MSISDN renamed to 'Numéro d'appel' in fig-classes-domaine.svg + fig-mcd.tex.
- [ ] **Figure 11:** fig-classes-agents (Ch3) — AWAITING user-supplied complete SVG. Do NOT use the draft; user will send the final SVG.
- [ ] then the remaining figures in the order below (validate each before the next):
      fig-cu-action, fig-cu-escalade, fig-seq-*, fig-classes-*, fig-act-*,
      fig-etats-*, fig-pipeline-agent, fig-orchestration, fig-contexte, fig-chaine-temps-reel,
      fig-budget-latence, fig-volumetrie, fig-positionnement-fournisseurs, fig-rag-comparaison,
      fig-concurrence, fig-chronogramme, fig-verifications, fig-securite, fig-composants, etc.
- [ ] After all figures: report-wide consistency check of figures vs text.

## Normal Priority
- [ ] Captures d'écran placeholders (ui-*) — still placeholders awaiting real screenshots; one
      figure per capture (no side-by-side planches).
- [ ] Logo Amsys for figure 1.1 if not yet replaced.

## Content / Deferred
- [ ] Increment count semantic — if re-introduced, must use functional-slice (18) definition, never
      112/260; requires a memory rule + user decision.
- [ ] fig-volumetrie row "Périmètre et travail" has 2 cells (9 ops, 3 langues); user chose to leave
      until Phase-5 restyle.

## Final Review Tasks
- [ ] User compiles locally (MiKTeX) and reports page count / errors / overfull.
- [ ] Relecture intégrale par l'utilisateur.
- [ ] Volume check after all diagrams.

## Task Rule
Each task actionable & precise. Move finished tasks to `02_PROGRESS.md`.
