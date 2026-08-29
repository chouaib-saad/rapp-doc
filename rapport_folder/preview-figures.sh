#!/usr/bin/env bash
# Aperçu isolé de figures, une par page, pour contrôle visuel.
# Usage : ./preview-figures.sh fig-gantt fig-cycle-iteratif ...
#         ./preview-figures.sh --all
# Produit build/preview.pdf et build/prev-N.png

set -u
HERE="$(cd "$(dirname "$0")" && pwd)"
cd "$HERE" || exit 1
PATH="$(printf '%s' "$PATH" | tr ':' '\n' | grep -v -i '\.exe$' | paste -sd ':' -)"
export PATH
mkdir -p build

if [ "${1:-}" = "--all" ]; then
  FIGS=$(ls figures/fig-*.tex 2>/dev/null | sed 's|figures/||; s|\.tex$||')
else
  FIGS="$*"
fi

{
  echo '\documentclass[12pt,a4paper]{article}'
  echo '\usepackage[T1]{fontenc}\usepackage[utf8]{inputenc}\usepackage[french]{babel}'
  echo '\usepackage[margin=1cm,paperwidth=20cm,paperheight=27cm]{geometry}'
  echo '\usepackage[table]{xcolor}\usepackage{tikz}\usepackage{pgfplots}\pgfplotsset{compat=1.18}'
  echo '\usepackage{amsmath}\usepackage{float}\usepackage{graphicx}'
  echo '\input{figures/styles}'
  echo '\pagestyle{empty}'
  echo '\begin{document}'
  for f in $FIGS; do
    echo "\\begin{center}{\\bfseries\\ttfamily $f}\\end{center}"
    echo '\vspace{4mm}'
    echo '\begin{center}'
    echo "\\input{figures/$f}"
    echo '\end{center}'
    echo '\clearpage'
  done
  echo '\end{document}'
} > preview.tex

pdflatex --enable-installer -interaction=nonstopmode -output-directory=build preview.tex \
  > build/prev.out 2>&1

ERR=$(grep -c "^!" build/prev.out)
echo "Erreurs : $ERR"
[ "$ERR" -gt 0 ] && grep -A 4 "^!" build/prev.out | head -30

rm -f build/prev-*.png
pdftoppm -r 115 -png build/preview.pdf build/prev 2>/dev/null
ls build/prev-*.png 2>/dev/null
