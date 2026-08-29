# Open Tasks

Liste active après la production des figures.

## Critical

- [ ] **Page de garde.** L'utilisateur la refait lui même, en français, et fournira le PDF.
      Le fichier attendu reste `chapters/00-PageDeGarde.pdf`, inclus tel quel par `main.tex`.
      Le titre du corps du rapport et des métadonnées PDF est :
      « Plateforme conversationnelle temps réel pour l'automatisation de la relation client
      dans les télécommunications ». La page de garde devrait porter le même titre, afin
      d'éviter la contradiction qui existait avec l'ancienne version anglaise.

- [ ] **Jury et date de soutenance.** `Commands.tex` porte encore `À PRÉCISER` pour
      `dateSoutenance` et `juryPresident`.

## High Priority

- [ ] **18 captures d'interface** pour la section 4.6. Chaque emplacement réservé nomme la
      route exacte et ce que la capture doit montrer. Elles sont reparties en 8 planches de deux captures et 2 captures pleine largeur. Liste décidée dans `04_CONTENT_PLAN.md`.
      Portail client : assistant, billing, requests, activity.
      Console : overview, calls, decisions, policies, knowledge, escalations, availability, audit.
      Systèmes intégrés : ticket créé dans GLPI, corpus indexé.
      Observabilité : les deux tableaux de bord Grafana, puis les cibles Prometheus.
      Exécution : topologie des conteneurs.

- [ ] **Logo de la société** pour la figure 1.1. Fichier à déposer dans `images/`, puis
      remplacer l'emplacement réservé par
      `\figureReport{images/logo-amsys.png}{9cm}{Logo de la société Amsys Consulting}{logo-amsys}`.

## Normal Priority

- [x] Tableaux de bord Grafana et Prometheus : réalisés et provisionnés par fichiers.
- [ ] Confirmer si les traces distribuées sont consultables dans une interface, ce qui
      permettrait une capture supplémentaire.

## Verification Needed

- [ ] Relire la section 1.3 : les affirmations sur PolyAI, Cognigy et Parloa ont été vérifiées
      contre la documentation publique le 23 août 2026, mais le positionnement de ces éditeurs
      évolue vite.
- [ ] Confirmer auprès de l'encadrante que les deux sections ajoutées au chapitre 3
      (3.3 Conception du système agentique, 3.4 Conception de la sécurité) sont acceptées.
      Elles sont marquées comme ajouts et justifiées dans `01_REPORT_ROADMAP.md`.

## Content Tasks

- [ ] Facultatif : campagne de mesure instrumentée remplaçant les valeurs de latence
      reconstituées de la section 4.8. L'instrumentation existe déjà. Si elle est menée, il
      faut mettre à jour la section 4.8 ET sa note méthodologique, qui annonce actuellement
      sans détour que les valeurs sont reconstituées.

## Final Review Tasks

- [ ] Relecture intégrale par l'utilisateur.
- [ ] Volume : 156 pages contre une cible annoncée de 90 à 120. Si le volume est jugé
      excessif, les annexes et la section 4.6 sont les parties les plus compressibles.

## Task Rule

Chaque tâche doit être actionnable et précise.
Retirer les tâches terminées ou les déplacer vers `02_PROGRESS.md`.
