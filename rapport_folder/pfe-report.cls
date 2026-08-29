% ============================================================
% pfe-report.cls — Classe LaTeX pour rapport de PFE / Stage
% ISSAT Sousse — Version nettoyée et corrigée
% Auteur original : Template ISSAT | Nettoyage : Chouaib Saad
% Date : 2025
% ============================================================

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{pfe-report}[2025/08/08 Classe rapport PFE ISSAT Sousse]

% ── Silencer les warnings non critiques ─────────────────────
\RequirePackage{silence}
\WarningsOff*

% ── Classe de base ──────────────────────────────────────────
\LoadClassWithOptions{report}

% ============================================================
% BLOC 1 — ENCODAGE ET LANGUE (OBLIGATOIREMENT EN PREMIER)
% Ces trois packages doivent toujours être chargés dans cet
% ordre précis et avant tous les autres packages.
% ============================================================
\usepackage[T1]{fontenc}         % Encodage de sortie (accents corrects)
\usepackage[utf8]{inputenc}      % Encodage d'entrée UTF-8 (é è à ù...)
\usepackage[french]{babel}       % Typographie française

% ============================================================
% BLOC 2 — MISE EN PAGE
% ============================================================
\usepackage[
  a4paper,
  left=2.5cm,
  right=2.5cm,
  top=2.5cm,
  bottom=2.5cm
]{geometry}

\usepackage{setspace}            % Interlignage (doublespacing, etc.)
\usepackage[all]{nowidow}        % Suppression des lignes veuves/orphelines
\usepackage[bottom]{footmisc}    % Notes de bas de page toujours en bas

% Suppression des coupures de mots
\usepackage{microtype}

\tolerance=1500
\emergencystretch=2em
\hyphenpenalty=500
\exhyphenpenalty=500

% ============================================================
% BLOC 3 — POLICE ET TYPOGRAPHIE
% ============================================================
\def\defaultFont{ptm}                                          % Police Times Roman
\renewcommand*{\familydefault}{\defaultFont}

% NOTE : \setmainfont (XeLaTeX) est désactivé car on utilise pdfLaTeX.
% Si tu passes à XeLaTeX, active fontspec et supprime inputenc/fontenc.
%\usepackage[no-math]{fontspec}
%\setmainfont{Times New Roman}

% ============================================================
% BLOC 4 — COULEURS
% ============================================================
\usepackage[table]{xcolor}       % Couleurs (avec support tableaux)
                                 % IMPORTANT : une seule déclaration avec [table]

\definecolor{Gris1}{RGB}{116,134,170}
\definecolor{Gris2}{RGB}{249,249,249}
\definecolor{tableRow1}{RGB}{210,234,241}
\definecolor{gray75}{gray}{0.75}
\definecolor{reportType}{HTML}{013873}

% ============================================================
% BLOC 5 — FIGURES, GRAPHIQUES ET TABLEAUX
% ============================================================
\usepackage{graphicx}            % Inclusion d'images
\usepackage{caption}             % Personnalisation des légendes
\usepackage{subcaption}          % Sous-figures
\usepackage{wrapfig}             % Figures avec texte enveloppant
\usepackage[export]{adjustbox}   % Options avancées pour les boîtes d'images
\usepackage{float}               % Placement forcé des flottants [H]

\usepackage{tabularx}            % Tableaux à largeur variable
\usepackage{multirow}            % Fusion de lignes dans les tableaux
\usepackage{array,ragged2e}      % Améliorations des tableaux
\usepackage{tikz}                % Chargé ICI car ctable exige d'être chargé APRÈS tikz
\usepackage{ctable}              % Tableaux avec filets professionnels
\usepackage{booktabs}            % Filets de tableaux de qualité (toprule etc.)

% Configuration des légendes
\captionsetup{
  labelfont=bf,
  font={singlespacing, small},
  textfont={sc, bf},
  justification=RaggedRight
}

% ============================================================
% BLOC 6 — TITRES ET SECTIONS
% ============================================================
\usepackage[explicit]{titlesec}  % Personnalisation des titres

% Formatage des titres de chapitres (numérotés)
\newlength\BoxWd
\setlength\BoxWd{10mm}
\newlength\Aux

\titleformat{\chapter}[display]{%
    \fontsize{26}{6}\bfseries\selectfont%
    \settowidth\Aux{\textcolor{white}{\Huge\thechapter}}%
    \ifnum\Aux>\BoxWd \setlength\BoxWd{\Aux} \else\fi%
  }{%
    {\hspace*{-1.5mm}\normalfont\fontsize{14}{6}\selectfont{Chapitre}}\\%
    \colorbox{black}{%
      \parbox[c][20mm][t]{\BoxWd}{%
        \vspace{2.5mm}\centering\textcolor{white}{\Huge\thechapter}%
      }%
    }%
  }{-10mm}{%
    \vspace{-5mm}\hspace*{15mm}\titlerule\\\\\hspace*{15mm}#1%
  }

% Formatage des titres de chapitres (non numérotés — Introduction, Conclusion...)
\titleformat{name=\chapter,numberless}[display]{%
    \fontsize{26}{6}\bfseries\selectfont%
    \settowidth\Aux{\textcolor{white}{\Huge\thechapter}}%
    \ifnum\Aux>\BoxWd \setlength\BoxWd{\Aux} \else\fi%
  }{%
    {\hspace*{-1.5mm}\normalfont\fontsize{14}{6}\selectfont{~}}\\%
    \colorbox{black}{%
      \parbox[c][20mm][t]{\BoxWd}{%
        \vspace{2.5mm}\centering\textcolor{white}{~}%
      }%
    }%
  }{-10mm}{%
    \vspace{-5mm}\hspace*{15mm}\titlerule\\\\\hspace*{15mm}#1%
  }

