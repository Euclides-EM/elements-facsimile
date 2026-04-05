#!/bin/bash

set -e

DIAGRAMS_DIR="docs/diagrams"

if [ ! -d "$DIAGRAMS_DIR" ]; then
  echo "Error: directory '$DIAGRAMS_DIR' not found."
  exit 1
fi

for dir in "$DIAGRAMS_DIR"/*/; do
  [ -d "$dir" ] || continue

  dirname=$(basename "$dir")

  # Check if any file inside this subdir is untracked (new to git)
  untracked=$(git ls-files --others --exclude-standard "$dir")

  if [ -z "$untracked" ]; then
    echo "Skipping '$dirname' — no new (untracked) files."
    continue
  fi

  echo "Processing new directory: $dirname"

  git add "$dir"
  git commit -m "$dirname"
  git push

  echo "Done: '$dirname' committed and pushed."
done

echo "All done."
