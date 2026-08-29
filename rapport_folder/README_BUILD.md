# Construction du rapport

## Compiler

Depuis Git Bash :

```bash
./build.sh
```

Depuis PowerShell :

```powershell
.\build.ps1
```

Les deux scripts font la même chose : trois passes `pdflatex`, vérification de l'intégrité du
PDF produit, puis rapport de construction. Ils renvoient un code de sortie non nul si quelque
chose a échoué, ce qui permet de les enchaîner dans un script ou une intégration continue.

Le PDF est produit dans `build/main.pdf`.

## Pourquoi trois passes

Le document utilise la table des matières, les mini-tables par chapitre, la liste des figures,
la liste des tableaux, des renvois croisés et des citations. Chacun de ces mécanismes écrit un
fichier auxiliaire lors d'une passe et le relit à la suivante. Une seule passe laisserait des
renvois non résolus, deux passes suffiraient dans la plupart des cas, trois garantissent la
convergence y compris lorsque la pagination se déplace.

## Le rapport de construction

Le script contrôle six points et les affiche :

1. Le PDF a-t-il été produit.
2. Le PDF est-il complet. Un PDF valide se termine par le marqueur `%%EOF`. Son absence
   signale une troncature, décrite plus bas.
3. Erreurs LaTeX.
4. Renvois et citations non résolus.
5. Débordements horizontaux, c'est-à-dire du contenu qui dépasse de la zone de texte.
6. Images introuvables.

Un état sain affiche `RÉSULTAT : CONSTRUCTION RÉUSSIE` avec des compteurs à zéro.

## Deux correctifs appliqués, et pourquoi

### 1. La classe ne compilait pas

`pfe-report.cls` chargeait le paquet `ctable` dans le bloc 5 et `tikz` dans le bloc 12. Les
versions actuelles de `ctable` refusent d'être chargées avant `tikz` et lèvent une erreur
fatale. Le modèle, tel qu'il a été livré, ne produisait donc aucun PDF.

Correctif appliqué, une ligne, dans le bloc 5 juste avant `ctable` :

```latex
\usepackage{tikz}   % Chargé ICI car ctable exige d'être chargé APRÈS tikz
```

Le `\usepackage{tikz}` du bloc 12 devient sans effet, LaTeX ignorant un chargement répété.
C'est la modification la plus petite qui résout le problème, et elle préserve entièrement
l'organisation du modèle.

### 2. MiKTeX produisait un PDF tronqué

Symptôme : la compilation semblait se dérouler normalement, aucune erreur LaTeX n'était
signalée, mais le PDF obtenu était inutilisable et se terminait au milieu d'un objet.

Cause : MiKTeX parcourt chaque entrée de la variable `PATH` en la traitant comme un répertoire.
Cette machine expose l'entrée `C:\Windows\System32\wbem\WMIC.exe`, qui désigne un FICHIER et non
un répertoire. MiKTeX interrompt alors son exécution au moment précis où il finalise le PDF,
c'est-à-dire après avoir affiché toutes les statistiques rassurantes et avant d'avoir écrit le
marqueur de fin.

C'est le pire profil de défaillance possible : silencieuse, tardive, et sans rapport apparent
avec le document.

Correctif appliqué : les deux scripts retirent de `PATH` toute entrée se terminant par `.exe`,
pour la durée de leur exécution uniquement. Le `PATH` de la machine n'est pas modifié.

C'est pourquoi il faut compiler par `build.sh` ou `build.ps1`, et non par un appel direct à
`pdflatex`. Un appel direct reproduira la troncature.

### Correctif permanent, facultatif

Le correctif ci-dessus règle le problème pour ce rapport. La cause, elle, affecte potentiellement
tout outil qui parcourt le `PATH`. Pour l'éliminer définitivement, retirer l'entrée fautive du
`PATH` utilisateur :

```powershell
[Environment]::SetEnvironmentVariable('PATH', (($env:PATH -split ';' | Where-Object { $_ -notmatch '\.exe\s*$' }) -join ';'), 'User')
```

Cette commande modifie la configuration de la machine. Elle n'est pas nécessaire pour compiler
le rapport, les scripts se protégeant déjà. À exécuter en connaissance de cause, après avoir
vérifié le contenu de `$env:PATH`.

## Fichiers protégés

`main.tex`, `Commands.tex` et `pfe-report.cls` portent la configuration et l'identité visuelle du
document. Ils ne se modifient que pour une raison structurelle vérifiée, et par la plus petite
modification possible. Les deux correctifs décrits plus haut relèvent de ce cas et sont commentés
dans les fichiers concernés.

## Organisation

```
rapport_folder/
├── main.tex                 orchestration du document
├── Commands.tex             auteur, titre, jury, commandes propres au rapport
├── pfe-report.cls           classe LaTeX, mise en page et identité visuelle
├── build.sh / build.ps1     construction et vérification
├── chapters/                contenu, un fichier par partie
├── figures/                 figures vectorielles, un fichier par figure
├── images/                  images bitmap et captures d'écran
└── build/                   sortie de compilation
```
