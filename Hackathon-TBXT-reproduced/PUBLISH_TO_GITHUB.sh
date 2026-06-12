#!/usr/bin/env bash
set -euo pipefail

REMOTE_URL="${1:-}"
GIT_NAME="${2:-Kemal Özkırşehirli}"
GIT_EMAIL="${3:-}"
BRANCH="${BRANCH:-main}"

usage() {
  cat <<'EOF'
Usage:
  bash PUBLISH_TO_GITHUB.sh <remote-url> "Kemal Özkırşehirli" "YOUR_GIT_EMAIL"

Examples:
  bash PUBLISH_TO_GITHUB.sh git@github.com:OWNER/Hackathon-TBXT.git "Kemal Özkırşehirli" "YOUR_GIT_EMAIL"
  bash PUBLISH_TO_GITHUB.sh https://github.com/OWNER/Hackathon-TBXT.git "Kemal Özkırşehirli" "YOUR_GIT_EMAIL"
EOF
}

if [ -z "$REMOTE_URL" ] || [ -z "$GIT_EMAIL" ]; then
  usage
  echo "ERROR: remote URL and git email are required." >&2
  exit 1
fi

command -v git >/dev/null || { echo "ERROR: git is required." >&2; exit 1; }

if [ ! -f REPO_MANIFEST.txt ]; then
  echo "ERROR: REPO_MANIFEST.txt not found. Run this from the repository root." >&2
  exit 1
fi

# Refuse to use a Markdown manifest; REPO_MANIFEST.txt must be pure pathspec lines.
if grep -q '^#\|^- `\|^## ' REPO_MANIFEST.txt; then
  echo "ERROR: REPO_MANIFEST.txt must contain only relative file paths, one per line." >&2
  exit 1
fi

git init
git checkout -B "$BRANCH"

git config user.name "$GIT_NAME"
git config user.email "$GIT_EMAIL"

# Force-add preserved artifacts because the original .gitignore excludes some generated paths.
git add -f --pathspec-from-file=REPO_MANIFEST.txt

if git diff --cached --quiet; then
  echo "No staged changes to commit."
else
  git commit -m "Release TBXT hackathon research repository"
fi

if git remote get-url origin >/dev/null 2>&1; then
  git remote set-url origin "$REMOTE_URL"
else
  git remote add origin "$REMOTE_URL"
fi

git push -u origin "$BRANCH"