% Espacement des titres de chapitres
\titlespacing*{\chapter}{0pt}{0pt}{50pt}

% Formatage des sections
\titleformat{\section}[block]%
  {\Large\bfseries}{\thesection}{10pt}{\Large\bfseries{#1}}

% Formatage des paragraphes
\titleformat{\paragraph}[block]%
  {\normalfont\normalsize\bfseries}{\theparagraph}{1em}{#1}

% ============================================================
% BLOC 7 — EN-TÊTES ET PIEDS DE PAGE
% ============================================================
\usepackage{fancyhdr}

% Style personnalisé pour les pages de titre de chapitre
\fancypagestyle{MyStyle}{
  \fancyhf{}
  \renewcommand{\headrulewidth}{0pt}
  \renewcommand{\footrulewidth}{0.5pt}
  \fancyfoot[R]{\fontsize{12}{12}\selectfont Page~\thepage}
  \fancyfoot[L]{\fontsize{12}{12}\selectfont ISSAT Sousse}
}

% Style standard pour les pages courantes
\fancypagestyle{plain}{
  \fancyhf{}
  \renewcommand{\headrulewidth}{0.5pt}
  \renewcommand{\footrulewidth}{0.5pt}
  \fancyhead[L]{\fontsize{12}{12}\selectfont\textsc{\MakeLowercase{\leftmark}}}
  \fancyfoot[R]{\fontsize{12}{12}\selectfont Page~\thepage}
  \fancyfoot[L]{\fontsize{12}{12}\selectfont ISSAT Sousse}
}

\renewcommand{\chaptermark}[1]{\markboth{\MakeUppercase{#1}}{}}
\pagestyle{plain}

% ============================================================
% BLOC 8 — LIENS, PDF ET RÉFÉRENCES
% ============================================================
\usepackage[hidelinks]{hyperref} % Liens cliquables sans bordures
\usepackage[french]{varioref}    % Références intelligentes (vref)
\usepackage{pdfpages}            % Inclusion de pages PDF externes

% ============================================================
% BLOC 9 — LISTES ET ÉNUMÉRATIONS
% ============================================================
\usepackage{enumitem}            % Personnalisation des listes

\setlist[enumerate]{itemsep=-0.35\baselineskip}

% ============================================================
% BLOC 10 — TABLE DES MATIÈRES ET MINI-TOC
% ============================================================
\usepackage[french]{minitoc}     % Mini tables des matières par chapitre
                                 % Doit être chargé APRÈS babel

% ============================================================
% BLOC 11 — ABRÉVIATIONS
% ============================================================
\usepackage{acronym}             % Gestion des abréviations

% ============================================================
% BLOC 12 — DIVERS ET UTILITAIRES
% ============================================================
\usepackage{environ}             % Définition de nouveaux environnements
\usepackage{verse}               % Environnement pour les citations en vers
\usepackage{needspace}           % Évite les coupures de page indésirables
\usepackage{chngcntr}            % Modification des compteurs LaTeX
\usepackage[skins]{tcolorbox}    % Boîtes colorées stylisées
\usepackage{tikz}                % Dessins vectoriels
\usepackage{seqsplit}            % Découpage de longues séquences
\usepackage{color}               % Couleurs de base (complément à xcolor)
\usepackage[titletoc,title]{appendix} % Gestion des annexes

% ============================================================
% BLOC 13 — COMPTEURS ET NUMÉROTATION
% ============================================================
\setcounter{secnumdepth}{5}      % Profondeur de numérotation des sections
\setcounter{tocdepth}{3}         % Profondeur dans la table des matières

\renewcommand\theparagraph{\alph{paragraph})}
\renewcommand\thesubparagraph{\roman{subparagraph}.}

% Notes de bas de page continues sur tout le document
\counterwithout{footnote}{chapter}

% ============================================================
% BLOC 14 — ESPACEMENT DES PARAGRAPHES
% ============================================================
\setlength{\parskip}{1ex}
\setlength{\fboxsep}{0mm}
\setlength{\fboxrule}{1pt}

% ============================================================
% BLOC 15 — COMMANDES PERSONNALISÉES
% ============================================================

% Commande utilitaire (ignore le premier argument)
\newcommand{\ignore}[2]{\hspace{0mm}#2}

% Filet horizontal paramétrable
\newcommand{\HRule}[1][\linewidth]{%
  \rule{#1}{0.5mm}%
}

% Mise en évidence italique
\newcommand{\highlight}[1]{\textit{#1}}

% Inclusion d'une photo carrée (ex: page de garde)
\newcommand{\putPhoto}[1]{%
  \includegraphics[width=35mm, height=35mm]{#1}%
}

% Lien URL sans formatage spécial
\renewcommand\UrlFont{\ignore{}{}}

% ============================================================
% BLOC 16 — ENVIRONNEMENTS PERSONNALISÉS
% ============================================================
\NewEnviron{pfe-enetcom}{%
  \begingroup%
  \BODY%
  \endgroup%
}