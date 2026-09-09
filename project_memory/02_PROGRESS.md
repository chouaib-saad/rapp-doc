# Report Progress

This file records what has actually been completed.

## Completed
- [x] Workspace analysis (every folder swept, markdown read first)
- [x] Template analysis (V2 zip studied, class/main/Commands understood)
- [x] LaTeX build environment set up and verified in `rapport_folder/`
- [x] Project analysis (source of truth, three passes)
- [x] Report structure defined (roadmap written, supervisor baseline plus tagged additions)
- [x] Content plan per chapter, including the decided screenshot inventory
- [x] Chapitre 1 — Présentation générale du projet
- [x] Chapitre 2 — Spécification des besoins
- [x] Chapitre 3 — Conception
- [x] Chapitre 4 — Réalisation
- [x] Introduction Générale / Conclusion Générale / Résumé (FR) & Abstract (EN)
- [x] Annexes A–D, Bibliographie (20 entrées), Nétographie (18 entrées), Liste des abréviations

## Phase 1 — Restoration (approved)
- [x] Restored Ch2/3/4 from `archives/v1_complet_156p_2026-08-23_1537/` as the working base.

## Phase 2 — Content/conception corrections (approved)
- [x] Unit 1 (Ch2) client unified; bounded clarification 3 tries; BF04; litige/souscription merged; BF35/BF36 appended.
- [x] Unit 2 (Ch3) memory = structured facts; short-term continuity; erasure = "état de remise à zéro"; no watermark/filigrane; no "souvenir".
- [x] Unit 3 (Ch4) supplier positioning + `fig-positionnement-fournisseurs`.
- [x] GPT-4o mini primary LLM, Gemini 2.5 Flash first fallback (consistent everywhere).
- [x] Unit 4 (Ch4 §4.5.2) observability chain (4 subsubsections).
- [x] Unit 5 (Ch4 §4.8) real measures / reconstituted budget / missing; steady-state latency total 1.6–2.1 / 1.8–2.5; "Ce qui manque encore" (scale/stress/schedule).
- [x] Unit 6 (Ch4 §4.3.5) Réparation contextuelle de la requête.
- [x] Unit 7 (Ch4 §4.7) Contrôle d'aptitude des agents + "Attachement des services" row.
- [x] A8 notifications REJECTED (out-of-scope supplier problem); no change.
- [x] Volumétrie F4/F5: 38 screens (21 console/17 portail); endpoints removed; 112/260 removed (table, figure, conclusion, §1.5).
- [x] Unit 9 (Ch4 §4.6 A3) ui-agents matrix + Unit 10 (Ch4 §4.5.2 A4) telemetry persona.
- [x] Unit 11 (Ch1 §1.5) Belgacem citation + bibliography entry.

## Final reading/lightening pass (approved)
- [x] Sorted/lightened heavy prose sentences in Ch1–Ch4 (lots 1–4), no content invented, no info lost.
- [x] Observability figure descriptions in §4.6 kept as original "Avant" (no 12 services, no container names).

## Phase 5 — diagrams (in progress, ONE at a time)
- [x] Figure 1/36: `fig-cycle-iteratif.svg` = EXACT unmodified copy of
      `uml diagrammes patterns/part must include in chapter 1/image of itrative cycle.svg`
      (sha256 dc3b517e…772cf7e, cmp identical, no redraw/adaptation).
- [x] Ch1 §1.5 text adjusted to support this exact figure (modèle évolutif, steps,
      30/55/80/100 %, client feedback from first increment).
- [x] Figure 2/36: `fig-deploiement.svg` = EXACT user-supplied SVG (only internal title block removed
      per explicit instruction); Ch4 tab:deploiement + §4.6 prose adapted to the architectural layers.
- [ ] Figure 3/36: `fig-cu-general.svg` = EXACT user-supplied SVG (no modification); placed FULL PAGE;
      Ch2 actors/tab:acteurs + §cas d'utilisation prose adapted to unified "Utilisateur back-office";
      Ch3 RBAC now explicits Administrateur/Superviseur/Conseiller. CONFIRMED (committed b779191). MSISDN renamed to 'Numéro d'appel' in the figure code (class diagram + MCD) on user request.
