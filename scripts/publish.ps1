$ErrorActionPreference = 'Stop'
Set-Location (Join-Path $PSScriptRoot '..')

foreach ($command in @('git', 'hugo')) {
    if (-not (Get-Command $command -ErrorAction SilentlyContinue)) {
        throw "$command 명령을 찾을 수 없습니다. README의 Windows 준비 절차를 확인하세요."
    }
}

$branch = (git branch --show-current).Trim()
if ($LASTEXITCODE -ne 0) { throw 'Git 저장소가 아닙니다.' }
if ($branch -ne 'main') { throw "현재 브랜치가 main이 아닙니다: $branch" }

git pull --rebase --autostash
if ($LASTEXITCODE -ne 0) { throw 'git pull에 실패했습니다.' }

hugo --gc --minify
if ($LASTEXITCODE -ne 0) { throw 'Hugo 빌드에 실패했습니다.' }

git add -A
git diff --cached --quiet
if ($LASTEXITCODE -eq 0) {
    Write-Host '배포할 변경 사항이 없습니다.'
    exit 0
}

$message = '블로그 업데이트: ' + (Get-Date -Format 'yyyy-MM-dd HH:mm')
git commit -m $message
if ($LASTEXITCODE -ne 0) { throw '커밋에 실패했습니다.' }
git push
if ($LASTEXITCODE -ne 0) { throw '푸시에 실패했습니다.' }
Write-Host '배포 요청 완료: https://mabari.github.io/'

