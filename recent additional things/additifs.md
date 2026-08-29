# Recommandations pour la version finale du rapport

## Contexte

Le rapport a été rédigé alors que le dépôt était en **version 112 à 114**. Il est aujourd'hui en
**version 121** (dernier commit du 26 août 2026). Neuf incréments ont été livrés depuis, dont
plusieurs touchent directement des passages déjà écrits : la mémoire du client, la stratégie de
clarification, la télémétrie par persona, la réparation de requête avant recherche, et surtout
une **mesure réelle de latence** qui contredit le budget reconstitué de la section 4.3.

L'objectif de cette passe est triple : corriger ce qui est devenu faux, intégrer ce qui mérite de
l'être, et répondre honnêtement à la question posée sur la section 4.8.

Aucune modification n'a été appliquée. Ce document est une proposition.

---

## 1. La question de la section 4.8 : réponse honnête

**Recommandation : ne pas laisser en l'état, et ne pas basculer non plus vers une prétention de
campagne. Restructurer la section en deux étages nettement séparés.**

Le raisonnement, en trois constats vérifiés dans le code.

**Constat 1 — il existe désormais une mesure réelle, datée et instrumentée.**
`apps/agent-worker/src/agents/greeting.py` reproduit un relevé pris sur un appel réel du portail :

```
09:00:22.067  session Triage ouverte
09:00:25.642  LLM   ttft = 3,48 s   prompt = 2536 jetons   cached = 0
09:00:26.287  TTS   ttfb = 0,25 s
              -> premier son entendu ~4,2 s après l'ouverture de session
```

**Constat 2 — cette mesure contredit le budget reconstitué du rapport.**
Le tableau 4.6 annonce un délai avant premier jeton de **400 à 700 ms**. Le relevé réel donne
**1,12 s** sur un tour ultérieur avec un prompt non mis en cache de 3909 jetons, et **3,48 s** sur
le tout premier appel. Un jury qui lit le dépôt trouvera l'écart. Laisser la section en l'état
serait le seul choix réellement risqué.

**Constat 3 — la cause est identifiée et elle est intéressante.**
Le code démontre que les 3,48 s ne sont **ni** du prefill **ni** un défaut de cache : le contre
exemple des 3909 jetons non mis en cache revenu en 1,12 s l'établit. C'est la première requête
HTTPS du processus qui paie le DNS, le TCP et le TLS. D'où un correctif en deux moitiés : une
salutation à texte fixe, et un amorçage de connexion en arrière plan pendant qu'elle est prononcée.

**Ce que la section devrait devenir :**

- **4.8.1 Mesures réelles.** La calibration de la recherche documentaire (déjà présente), le relevé
  de la salutation ci dessus, et la liste de ce que les tableaux de bord relèvent désormais en
  continu (TTFA et TTFT par langue, verdicts par règle, bascules de fournisseur).
- **4.8.2 Budget reconstitué, recalibré.** Le tableau reste, mais la ligne du délai avant premier
  jeton est réalignée sur la mesure, avec la distinction entre premier appel et régime établi.
- **4.8.3 Ce qui manque encore.** Une campagne sur une période représentative. La formulation
  actuelle est conservée pour cette partie : l'instrument existe, la campagne n'a pas eu lieu.

Le gain n'est pas seulement l'exactitude. Le récit « mesure → analyse → décision → résultat » est
déjà le motif du chapitre 4 ; ce relevé en est le meilleur exemple du rapport, parce que la mesure
a directement changé une décision de conception.

---

## 2. Les deux fonctionnalités demandées

### Mémoire de l'agent et contrôle par le client

Le mécanisme réel, dans `services/context-service/src/context_service/caller_memory.py` :
la mémoire est un **filigrane** (`customers.memory_cleared_at`), pas une suppression. Le client
efface, le résumé repart vide à l'appel suivant, et les transcriptions, la chaîne d'audit et le
calendrier de rétention restent intacts.

**C'est la meilleure addition possible au rapport**, parce qu'elle résout une tension que le
rapport a lui même posée : comment un effacement demandé par le client peut coexister avec un
registre infalsifiable. La réponse est le filigrane.

Emplacement recommandé : **chapitre 3, section 3.3.3**, en quatrième règle de la mémoire longue.
Une phrase de rappel en 3.4 (traçabilité). Deux à trois phrases, pas davantage.

À corriger dans le même mouvement : le rapport écrit que la mémoire longue est « présentée à
l'agent sous forme d'une **synthèse** ». Le code dit exactement l'inverse, et explique pourquoi :
une synthèse est une affirmation sur ce qui a été dit, produite par le même type de modèle qui la
relira ensuite comme un fait acquis ; une fois subtilement fausse, elle le reste à chaque appel.
La mémoire est faite de **faits structurés** re dérivés à chaque lecture.

### Comportement des agents et visualisations

