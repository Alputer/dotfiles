#!/usr/bin/env bash
#
# Bootstrap these dotfiles from the public repo, without cloning with git.
#
#   curl -fsSL https://raw.githubusercontent.com/Alputer/dotfiles/main/bootstrap.sh | bash
#
# Downloads the repo tarball to ~/.dotfiles and symlinks each package into
# $HOME. Safe to re-run; files in the way are moved to <file>.bak. Override
# with DOTFILES_REPO, DOTFILES_BRANCH, DOTFILES_DIR.
#
set -euo pipefail

repo="${DOTFILES_REPO:-Alputer/dotfiles}"
branch="${DOTFILES_BRANCH:-main}"
dir="${DOTFILES_DIR:-$HOME/.dotfiles}"
tarball="https://github.com/$repo/archive/refs/heads/$branch.tar.gz"
marker="zsh/.zshrc" # identifies a dotfiles checkout

# 1. Get the files: local checkout, existing clone, or fresh tarball.
self="$(cd "$(dirname "${BASH_SOURCE[0]:-.}")" && pwd)"
if [[ -f "$self/$marker" ]]; then
  src="$self"
elif [[ -d "$dir/.git" ]]; then
  git -C "$dir" pull --ff-only
  src="$dir"
elif [[ -f "$dir/$marker" || ! -e "$dir" || -z "$(ls -A "$dir")" ]]; then
  rm -rf "$dir" && mkdir -p "$dir"
  curl -fsSL "$tarball" | tar -xz -C "$dir" --strip-components=1
  src="$dir"
else
  echo "error: $dir is not empty" >&2
  exit 1
fi

# 2. Symlink every package file into $HOME.
shopt -s nullglob
for pkg_dir in "$src"/*/; do
  pkg="$(basename "$pkg_dir")"
  [[ "$pkg" == archive || "$pkg" == ssh ]] && continue

  while IFS= read -r -d '' file; do
    dest="$HOME/${file#"$src/$pkg"/}"
    mkdir -p "$(dirname "$dest")"
    [[ -e "$dest" && ! -L "$dest" ]] && mv "$dest" "$dest.bak"
    ln -sfn "$file" "$dest"
  done < <(find "$pkg_dir" -type f ! -name .DS_Store -print0)
done

echo "Linked $src into $HOME"
