#!/bin/bash
# build-resume.sh — Pandoc Markdown → PDF pipeline
#
# Directory model:
#   Input  (gitignored): applications/<role-type>/<company-slug>/resume.md
#   Output (tracked):    dist/<role-type>-<NNN>/<OUTPUT_FILENAME>
#
# Usage:
#   ./scripts/build-resume.sh                          # builds src/resume.md → repo root
#   ./scripts/build-resume.sh <src.md> <output-dir>   # builds src into output-dir
#
# Examples:
#   ./scripts/build-resume.sh \
#     applications/distributed-backend/notion/resume.md \
#     dist/distributed-backend-001/
#
# Output filename is configured in config/build.conf (OUTPUT_FILENAME).
#
# Prerequisites: pandoc on PATH, pdflatex at /Library/TeX/texbin/pdflatex

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Load config
CONFIG="$REPO_ROOT/config/build.conf"
if [ -f "$CONFIG" ]; then
  # shellcheck source=../config/build.conf
  source "$CONFIG"
fi
OUTPUT_FILENAME="${OUTPUT_FILENAME:-Tushar-Pandey-resume.pdf}"

SRC="${1:-"$REPO_ROOT/src/resume.md"}"
OUTDIR="${2:-"$REPO_ROOT"}"
OUTFILE="$OUTDIR/$OUTPUT_FILENAME"

TEMPLATE="$REPO_ROOT/templates/resume-template.tex"
FILTER="$REPO_ROOT/filters/resume.lua"

# Verify prerequisites
if ! command -v pandoc &>/dev/null; then
  echo "Error: pandoc not found. Install with: brew install pandoc"
  exit 1
fi

if [ ! -f "/Library/TeX/texbin/pdflatex" ]; then
  echo "Error: pdflatex not found at /Library/TeX/texbin/pdflatex"
  echo "Install BasicTeX: https://www.tug.org/mactex/morepackages.html"
  exit 1
fi

if [ ! -f "$SRC" ]; then
  echo "Error: source not found: $SRC"
  exit 1
fi

mkdir -p "$OUTDIR"

echo "Building: $SRC → $OUTFILE"

pandoc "$SRC" \
  --template "$TEMPLATE" \
  --lua-filter "$FILTER" \
  --pdf-engine=/Library/TeX/texbin/pdflatex \
  -o "$OUTFILE"

echo "Done: $OUTFILE"
