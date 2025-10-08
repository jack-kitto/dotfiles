#!/usr/bin/env bash
set -euo pipefail
echo "🔗 Linking modular configs from configs.list..."

MANIFEST="${HOME}/.dotfiles/configs.list"
CLONE_DIR="${HOME}/.dotfiles/external-configs"

mkdir -p "$CLONE_DIR"

# Read line‑by‑line, skip comments or blanks
while read -r repo dest || [ -n "$repo" ]; do
  [[ -z "$repo" ]] && continue
  [[ "$repo" =~ ^# ]] && continue

  # split into vars
  REPO_URL="$repo"
  DEST_PATH=$(eval echo "$dest") # expand ~ etc.
  NAME=$(basename "$REPO_URL" .git)
  TARGET_DIR="${CLONE_DIR}/${NAME}"

  echo ""
  echo "➡️  $NAME → $DEST_PATH"

  # clone or update
  if [ -d "$TARGET_DIR/.git" ]; then
    echo "   Updating existing repo..."
    git -C "$TARGET_DIR" pull --ff-only || true
  else
    echo "   Cloning $REPO_URL..."
    git clone --depth 1 "$REPO_URL" "$TARGET_DIR"
  fi

  # link destination
  mkdir -p "$(dirname "$DEST_PATH")"
  if [ -e "$DEST_PATH" ] || [ -L "$DEST_PATH" ]; then
    rm -rf "$DEST_PATH"
  fi
  ln -sfn "$TARGET_DIR" "$DEST_PATH"
done <"$MANIFEST"

echo ""
echo "✅ All configs linked successfully!"
