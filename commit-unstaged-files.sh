#!/bin/zsh

set -euo pipefail

files=()

while IFS= read -r -d '' entry; do
  git_status="${entry[1,2]}"
  git_path="${entry[4,-1]}"

  if [[ "$git_status" == "??" ]]; then
    files+=("$git_path")
    continue
  fi

  if [[ "${git_status[2]}" != " " ]]; then
    files+=("$git_path")
  fi
done < <(git status --porcelain -z)

if (( ${#files[@]} == 0 )); then
  echo "No unstaged files found."
  exit 0
fi

for file in "${files[@]}"; do
  if [[ ! -e "$file" ]]; then
    echo "Skipping missing git_path: $file" >&2
    continue
  fi

  git add -- "$file"
  git commit -m "Added $file"
  git push
done
