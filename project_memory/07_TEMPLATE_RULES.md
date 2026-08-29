# LaTeX Template Rules

Rules discovered from the template in `latex_template_to_use/rapport_de_pfe_V2.zip`
and from actually compiling it in `rapport_folder/`.

## IMPORTANT: what that zip really is

It is NOT a neutral template. It is a previous draft (V2) of THIS report: it already names
Amsys Consulting, the telecom agentic platform, and uses a Scrum sprint-per-chapter layout.
Reuse its LaTeX architecture, syntax and visual identity. Do NOT reuse its chapter organisation
(superseded by the supervisor structure, decision D03) and do NOT reuse its prose.

## Build environment (verified working)

MiKTeX 25.12 on this machine: pdflatex, xelatex, latexmk available.
Engine: pdfLaTeX (the class explicitly disables the XeLaTeX fontspec path).
Packages install on demand; the `--enable-installer` flag is REQUIRED, otherwise a missing
package (auxhook was the first) aborts the run.

Build script: `rapport_folder/build.sh`. Usage `./build.sh main`.
It runs three pdflatex passes (needed for TOC, minitoc, list of figures, list of tables and
cross-references to converge) and then reports errors, undefined references, overfull boxes and
missing figures. Always read its BUILD REPORT block after a change.

## Protected files

  * `Commands.tex`
  * `main.tex`
  * `pfe-report.cls`

Modify only for a verified structural or compilation issue, smallest possible change.
`Commands.tex` legitimately needs the real author, title, jury and date values.

## Class fix applied (documented exception)

Problem: the class loaded `ctable` in BLOC 5 and `tikz` in BLOC 12, and current `ctable`
raises "You must load ctable after tikz", a fatal error. The template as shipped does not
compile in this environment.

Fix: one line added in BLOC 5, immediately before `\usepackage{ctable}`:
`\usepackage{tikz}  % Chargé ICI car ctable exige d'être chargé APRÈS tikz`
The later `\usepackage{tikz}` in BLOC 12 becomes a harmless no-op.
Verified: smoke test compiled to a 3-page PDF, 0 errors, 0 overfull boxes.

## Class facts (pfe-report.cls)

  * Base class `report`, options `12pt, oneside, a4paper`.
  * Encoding/language block MUST stay first and in order: fontenc T1, inputenc utf8,
    babel french.
  * Geometry: A4, 2.5 cm on all four margins.
  * Font: Times (`ptm`).
  * Colours defined: Gris1, Gris2, tableRow1, gray75, reportType (HTML 013873).
  * Caption style: bold label, small single-spaced font, small-caps bold text, ragged right.
  * Chapter titles: `titlesec` display form with a black `colorbox` holding the white chapter
    number, the word "Chapitre" above it, and a `titlerule` before the title text. A separate
    numberless variant exists for Introduction, Conclusion and similar.
  * Page styles: `MyStyle` (no header rule, footer "ISSAT Sousse" left and "Page N" right) is
    used on chapter opening pages and on the TOC/LOF/LOT pages; `plain` (adds a header rule with
    the lowercased chapter mark) is the running style.
  * `secnumdepth` 5, `tocdepth` 3.
  * Footnotes are continuous across the whole document (`counterwithout`).
  * `parskip` 1ex.
  * minitoc is loaded with the french option AFTER babel, which is required.
  * acronym is loaded for the abbreviations list.
  * appendix loaded with `titletoc, title`.

## main.tex orchestration pattern

  1. `\documentclass[12pt, oneside, a4paper]{pfe-report}`
  2. `\graphicspath{{images/}}`
  3. `\input{Commands}`, then amsmath, microtype, `\emergencystretch=3em`
  4. `\hypersetup{...}` for PDF metadata
  5. `\setcounter{minitocdepth}{2}` and `\setlength{\mtcindent}{0pt}`
  6. `\dominitoc` then `\faketableofcontents` (both exactly ONCE, right after `\begin{document}`)
  7. cover page via `\includepdf[fitpaper=true, pages=-]{...00-PageDeGarde.pdf}` then
     `\cleardoublepage`
  8. `\pagenumbering{roman}` and `\doublespacing` for the front matter
  9. front matter inputs, each followed by `\newpage`
 10. TOC / LOF / LOT, each wrapped in `\begin{spacing}{1}...\end{spacing}`, each preceded by
     `\addtocontents{toc|lof|lot}{\protect\thispagestyle{MyStyle}}`, each followed by
     `\addcontentsline{toc}{chapter}{...}` and `\adjustmtc`
 11. `\pagenumbering{arabic}` and `\doublespacing` before the chapters
 12. chapter inputs, then conclusion, then bibliography, then annexes

NOTE: the V2 tree used a folder named `chapitre/`. Our tree uses `chapters/` (it already existed
in `rapport_folder`). Paths in main.tex are adapted accordingly. This is a path change only.

## Chapter file pattern (copy this exactly)

```
\chapter{Titre du chapitre}

\begin{spacing}{1.2}
\minitoc
\thispagestyle{MyStyle}
\end{spacing}
\newpage

\section*{Introduction}
...
\section{Premiere section}
...
\section*{Conclusion}
```