Deux surfaces nouvelles, dans `Frontend/admin_dashboard/src/components/nexus/` :
`agent-tool-matrix.tsx` et `agent-trend-chart.tsx`, adossées à la migration 0027
(`agent_tool_invocations`).

La matrice mérite un paragraphe à elle seule, pour la raison que son propre code donne : les faits
intéressants sont des **comparaisons le long d'une ligne** (l'outil de ticketing est appelé par
toutes les personas, `top_up` n'appartient qu'à la gestion de compte), et cinq diagrammes séparés
détruiraient précisément cela. L'intensité y est une opacité sur une seule encre, ce qui rejoint la
règle de monochromie du rapport.

Emplacement recommandé : **chapitre 4, section 4.6.2**, une planche de deux captures, plus un
paragraphe court. Et une mention de la télémétrie par persona en 4.5.2, puisqu'il s'agit d'une
capacité de mesure.

---

## 3. Tableau des recommandations

Type : **FIX** = contredit le code aujourd'hui · **UPDATE** = chiffre à rafraîchir ·
**ADD** = matière nouvelle · **DELETE** = à retirer

| Réf | Type | Sujet | Où | Ce qu'il faut faire | Priorité |
|---|---|---|---|---|---|
| F1 | FIX | Mémoire longue décrite comme une « synthèse » | Ch.3 §3.3.3 | Remplacer par « faits structurés, délibérément pas une synthèse rédigée », avec la raison donnée par le code | **Haute** |
| F2 | FIX | Clarification annoncée comme « une seule question » | Ch.2 §2.2.1 + figure carte des besoins | Devenue une échelle de trois tentatives : au 3ᵉ essai la stratégie change (question fermée ou référence épelée), l'humain est proposé ensuite. Le principe « trois échecs signifient que la question a échoué, pas le client » est excellent | **Haute** |
| F3 | FIX | Budget TTFT annoncé 400 à 700 ms | Ch.4 §4.3.5, tableau 4.6, figure budget de latence | Recalibrer sur la mesure réelle : ~1,1 s en régime établi, ~3,5 s au premier appel (connexion à froid) | **Haute** |
| F4 | UPDATE | Nombre d'écrans : 35 | Figure volumétrie + conclusion générale | 38 aujourd'hui (21 console, 17 portail) | Haute |
| F5 | UPDATE | Points d'accès : 73 | Figure volumétrie + conclusion générale | 76 aujourd'hui | Haute |
| F6 | UPDATE | Incréments : 112 | Figure volumétrie, §1.5.2, conclusion, résumé FR et EN | 121 aujourd'hui | Haute |
| U1 | UPDATE | Statut des mesures | Ch.4 §4.8 | Restructurer en trois temps : mesures réelles, budget recalibré, ce qui manque (voir section 1 ci dessus) | **Haute** |
| A1 | ADD | Filigrane de mémoire client | Ch.3 §3.3.3 (4ᵉ règle) + §3.4 (une phrase) | L'effacement demandé par le client est un filigrane, pas une suppression : c'est ce qui le rend compatible avec le registre infalsifiable. Distinguer mémoire de conversation et état de compte vivant, que la remise à zéro ne touche pas | **Haute** |
| A2 | ADD | Capture de l'écran préférences du portail | Ch.4 §4.6.1 | Ajouter à une planche existante : le réglage de mémorisation et le bouton d'effacement | Moyenne |
| A3 | ADD | Onglet agents, matrice agent/outil, courbe de tendance | Ch.4 §4.6.2 | Une planche de deux captures et un paragraphe sur ce que la matrice répond et pourquoi une matrice plutôt que cinq diagrammes | **Haute** |
| A4 | ADD | Télémétrie des appels d'outils par persona | Ch.4 §4.5.2 | Deux phrases : la console pouvait dire combien d'appels une persona avait faits, rien sur ce qu'elle avait fait. Capté là où l'information existe, au moment où la session tient encore l'agent qui parle | Moyenne |
| A5 | ADD | Contrôle d'aptitude de l'agent | Ch.4 §4.7 + figure des familles de vérifications | Nouvelle famille : une persona peut être cohérente avec elle même et tenir un outil dont le service est tombé ; le client entend alors une promesse puis un échec. Le contrôle part des outils de chaque persona vers les services | **Haute** |
| A6 | ADD | Réparation de la requête avant recherche | Ch.4 §4.3.6 | Le texte qui atteint la recherche n'est pas ce que le client a dit, mais ce que le transcripteur a entendu : « 4G » revient en « quatre g », « roaming » en « rooming ». Un seul mot abîmé supprime l'ancre dont dépendent l'encodage dense et le lexical | **Haute** |
| A7 | ADD | La salutation fixe et l'amorçage de connexion | Ch.4 §4.9 (7ᵉ problème) | Le récit complet avec les chiffres réels : 4,2 s de silence à l'ouverture, cause écartée (ni prefill ni cache, preuve à l'appui), correctif en deux moitiés | **Haute** |
| A8 | ADD | Réconciliation des notifications | Ch.4 §4.9 (8ᵉ problème) | Un 201 « mis en file » est une acceptation, pas une livraison. Le 23 août, un message consigné comme délivré avait en réalité échoué chez le fournisseur. Le journal enregistrait l'intention, pas le résultat | Moyenne |
| A9 | ADD | Litiges de facturation | Ch.2 §2.2 + figure carte des besoins | Capacité métier absente du rapport : ouvrir un litige retire la facture du règlement, la clôture restaure son statut antérieur | Moyenne |
| A10 | ADD | Souscription en libre service | Ch.2 §2.1 et §2.2 | Une personne sans ligne peut devenir cliente depuis le portail. Le rapport suppose partout un abonné existant | Moyenne |
| A11 | ADD | Politique de délais des passerelles | Ch.4 §4.3.6 | Vérifier que la formulation actuelle (5 s et 9 s) correspond encore à la politique consolidée en version 116 | Basse |
| D1 | DELETE | Aucune suppression nécessaire | — | Rien dans le rapport n'est devenu faux au point de devoir disparaître ; tout se corrige sur place | — |

---

## 4. Contrainte de volume — décision retenue

**Net neutre.** Le rapport reste autour de 130 pages : chaque addition est compensée.

- Les entrées **Haute** priorité valent leur place : ce sont des corrections, ou de la matière qui
  raconte une mesure ayant changé une décision.
- Les entrées **Moyenne** (A2, A4, A8, A9, A10) sont traitées en deux ou trois phrases chacune,
  intégrées à un paragraphe existant plutôt qu'en nouvelle sous-section.
- Compensations à opérer, dans cet ordre de préférence :
  1. **Annexe B** : retirer les formules que le corps du rapport n'exploite pas (MER, WIL, PESQ,
     STOI ne sont jamais reprises dans une analyse). Gain estimé : 2 pages.
  2. **Section 4.3.2** (établissement de session et transport) : la plus dense pour ce qu'elle
     apporte, resserrable d'un tiers. Gain estimé : 1 page.
  3. **Section 4.6** : regrouper deux captures pleine largeur restantes en une planche.
     Gain estimé : 1 page.
  4. **Annexe A** : les paires de notions non citées dans le corps (démarrage à froid, index vide).
     Gain estimé : 1 page.

