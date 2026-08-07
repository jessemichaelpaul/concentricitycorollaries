#!/bin/sh
# Build the master and put the fresh PDF where you actually click it.
#
#   scripts/master.sh
#
# latexmk writes to output/pdf/.  The copy at the repo root is the one that
# opens from the Finder window, so it is refreshed here on every build; that is
# why it used to go stale.  Requires the authoring phase only if the .tex is
# being edited -- building alone is fine in either phase.
set -e
cd "$(dirname "$0")/.."

latexmk -pdf -interaction=nonstopmode -halt-on-error \
        -outdir=output/pdf Octonionic_RH_master.tex

cp output/pdf/Octonionic_RH_master.pdf ./Octonionic_RH_master.pdf

echo
if grep -qi "undefined" output/pdf/Octonionic_RH_master.log; then
  echo "WARNING - undefined references:"
  grep -i "undefined" output/pdf/Octonionic_RH_master.log
else
  echo "no undefined references"
fi
echo "pages: $(grep -o 'Output written.*(\([0-9]*\) pages' output/pdf/Octonionic_RH_master.log | tail -1 | sed 's/.*(\([0-9]*\) pages/\1/')"
echo "fresh pdf at ./Octonionic_RH_master.pdf"
