#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

if ! command -v hugo >/dev/null 2>&1; then
  echo "Hugo가 없습니다. macOS에서는 'brew install hugo'로 설치하세요." >&2
  exit 1
fi

hugo --gc --minify
echo "빌드 완료: public/"