Introduction and Conclusion inside a chapter are `\section*` (unnumbered), which matches the
supervisor outline where every chapter opens with an Introduction and closes with a Conclusion.

## Figures

Verified pattern used throughout V2, framed and forced in place:

```
\begin{figure}[H]%
    \center%
    \setlength{\fboxsep}{5pt}%
    \setlength{\fboxrule}{0.5pt}%
    \fbox{
    \includegraphics[width=9cm,height=3cm]{images/nom_du_fichier.png}%
    }
    \caption{Legende de la figure}%
    \label{fig:cle}
\end{figure}
```

  * `[H]` (from the `float` package) forces the figure exactly where it is written, which is how
    the template keeps a figure next to the prose that explains it.
  * The `\fbox` with fboxsep 5pt and fboxrule 0.5pt gives every figure the same thin frame.
    Keep it: it is part of the visual identity.
  * Explicit width AND height are given in cm. Widths observed: 9cm, 15cm, 16cm.
  * V2 omitted `\label` on several figures. WE MUST add a `\label` to every figure, because the
    supervisor requires each figure to be interpreted through its reference.

## Tables

Verified pattern:

```
\begin{table}[H]
\centering
\renewcommand{\arraystretch}{1.2}
\begin{tabular}{|p{1cm}|p{2.5cm}|p{8cm}|p{1.5cm}|}
\hline
\multicolumn{4}{|c|}{\textbf{Titre interne}} \\
\hline
\textbf{Col A} & \textbf{Col B} & \textbf{Col C} & \textbf{Col D} \\
\hline
... & ... & ... & ... \\
\hline
\end{tabular}
\caption{Legende du tableau}
\label{tab:cle}
\end{table}
```

  * Fixed-width `p{}` columns everywhere, never bare `l c r`. This is what stops wide French
    prose from overflowing the text block.
  * `\arraystretch{1.2}` for breathing room.
  * `\multicolumn{n}{|c|}{}` for a spanning internal title row.
  * A long table is split manually into several `table` environments, each repeating the header
    row with "(suite)" appended in the spanning title, separated by `\newpage`. The template does
    NOT use longtable. Follow this.
  * Available but unused so far: booktabs, tabularx, multirow, ctable.

## Cross-references (supervisor requirement)

Every figure and every table MUST be introduced by a reference in the prose before or as it
appears, in the supervisor's own style:
"Dans la figure 3.1, nous présentons l'architecture du logiciel qui est composée de ..."
Use `\label` + `\ref`. The class also loads `varioref` (french) if `\vref` is wanted.

## Citations and bibliography

The supervisor requires `\cite{ref}` at the point of use, not a bibliography dumped at the end.
V2 used `chapitre/08-Bibliographie.tex` as a manual file rather than a `.bib` + bibtex run.
TO BE CONFIRMED when that file is inspected in detail: whether it uses `thebibliography` with
`\bibitem` (in which case pdflatex alone suffices and build.sh needs no bibtex pass) or a real
`.bib`. Supervisor also asks for a separate "Netographie" section for URLs with consultation
dates.

## Lists

`enumitem` is loaded; `\setlist[enumerate]{itemsep=-0.35\baselineskip}` tightens enumerate.
Allowed markers per decision D05: disc, circle, square. Never a dash or hyphen as a marker.

## Pagination techniques present in the template

  * `\newpage` after each front-matter block and between split table parts.
  * `\cleardoublepage` after the cover.
  * `\adjustmtc` after any unnumbered chapter-level entry added to the TOC, to keep minitoc
    numbering aligned.
  * `nowidow` (all) suppresses widows and orphans automatically.
  * `needspace` is available to keep a heading with its following lines.
  * `\emergencystretch` plus microtype absorb bad line breaks in French text.

## Do Not Guess

If the template already contains an example for a LaTeX problem, inspect and reuse that pattern
instead of inventing a different one.

---

## Système de figures vectorielles (ajouté après la rédaction)

### Organisation

  * `figures/styles.tex` : styles communs, chargé une seule fois depuis `main.tex`.
  * `figures/fig-<cle>.tex` : une figure par fichier, contenant un unique `tikzpicture`.
  * `preview-figures.sh` : aperçu isolé, une figure par page, pour contrôle visuel.
    Usage `./preview-figures.sh fig-gantt fig-mcd` ou `./preview-figures.sh --all`.

### Insertion

`\figureTikz{légende}{clé}{fig-clé}` défini dans `Commands.tex`. La commande reprend le
cadre fin du modèle, place le `\label` DANS l'environnement figure, et réduit la figure
seulement si elle dépasse la largeur du bloc de texte (`adjustbox`, `max width`).

`\figurePlaceholder{légende}{clé}{description}` reste en place pour les visuels non encore
produits. La description indique précisément le visuel attendu.

