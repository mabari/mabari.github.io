# Hugo + PaperMod 개인 지식 아카이브

이 저장소는 macOS, Hugo, PaperMod, GitHub Actions, GitHub Pages로 운영하는 개인 지식 아카이브의 시작점입니다. 검색, 카테고리, 태그, 아카이브, RSS, 다크 모드, 목차, 코드 복사, 기본 SEO 설정이 포함되어 있습니다.

## 1. 준비

```bash
xcode-select --install
brew install hugo git gh
hugo version
git --version
gh --version
```

PaperMod는 Hugo 0.146.0 이상이 필요합니다. 더 낮으면 `brew upgrade hugo`를 실행하세요.

## 2. 프로젝트 초기화

이 폴더를 원하는 위치에 복사한 뒤 폴더로 이동합니다.

```bash
cd ~/Documents
mv hugo-papermod-knowledge-base my-knowledge-base
cd my-knowledge-base
git init -b main
git submodule add --depth=1 https://github.com/adityatelange/hugo-PaperMod.git themes/PaperMod
```

`hugo.yaml`의 `title`, `copyright`, `params.author`, GitHub 소셜 주소를 자신의 정보로 바꿉니다. `baseURL`은 배포 때 실제 GitHub Pages 주소로 자동 대체됩니다.

## 3. 로컬 확인

```bash
hugo server -D
```

브라우저에서 `http://localhost:1313`을 엽니다. 종료는 `Control+C`입니다. 배포용 빌드도 검사합니다.

```bash
hugo --gc --minify
```

생성된 `public/` 폴더는 Git에 올리지 않습니다.

## 4. GitHub 저장소 생성

개인 사이트는 저장소 이름을 정확히 `GITHUB_USERNAME.github.io`로 정합니다. 사용자명이 `octocat`이면 사이트 주소는 `https://octocat.github.io/`입니다.

```bash
gh auth login
gh repo create GITHUB_USERNAME.github.io --public --source=. --remote=origin
git add .
git commit -m "Initial Hugo knowledge base"
git push -u origin main
```

프로젝트 사이트라면 저장소를 `my-knowledge-base`처럼 정해도 됩니다. 주소는 `https://GITHUB_USERNAME.github.io/my-knowledge-base/`가 되고, 배포 작업이 경로를 자동 설정합니다.

## 5. GitHub Pages 활성화

1. 저장소의 `Settings` → `Pages`로 이동합니다.
2. `Build and deployment`의 `Source`를 `GitHub Actions`로 선택합니다.
3. `Actions`에서 `Build and deploy Hugo site`가 성공하는지 확인합니다.
4. 완료된 `deploy` 단계의 사이트 주소를 엽니다.

이후 `main`에 push할 때마다 자동 배포됩니다.

## 6. 글 작성

글과 이미지를 같은 폴더에 두는 페이지 번들 방식을 권장합니다.

```bash
hugo new content posts/pca-introduction/index.md
```

생성된 글을 편집하고 공개할 때 `draft: true`를 `draft: false`로 바꿉니다. 같은 폴더의 `chart.png`는 다음처럼 넣습니다.

```markdown
![PCA 결과](chart.png)
```

배포합니다.

```bash
git add .
git commit -m "Add PCA introduction"
git push
```

## 7. Obsidian 연결

Obsidian에서 `Open folder as vault`를 선택하고 프로젝트의 `content` 폴더를 엽니다.

권장 설정:

- `Files and links` → `New link format`: Relative path to file
- `Use [[Wikilinks]]`: 끄기
- `Default location for new attachments`: Same folder as current file
- 새 글은 `posts/글-슬러그/index.md` 폴더 노트로 작성

Hugo는 기본 상태에서 `[[위키링크]]`와 Obsidian 임베드를 해석하지 않습니다. 일반 Markdown 링크와 이미지 문법을 사용하세요. 비공개 정보는 `content` 아래에 두지 마세요.

## 8. 운영 점검표

- `hugo server -D`에서 초안을 확인했는가
- 출처와 이미지 사용 권한을 확인했는가
- 개인정보나 API 키가 없는가
- `hugo --gc --minify`가 성공하는가
- 모바일과 다크 모드에서 읽기 쉬운가
- GitHub Actions 배포가 성공했는가

## 문제 해결

PaperMod를 찾지 못하거나 클론 후 테마가 비어 있으면:

```bash
git submodule update --init --recursive
```

처음부터 서브모듈까지 클론하려면:

```bash
git clone --recurse-submodules REPOSITORY_URL
```

CSS나 링크 경로가 깨지면 `Settings` → `Pages`의 Source가 `GitHub Actions`인지 확인하세요. 글이 보이지 않으면 `draft: false`인지, 날짜가 미래가 아닌지 확인하세요.

## 업데이트

```bash
git submodule update --remote --merge
git add themes/PaperMod
git commit -m "Update PaperMod"
git push

brew update
brew upgrade hugo
```

Hugo를 올린 뒤 `.github/workflows/hugo.yaml`의 `HUGO_VERSION`도 호환 버전으로 갱신하고 로컬 빌드를 확인하세요.
