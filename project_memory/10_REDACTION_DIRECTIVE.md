# DIRECTIVE DE RÉDACTION — DESCRIPTIONS DES DIAGRAMMES UML

## Rôle
Rédiger les descriptions de diagrammes (séquence, cas d'utilisation, activités,
états-transitions, navigation, architecture, composants) d'un PFE en français,
dans un style **académique, sobre, court, clair, humain** — proche d'un vrai
rapport d'ingénieur, jamais d'un texte généré par IA.

## Objectif
Le texte **accompagne le diagramme, il ne le remplace pas**.

> Règle fondamentale : le lecteur doit comprendre rapidement l'objectif et le
> fonctionnement général du diagramme sans lire un long paragraphe.

## 1. Structure obligatoire
1. **Avant la figure** : introduction courte (1–2 phrases) : ce que représente le diagramme.
2. **La figure** : légende simple.
3. **Après la figure** : un seul paragraphe (3–6 phrases, max 7 si complexe) :
   déclencheur → étapes principales → résultat. Jamais de compte-rendu ligne par ligne.
   Si complexe, préférer **2 paragraphes courts** à un long.

## 2. Ne pas sur-décrire
Ne jamais décrire systématiquement : tous les participants, tous les messages,
toutes les méthodes, chaque condition/branche alt/opt/loop, chaque retour,
chaque vérification interne, chaque écriture en base, chaque détail du diagramme.

Bonne approche (résumé) :
> « La figure X illustre le traitement d'une action sensible. Après confirmation
> de la demande et vérification du contexte client, le système évalue l'action
> selon les règles définies. Selon le résultat, l'opération est exécutée, refusée
> ou transférée à un conseiller. »

## 3. Longueur et priorités
- 1 petit paragraphe avant + 1 petit paragraphe après dans la majorité des cas.
- 2 à 5 phrases en général, 6–7 en exception pour processus complexe.
- Priorités : pertinence > exhaustivité · clarté > détail · fluidité > complexité
  · information utile > volume.

## 4. Consignes par type
- **Séquence** : qui déclenche, grandes étapes, résultat final. Ne pas décrire chaque message.
  Pour les branches, ne citer que les importantes (ex. acceptée/refusée/transmise à un conseiller).
- **Activités** : flux global avec progression naturelle (commence... ensuite... enfin), sans lister chaque activité.
- **États-transitions** : cycle de vie de l'entité (création → clôture), sans détailler chaque transition sauf essentielle.
- **Cas d'utilisation** : acteur concerné, fonctionnalité représentée, principales actions, sans paragraphe par cas.
- **Architecture / composants** : composants principaux, rôle général, relations essentielles, sans détailler chaque classe/API/endpoint.

## 5. Style
Formulations naturelles : « La figure X illustre... », « Le diagramme X représente... »,
« Ce diagramme montre... », « Le processus commence par... », « Ensuite, le système... », « Enfin... ».
Phrases courtes, directes, une idée par phrase. Éviter subordonnées multiples et parenthèses imbriquées.

## 6. Interdictions strictes ("AI slop")
Tournures interdites : « Il convient de noter que », « Il est important de souligner que »,
« Cette étape conditionnelle sépare... », « Cette persistance intervient avant... »,
« structurellement impossible », « Cette ramification... », « L'ordre de ces étapes ne souffre aucune exception »,
« Cette architecture hautement sophistiquée », « Cette approche permet de garantir de manière optimale »,
« Dans une perspective globale », « De manière robuste et efficace », « Cette orchestration complexe »,
« Ainsi, ce diagramme permet de mieux comprendre... », « Cette représentation met en évidence l'efficacité du système... ».

Adjectifs à éviter sauf justifiés : complexe, robuste, sophistiqué, intelligent, optimal,
hautement sécurisé, puissant, innovant.
Mots de remplissage à éviter : « notamment », « en effet », « ainsi », « de ce fait »,
« il est important de souligner ».

Autres : pas de symboles décoratifs, pas d'emojis, pas de tirets cadratins décoratifs,
pas de gras abusif, pas de listes à puces sauf nécessaire, jamais de conclusion artificielle,
jamais reformuler la même idée deux fois, jamais répéter une info évidente dans le diagramme,
jamais inventer règle/vérification/service/contrainte/mécanisme absent.

## 7. Cohérence sur tout le rapport
Appliquer uniformément à tous les diagrammes (déjà rédigés, en cours, à venir).
Varier légèrement les formulations pour éviter l'effet texte automatique répété.

## 8. Exemple de référence (niveau attendu)
> Le diagramme 3.10 montre le processus d'analyse et de résolution des anomalies.
> L'administrateur choisit le composant à contrôler. Le module intelligent analyse
> les statistiques calculées à partir des logs en temps réel et, en cas d'anomalie
> détectée, cherche une solution parmi les règles prédéfinies. Il notifie ensuite
> l'investigateur, qui vérifie et applique la solution proposée.

## 9. Contrôle final
1. Court et facile à comprendre ?
2. Explique sans recopier ?
3. Les 2–3 infos indispensables présentes ?
4. Détails secondaires supprimés ?
5. Répétitions / formulations IA ?
6. Ressemble à un rapport humain ?
7. Peut-on couper de moitié sans perdre d'info utile ? → couper.

## RÈGLE ABSOLUE
> Mieux vaut 4 phrases simples et pertinentes qu'un paragraphe de 15 phrases qui
> décrit chaque élément du diagramme.
Toujours : simplicité → clarté → pertinence → concision.
Jamais : longueur → exhaustivité artificielle → vocabulaire compliqué → répétition → détails inutiles.
