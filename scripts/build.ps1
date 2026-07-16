$ErrorActionPreference = 'Stop'
Set-Location (Join-Path $PSScriptRoot '..')

if (-not (Get-Command hugo -ErrorAction SilentlyContinue)) {
    throw "Hugo가 없습니다. 'winget install Hugo.Hugo.Extended'로 설치하세요."
}

hugo --gc --minify
if ($LASTEXITCODE -ne 0) { throw "Hugo 빌드에 실패했습니다." }
Write-Host '빌드 완료: public/'

