#!/usr/bin/env bash
set -euo pipefail
echo "🔗 Linking modular configs from configs.list..."

MANIFEST="${HOME}/.dotfiles/configs.list"
CLONE_DIR="${HOME}/.dotfiles/external-configs"
mkdir -p "$CLONE_DIR"

while read -r repo dest || [ -n "$repo" ]; do
  [[ -z "$repo" || "$repo" =~ ^# ]] && continue
  REPO_URL="$repo"
  DEST_PATH=$(eval echo "$dest")
  NAME=$(basename "$REPO_URL" .git)
  TARGET_DIR="${CLONE_DIR}/${NAME}"

  echo "➡️  $NAME → $DEST_PATH"

  if [ -d "$TARGET_DIR/.git" ]; then
    git -C "$TARGET_DIR" fetch --depth 1 origin main >/dev/null 2>&1 || true
    git -C "$TARGET_DIR" pull --ff-only || true
  else
    git clone --depth 1 "$REPO_URL" "$TARGET_DIR"
  fi

  mkdir -p "$(dirname "$DEST_PATH")"

  if [ -e "$DEST_PATH" ] && [ ! -L "$DEST_PATH" ]; then
    mv "$DEST_PATH" "${DEST_PATH}.bak.$(date +%s)"
    echo "   💾 Backed up existing file."
  fi

  ln -sfn "$TARGET_DIR" "$DEST_PATH"
done <"$MANIFEST"

echo "✅  Configs linked successfully!"
