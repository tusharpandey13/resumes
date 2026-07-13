#!/bin/bash
# Usage: ./compile.sh path/to/resume.tex
# Compiles the given .tex file to PDF in the same directory.

set -e

TEX="$1"

if [ -z "$TEX" ]; then
  echo "Usage: $0 path/to/resume.tex"
  exit 1
fi

if [ ! -f "$TEX" ]; then
  echo "File not found: $TEX"
  exit 1
fi

DIR="$(cd "$(dirname "$TEX")" && pwd)"
FILE="$(basename "$TEX")"

echo "Compiling $FILE..."
/Library/TeX/texbin/pdflatex -interaction=nonstopmode -output-directory "$DIR" "$DIR/$FILE"
# Second pass for cross-references
/Library/TeX/texbin/pdflatex -interaction=nonstopmode -output-directory "$DIR" "$DIR/$FILE"

# Clean aux files
rm -f "$DIR/${FILE%.tex}.aux" \
      "$DIR/${FILE%.tex}.log" \
      "$DIR/${FILE%.tex}.out"

echo "Done: $DIR/${FILE%.tex}.pdf"
