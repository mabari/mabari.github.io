#!/bin/zsh

set -e

cd "${0:A:h}"

echo "최신 GitHub 변경 사항을 확인합니다."
git pull --rebase --autostash

echo "Hugo 블로그를 검사합니다."
hugo --gc --minify

git add .

if git diff --cached --quiet; then
  echo "배포할 변경 사항이 없습니다."
  read "?Enter 키를 눌러 종료하세요."
  exit 0
fi

commit_message="블로그 업데이트: $(date '+%Y-%m-%d %H:%M')"
git commit -m "$commit_message"
git push

echo "배포 요청을 완료했습니다: https://mabari.github.io/"
read "?Enter 키를 눌러 종료하세요."