### Conventions visuelles appliquées

  * Strictement monochrome : noir, blanc, quatre nuances de gris déclarées dans `styles.tex`.
  * Police sans empattement pour toutes les figures, ce qui les distingue du corps du texte.
    `helvet` est chargé dans `main.tex` car la fonte sans empattement par défaut n'existe
    qu'en version bitmap dans cette installation, ce que l'expansion de microtype refuse.
  * Notation UML respectée : triangle creux pour la généralisation et la réalisation,
    losange plein pour la composition, losange creux pour l'agrégation, trait discontinu
    pour les dépendances et les stéréotypes include et extend.
  * Les héritages multiples sont dessinés en arbre, avec un seul symbole, jamais en éventail
    convergent qui produit un amas noir.
  * Les noms de classes sont centrés au moyen de `\makebox[\linewidth][c]`. Un stéréotype et
    un nom doivent être séparés par une ligne vide, sinon les deux boîtes se suivent sur la
    même ligne et débordent du noeud.

### Pièges rencontrés, à ne pas réintroduire

  1. `\` dans un libellé de noeud exige `align=` sur le style. Les styles `etiq`, `etiqi` et
     `card` le portent désormais.
  2. Une macro d'échelle doit rendre une expression NUE, sans accolades englobantes, sinon
     toute arithmétique supplémentaire imbrique les groupes et casse l'analyse.
     Écrire `\def\Y#1{(#1-0.75)*36}` puis employer `({\Y{\s}})`.
  3. La bibliothèque de formes s'appelle `shapes.geometric`, pas `shapes.geometry`.
  4. `sed` et les documents ici présents dénaturent les antislashs sous ce shell. Pour
     modifier un fichier LaTeX, employer l'outil d'édition ou un script Python autonome,
     jamais `sed` avec des séquences `\r`, `\u`, `\t` ou `\n`.
  5. Vérifier chaque figure isolément AVANT de l'insérer : les croisements de traits et les
     débordements ne se voient pas dans le journal de compilation.

### Inventaire

32 diagrammes produits. 18 emplacements réservés subsistent : 17 captures d'interface et le
logo de la société, tous décrits précisément dans leur emplacement.

---

## Minitoc, table des matières et pagination : trois pannes et leur cause

Ces trois pannes venaient du même endroit, la configuration de minitoc dans `main.tex`.
Elles sont corrigées. Ne pas réintroduire les constructions fautives.

### 1. La table des matières s'imprimait vide

Cause : `main.tex` appelait `\dominitoc` PUIS `\faketableofcontents`, et plus loin
`\tableofcontents`. `\faketableofcontents` est destiné aux documents qui n'ont PAS de table
des matières : il prépare les fichiers .mtc sans rien composer, et neutralise la table
réelle demandée ensuite. Seul le titre s'imprimait.

Règle : avec une vraie table des matières, on écrit `\dominitoc` puis `\tableofcontents`.
`\faketableofcontents` ne doit jamais coexister avec `\tableofcontents`.

### 2. Les mini-sommaires étaient vides dans les chapitres 1 à 3

Cause : décalage entre les deux compteurs de minitoc.
  * Côté écriture, `\dominitoc` crée un fichier .mtc par entrée de niveau chapitre trouvée
    dans le .toc, y compris celles produites par `\addcontentsline` après un `\chapter*`.
  * Côté lecture, `\minitoc` lit le fichier désigné par un compteur qui n'avance que sur
    `\chapter` et sur `\adjustmtc`.

La dédicace, les remerciements, le résumé et l'abstract s'inscrivaient dans la table des
matières sans `\adjustmtc`. Le compteur de lecture accusait donc quatre unités de retard :
les chapitres lisaient des fichiers .mtc vides. La liste des abréviations portait par
ailleurs un `\adjustmtc` dans son fichier ET un dans `main.tex`, soit un de trop.

Règle : tout `\chapter*` qui s'inscrit dans la table des matières doit être suivi d'un
`\adjustmtc`, et d'un seul. Contrôle rapide après compilation : les fichiers
`build/main.mtcN` non vides doivent porter les numéros des chapitres réels. Ils sont
aujourd'hui 5, 6, 7 et 8 pour les chapitres 1 à 4.

### 3. Renvois décalés d'une page pour les listes de figures et de tableaux

Cause : `\addcontentsline{toc}{chapter}{\listfigurename}` était placé APRÈS
`\listoffigures`. Il enregistrait donc la page de fin de la liste et non celle où elle
commence. Corrigé en plaçant l'inscription avant la liste.

### 4. Pagination

État voulu et obtenu :
  * page de garde, dédicace, remerciements, résumé, abstract : aucun numéro
    (`\thispagestyle{empty}` dans chaque fichier) ;
  * table des matières, listes de figures et de tableaux, liste des abréviations :
    chiffres romains démarrant à i, grâce à `\clearpage` puis `\setcounter{page}{1}`
    juste avant la table des matières ;
  * introduction générale : `\pagenumbering{arabic}` placé juste avant son `\input`, ce qui
    en fait la page 1 ; les chapitres poursuivent la numérotation.

Ces quatre pièces liminaires ne figurent plus dans la table des matières : elles ne portent
aucun numéro, un renvoi vers elles n'aurait donc désigné aucune page atteignable, et elles
précèdent immédiatement la table des matières. Pour les y réintroduire, il faudrait leur
rendre une pagination visible.