- [x] Figure 4/36: `fig-cu-doc.svg` = EXACT user-supplied SVG (1300×830, title "Obtenir une réponse fondée sur les connaissances", 5 includes + 2 extends + notes); Ch2 use-case section/table renamed and adapted to this figure (contexte de l'échange, base de connaissances). CONFIRMED.
- [x] Figure 5/36: `fig-cu-action.svg` = EXACT user-supplied SVG (1500×900, internal title "Réalisation d'une opération sécurisée", 4 includes + 3 extends + 2 notes + systèmes métier secondary actor); Ch2 use-case table/prose adapted (CIN, journal d'audit, résultats conditionnels). CONFIRMED.
- [x] Figure 6/36: `fig-cu-escalade.svg` = EXACT user-supplied SVG (1250×700, internal title "Gestion d'une demande d'assistance humaine", 2 actors Client+Conseiller, 7 UC, 2 external systems tickets+notification, 4 include + 2 extends + note exclusivity). Ch2 use-case section/table/prose renamed and adapted to this figure (ticket de suivi, notification). CONFIRMED.
- [x] Figure 7/36: `fig-seq-doc.svg` = EXACT user-supplied sequence SVG (1250×1080, 5 lifelines Client/Agent spécialisé/Base connaissances/Base vectorielle/Moteur d'inférence, fragments opt+loop+alt, 2 notes). Title renamed to 'Recherche et génération d'une réponse fondée sur les connaissances'; fig-cu-doc.svg internal title updated to match (title line only); Ch2 section/table/prose/seq adapted. CONFIRMED.
- [x] Figure 8/36: `fig-seq-action.svg` = EXACT user-supplied sequence SVG (1250×1660, 5 lifelines Client/Agent Spécialisé/Moteur de Politique/Système Métier/Journal d'Audit, fragments opt+opt/nested alt idempotence, 1 note). Ch2 case renamed to 'Réalisation d'une opération sécurisée'; seq intro updated (verdict persisté avant exécution, invariant "aucune opération sans verdict favorable"). CONFIRMED.
- [x] Figure 9/36: `fig-seq-escalade.svg` = EXACT user-supplied sequence SVG (1250×1210, 6 lifelines Client/Agent de Supervision/Service de Routage/Système de Tickets/Service de Notification/Conseiller, fragment alt un conseiller disponible vs aucun/échec, note dossier d'escalade). Ch2 case renamed BACK to 'Escalade vers un conseiller humain'; seq intro updated to the 6 participants + alt + ticket de rappel/notification. CONFIRMED. fig-cu-escalade.svg internal title updated to 'Escalade vers un conseiller humain' (title line only).
- [x] Figure 10/36: `fig-classes-domaine.svg` = EXACT user-supplied class diagram SVG (1700×1200; 5 aggregate roots Client/Conversation/DossierAssistance/Operation/RegleMetier, 4 value objects Msisdn/Montant/IdentifiantOperation/Creneau, 10 entities, 6 concrete subclasses, 11 enums, zones Template Method + Strategy + package Énumérations). Ch3 §Modèle du domaine prose adapted to this diagram (aggregates, value objects, enums). CONFIRMED (committed b779191). MSISDN renamed to 'Numéro d'appel' in the figure code (class diagram + MCD) on user request.
- [x] Figure 11/36: `fig-classes-agents.svg` = EXACT user-supplied class diagram SVG (1700×1200, title 'Diagramme de classes de la couche agents'). Content: orchestration (SessionVocale, RegistreDesAgents, GenerateurDInstructions, ReglesDeSession); interfaces/outils (PipelineVocal, Outil abstract, OutilMCP/OutilMetier, PortOutilsMCP, PortMetier + PortClient/Facturation/Abonnement/Assistance/Connaissances); état/données (ContexteDeSession, DefinitionDeDomaine, Transfert assoc. class); agents (AgentDeBase abstract + AgentAccueil/Facturation/Abonnement/Technique/Escalade, {disjoint, complet}); classes du domaine (Conversation, Client, DossierEscalade); énumérations (Domaine ACCUEIL/FACTURATION/ABONNEMENT/TECHNIQUE/ESCALADE, MotifTransfert). Ch3 §'Couche des agents conversationnels' rewritten to match; caption updated; §Décomposition uses agent d'escalade + domain Abonnement; §Construction table uses 'Outils disponibles'. Note: SVG has duplicate `y` attr lines 397&399 (provided as-is, untouched). INTEGRATED.
- [x] Figure 12/36: `fig-classes-politique.svg` = EXACT user-supplied class diagram SVG (1600×980, moteur de politique). Content: CoucheAgents::Outil, ContexteDeDecision, MoteurDePolitique, VerdictDePolitique, ModeleDuDomaine::EntreeAudit, ResultatDeRegle (objet valeur), RegleDePolitique (interface), CalculateurDeConfiance, 5 rules (EscaladeObligatoire=1, VerificationIdentite=2, Facturation=3, Abonnement=4, Technique=5), enums Verdict (AUTORISE/CONFIRMATION_REQUISE/REFUSE/ESCALADE) & FacteurDeRisque (5 valeurs). Ch3 §Moteur de décision déterministe rewritten to figure; garde-fou (Ch3) + besoin (Ch2) updated from 3→4 verdicts; Ch4 'moteur de règles'→'moteur de politique'. INTEGRATED.

## Removed by user decision
- [x] §3.1.3 Conception de la base de données (Ch3) removed entirely: Organisation en schémas (table tab:schemas), Modèle entités associations (fig-mcd / figure 13/36 incl. fig-mcd.tex) and Deux asymétries assumées. Ch3 conclusion adapted; no orphan refs remain.

- [x] Figure 14: `fig-seq-sensible.svg` (1780×1610) EXACT user SVG (8 participants, opt identité, opt confiance insuffisante, alt verdict favorable/refusé/intervention humaine). Ch3 §Déroulement d'une action sensible rewritten + figure placed (includegraphics PNG). NOTE: fig-seq-sensible.png not pushed yet — user must push it.
- [ ] Figure 15/... (`fig-act-ingestion`, Ch3) next.
- [x] Ch1 logo `logo-amsys-consulting.png` (1664×928, user-pushed `cd961bd`) integrated: placeholder → `\figureReport{figures/logo-amsys-consulting.png}{0.72\linewidth}{Logo de la société Amsys Consulting}{logo-amsys}`.
- [x] Ch1 Gantt `fig-gantt.svg` (915×480) EXACT user SVG saved verbatim; §Chronologie intro + `tab:phases` rewritten to match (4 groupes Cadrage/Réalisation/Intégration/Livraison, 13 tâches, périodes S1/S2, rapport avril→août).

- [x] PNG figures placed into report (main branch df7ee08): replaced figureReport/figureTikz/figureSVGPleine with explicit `figure` + fbox + includegraphics for all realized PNGs (Ch1 logo/gantt/cycle-iteratif; Ch2 cu-general/cu-doc/seq-doc/cu-action/seq-action/cu-escalade/seq-escalade; Ch3 classes-domaine/classes-agents/classes-politique/seq-tour; Ch4 deploiement). Sizes: landscape → width=\linewidth height=0.82\textheight; tall (seq-action, seq-tour, deploiement) height=0.88\textheight; cu-general full page `[p]` width=\textwidth height=0.92\textheight; logo 0.72x0.42 linewidth. Captions/labels preserved. NOTE filename `fig-cu-doc..png` (double dot) used as pushed.

## Open / Next
- [x] Figure 13/36: `fig-seq-tour.svg` = EXACT user-supplied sequence diagram SVG (1780×2010, 8 lifelines Client/VAD/STT/Agent Spécialisé/LLM/Capacité documentaire/TTS/Mémoire Contextuelle; 6 phases: capture+fin de tour, chargement contexte, loop intention (opt précision), alt documentaire/opérationnelle, par diffusion (loop segments + break barge-in) / journalisation asynchrone, opt clôture). Ch3 §Déroulement d'un tour de parole rewritten to match; figure placed after intro sentence, interpretation follows. INTEGRATED.
- [ ] Figures 2–36 (one at a time, per accepted protocol).
- [ ] Report-wide coherence check across figures/values after all diagrams.
- [ ] Final read-through and PDF build by the user (sandbox has no LaTeX compiler).

## Current Completion State
Phase 2 units 1–11 + final-reading lots done. Phase 5 underway: figure 1 done (exact supervisor SVG).

## Current chapter / task
`Phase 5 diagram 1 validated; next: diagram 2.`
