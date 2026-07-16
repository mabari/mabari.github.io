#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

command -v git >/dev/null 2>&1 || { echo "Git이 없습니다." >&2; exit 1; }
command -v hugo >/dev/null 2>&1 || { echo "Hugo가 없습니다. 'brew install hugo'로 설치하세요." >&2; exit 1; }

branch="$(git branch --show-current)"
if [[ "$branch" != "main" ]]; then
  echo "현재 브랜치가 main이 아닙니다: $branch" >&2
  exit 1
fi

git pull --rebase --autostash
hugo --gc --minify
git add -A

if git diff --cached --quiet; then
  echo "배포할 변경 사항이 없습니다."
  exit 0
fi

git commit -m "블로그 업데이트: $(date '+%Y-%m-%d %H:%M')"
git push
echo "배포 요청 완료: https://mabari.github.io/"

