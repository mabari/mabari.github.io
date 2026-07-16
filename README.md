# mabari.github.io

Obsidian에서 작성하고 Hugo + PaperMod로 빌드하여 GitHub Pages에 배포하는 개인 지식 아카이브입니다. macOS와 Windows에서 같은 저장소를 번갈아 사용할 수 있도록 구성되어 있습니다.

## 저장소 구조

```text
content/posts/             블로그 글(페이지 번들)
archetypes/default.md      새 글 템플릿
assets/                    사이트 공용 에셋
themes/PaperMod/           Hugo 테마(저장소에 포함)
scripts/build.*            운영체제별 로컬 빌드
scripts/publish.*          pull → 빌드 → commit → push
.github/workflows/         GitHub Pages 자동 배포
public/                    빌드 결과(Git에서 제외)
```

Obsidian에서는 이 저장소의 **루트 폴더 전체**를 볼트로 엽니다. 실제 공개 원고는 `content/` 아래에만 둡니다.

## 최초 1회 준비

### macOS

```bash
xcode-select --install
brew install git hugo gh
git config --global core.autocrlf input
```

### Windows (PowerShell)

```powershell
winget install --id Git.Git -e
winget install --id Hugo.Hugo.Extended -e
winget install --id GitHub.cli -e
git config --global core.autocrlf true
```

설치 후 터미널을 다시 열고 확인합니다.

```text
git --version
hugo version
gh --version
```

## GitHub 연결

한 컴퓨터에서만 저장소를 처음 만든다면 다음을 실행합니다.

```bash
git init -b main
git remote add origin https://github.com/mabari/mabari.github.io.git
git add -A
git commit -m "Initial cross-platform blog setup"
git push -u origin main
```

다른 컴퓨터에서는 빈 폴더에 파일을 따로 복사하지 말고 저장소를 클론합니다.

```bash
git clone https://github.com/mabari/mabari.github.io.git
cd mabari.github.io
```

GitHub 저장소의 **Settings → Pages → Source**는 `GitHub Actions`로 설정합니다.

## 글 작성

글과 이미지를 같은 폴더에 두는 페이지 번들 방식을 사용합니다.

```bash
hugo new content posts/my-post/index.md
```

```text
content/posts/my-post/
├─ index.md
└─ chart.png
```

이미지는 일반 Markdown 문법으로 연결합니다.

```markdown
![차트 설명](chart.png)
```

Hugo는 기본적으로 Obsidian의 `[[위키링크]]`와 `![[임베드]]`를 변환하지 않습니다. 공개 글에서는 일반 Markdown 링크를 사용합니다. 공개할 때 frontmatter의 `draft`를 `false`로 바꿉니다.

## 로컬 미리보기

두 운영체제 모두 저장소 루트에서 다음 명령을 사용할 수 있습니다.

```bash
hugo server -D
```

브라우저에서 `http://localhost:1313`을 엽니다.

배포용 빌드만 확인하려면:

```bash
# macOS
./scripts/build.sh
```

```powershell
# Windows
.\scripts\build.ps1
```

## 게시

게시 스크립트는 먼저 원격 변경을 rebase 방식으로 받고, Hugo 빌드가 성공한 경우에만 변경 사항을 커밋하고 push합니다.

```bash
# macOS
./publish.command
# 또는 ./scripts/publish.sh
```

```powershell
# Windows
.\scripts\publish.ps1
```

push가 완료되면 `.github/workflows/hugo.yaml`이 GitHub Pages를 자동으로 빌드하고 배포합니다. `public/`은 생성 파일이므로 커밋하지 않습니다.

## 두 컴퓨터에서 안전하게 작업하는 규칙

1. 작업을 시작하기 전에 `git pull --rebase --autostash`를 실행합니다.
2. 한쪽 컴퓨터의 작업은 가능한 한 당일에 commit/push합니다.
3. 다른 컴퓨터로 이동하기 전에 push가 완료됐는지 확인합니다.
4. 같은 글을 양쪽에서 동시에 수정하지 않습니다.
5. `.obsidian/workspace.json`, 플러그인별 `data.json`, `.claudian/`은 장치별 상태이므로 동기화하지 않습니다.
6. Obsidian 설정과 설치된 플러그인 본체는 저장소로 공유하되, 로그인 정보나 API 키는 커밋하지 않습니다.

충돌이 발생하면 무리하게 게시하지 말고 다음으로 상태를 확인합니다.

```bash
git status
```

충돌 파일을 Obsidian 또는 텍스트 편집기에서 정리한 뒤:

```bash
git add 충돌을-해결한-파일
git rebase --continue
```

rebase를 취소하려면 `git rebase --abort`를 실행합니다.

## 운영 점검표

- `hugo server -D`에서 초안을 확인했는가
- 공개할 글이 `draft: false`인가
- 출처와 이미지 사용 권한을 확인했는가
- 개인정보, API 키, 로컬 경로가 들어 있지 않은가
- macOS/Windows 중 작업 중인 장치에서 최신 변경을 pull했는가
- GitHub Actions의 배포 작업이 성공했는가
