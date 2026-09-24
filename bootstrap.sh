#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
darwin_flake="github:nix-darwin/nix-darwin/nix-darwin-26.05"

echo "==> Determinate Nix"
if command -v nix >/dev/null 2>&1; then
  echo "    nix already installed, skipping"
else
  curl --proto '=https' --tlsv1.2 -sSf -L \
    https://install.determinate.systems/nix |
    sh -s -- install --no-confirm
fi

if [[ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]]; then
  # shellcheck disable=SC1091
  . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
fi

if ! command -v nix >/dev/null 2>&1; then
  echo "error: nix is not available after installing Determinate Nix" >&2
  exit 1
fi

echo "==> Applying nix-darwin configuration"
sudo nix run "${darwin_flake}#darwin-rebuild" -- \
  switch --flake "${repo_dir}#mac"
