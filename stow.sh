#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

exclude=(archive)

packages=()
for dir in */; do
  name="${dir%/}"
  skip=false
  for e in "${exclude[@]}"; do
    if [[ "$name" == "$e" ]]; then
      skip=true
      break
    fi
  done
  $skip && continue
  packages+=("$name")
done

echo "Stowing into $HOME:"
printf '  %s\n' "${packages[@]}"

stow -t "$HOME" -R "${packages[@]}"

echo "Done."
