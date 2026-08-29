#!/usr/bin/env bash
# ============================================================
# Construction du rapport.
#   Usage : ./build.sh [nom_du_document]   (défaut : main)
#
# Le script exécute trois passes pdfLaTeX afin que la table des
# matières, les mini-tables, les listes de figures et de tableaux
# et l'ensemble des renvois convergent. Il VÉRIFIE ensuite que le
# PDF produit est complet, puis publie un rapport de construction.
#
# Code de sortie 0 uniquement si le PDF est produit, complet et
# sans erreur LaTeX.
# ============================================================

set -u
JOB="${1:-main}"
HERE="$(cd "$(dirname "$0")" && pwd)"
cd "$HERE" || exit 1
mkdir -p build

# ── Correctif d'environnement (voir README_BUILD.md) ────────
# MiKTeX parcourt chaque entrée de PATH en la traitant comme un
# répertoire. Cette machine expose C:\Windows\System32\wbem\WMIC.exe,
# qui est un FICHIER. MiKTeX interrompt alors l'exécution au moment
# de finaliser le PDF, ce qui produit un fichier TRONQUÉ sans message
# d'erreur LaTeX. On retire ici ces entrées, sans modifier le PATH
# de la machine.
PATH="$(printf '%s' "$PATH" | tr ':' '\n' | grep -v -i '\.exe$' | paste -sd ':' -)"
export PATH

PASSES=3
for i in $(seq 1 $PASSES); do
  printf '=== passe %d/%d ===\n' "$i" "$PASSES"
  pdflatex --enable-installer -interaction=nonstopmode \
           -output-directory=build "$JOB.tex" > "build/.pass$i.log" 2>&1
done

LOG="build/$JOB.log"
PDF="build/$JOB.pdf"
STATUS=0

echo
echo "================ RAPPORT DE CONSTRUCTION ================"

# ── 1. Le PDF existe-t-il ? ─────────────────────────────────
if [ ! -f "$PDF" ]; then
  echo "PDF          : NON PRODUIT"
  STATUS=1
else
  # ── 2. Le PDF est-il complet ? ────────────────────────────
  # Un PDF valide se termine par %%EOF. Son absence signale la
  # troncature décrite plus haut.
  if tail -c 2048 "$PDF" | grep -q "%%EOF"; then
    PAGES=$(grep -c "/Type[[:space:]]*/Page[^s]" "$PDF" 2>/dev/null)
    PAGES_LOG=$(tr -d '\n' < "$LOG" | grep -o "([0-9]\+ pages" | tail -1 | tr -dc '0-9')
    echo "PDF          : $PDF"
    echo "Pages        : ${PAGES_LOG:-$PAGES}"
    echo "Intégrité    : COMPLET (marqueur de fin présent)"
  else
    echo "PDF          : $PDF"
    echo "Intégrité    : TRONQUÉ. Le marqueur de fin est absent."
    echo "               Cause probable : une entrée de PATH pointant vers un fichier."
    STATUS=1
  fi
fi

# ── 3. Erreurs LaTeX ────────────────────────────────────────
ERRORS=$(grep -c "^!" "$LOG" 2>/dev/null)
echo
echo "--- Erreurs LaTeX : $ERRORS ---"
if [ "$ERRORS" -gt 0 ]; then
  grep -n "^!" "$LOG" | head -20
  STATUS=1
fi

# ── 4. Renvois et citations non résolus ─────────────────────
UNDEF=$(grep -c "Reference .* undefined\|Citation .* undefined" "$LOG" 2>/dev/null)
echo
echo "--- Renvois ou citations non résolus : $UNDEF ---"
if [ "$UNDEF" -gt 0 ]; then
  grep -n "Reference .* undefined\|Citation .* undefined" "$LOG" | head -20
  STATUS=1
fi

# ── 5. Débordements de mise en page ─────────────────────────
OVER=$(grep -c "Overfull \\\\hbox" "$LOG" 2>/dev/null)
echo
echo "--- Débordements horizontaux : $OVER ---"
[ "$OVER" -gt 0 ] && grep -n "Overfull \\\\hbox" "$LOG" | head -10

# ── 6. Images absentes ──────────────────────────────────────
MISSING=$(grep -c "File .* not found\|Unable to load picture" "$LOG" 2>/dev/null)
echo
echo "--- Images introuvables : $MISSING ---"
if [ "$MISSING" -gt 0 ]; then
  grep -n "File .* not found\|Unable to load picture" "$LOG" | head -10
  STATUS=1
fi

echo
if [ "$STATUS" -eq 0 ]; then
  echo "RÉSULTAT     : CONSTRUCTION RÉUSSIE"
else
  echo "RÉSULTAT     : ÉCHEC. Voir les points signalés ci-dessus."
fi
echo "========================================================"

rm -f build/.pass*.log
exit $STATUS
