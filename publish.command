#!/bin/zsh
cd "${0:A:h}"
./scripts/publish.sh
status=$?
echo
read "?Enter 키를 눌러 종료하세요."
exit $status
