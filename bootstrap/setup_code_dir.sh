#!/usr/bin/env bash
set -euo pipefail
CODE_DIR="${HOME}/code"

if [ -d "${CODE_DIR}" ]; then
  echo "✅  Code directory exists (${CODE_DIR})"
else
  echo "📁  Creating ${CODE_DIR}"
  mkdir -p "${CODE_DIR}"
fi

echo "🧾  $(ls -ld "${CODE_DIR}")"