Contrôle final : le nombre de pages après application doit rester dans l'intervalle 128 à 134.

---

## 5. Mémoire du projet à rafraîchir

`project_memory/08_PROJECT_FACTS.md` s'arrête à la version 114. À compléter avec les versions 115
à 121 : mémoire du client et filigrane, échelle de clarification, contrôle d'aptitude, réparation
de requête, réconciliation des notifications, télémétrie par persona, souscription en libre
service, litiges. Et le relevé de latence réel, qui est désormais le fait le plus important du
dossier de mesures.

`02_PROGRESS.md` et `06_OPEN_TASKS.md` mentionnent encore 156 puis 123 pages et un décompte de
captures antérieur ; à réaligner sur 132 pages et 18 captures.

---

## 6. Ordre d'exécution proposé

Trois passes, chacune close par une compilation vérifiée. Aucun contenu n'est réécrit au hasard :
chaque intervention est ciblée sur un passage nommé.

**Passe 1 — corrections de véracité** (F1, F2, F3, F4, F5, F6)
Ce sont les points où le rapport contredit le dépôt. À traiter en premier, indépendamment du reste.

**Passe 2 — section 4.8 et récits de mesure** (U1, A7, A6, A5)
La restructuration de 4.8 en trois temps, le récit de la salutation en 4.9, la réparation de
requête en 4.3.6 et le contrôle d'aptitude en 4.7. Ces quatre éléments se répondent et doivent
être écrits d'un seul tenant pour ne pas se répéter.

**Passe 3 — fonctionnalités demandées et compensations** (A1, A2, A3, A4, puis A8 à A11)
Le filigrane de mémoire, l'onglet agents et sa matrice, puis les additions courtes. Les coupes de
compensation sont appliquées dans la même passe, de manière à mesurer le volume net une seule fois.

**Passe 4 — mémoire du projet** (section 5 ci dessus), puis relecture ciblée.

## 7. Vérification proposée après application

1. `./build.sh` doit rester à **0 erreur, 0 renvoi non résolu, 0 débordement**.
2. Contrôle des chiffres : aucune occurrence résiduelle de 112 incréments, 73 points d'accès,
   35 écrans, 22 conteneurs.
3. Contrôle de cohérence figure/texte : la figure de volumétrie et la conclusion générale doivent
   annoncer les mêmes valeurs.
4. Relecture ciblée de 4.3.5, 4.8 et 4.9 d'un seul tenant, pour vérifier que le budget recalibré,
   les mesures réelles et le récit de la salutation racontent la même histoire sans se répéter.
