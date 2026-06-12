#!/usr/bin/env bash
set -euo pipefail

REMOTE_URL="${1:-}"
GIT_NAME="${2:-}"
GIT_EMAIL="${3:-}"
BRANCH="${BRANCH:-main}"

usage() {
  cat <<'EOF'
Usage:
  bash PUBLISH_TO_GITHUB.sh <remote-url> "Your Name" "your.email@example.com"

Example SSH:
  bash PUBLISH_TO_GITHUB.sh git@github.com:YOUR_GITHUB_USERNAME/YOUR_REPO_NAME.git "Your Name" "you@example.com"

Example HTTPS:
  bash PUBLISH_TO_GITHUB.sh https://github.com/YOUR_GITHUB_USERNAME/YOUR_REPO_NAME.git "Your Name" "you@example.com"
EOF
}

if [ -z "$REMOTE_URL" ]; then
  usage
  exit 1
fi

command -v git >/dev/null || { echo "ERROR: git is required." >&2; exit 1; }

if [ ! -f REPO_MANIFEST.txt ]; then
  echo "ERROR: REPO_MANIFEST.txt not found. Run this from the repository root." >&2
  exit 1
fi

git init
# Works for both newly initialized repos and existing local repos.
git checkout -B "$BRANCH"

if [ -n "$GIT_NAME" ]; then
  git config user.name "$GIT_NAME"
fi
if [ -n "$GIT_EMAIL" ]; then
  git config user.email "$GIT_EMAIL"
fi

if ! git config user.name >/dev/null; then
  echo "ERROR: git user.name is not set. Pass it as the second argument or run: git config user.name 'Your Name'" >&2
  exit 1
fi
if ! git config user.email >/dev/null; then
  echo "ERROR: git user.email is not set. Pass it as the third argument or run: git config user.email 'you@example.com'" >&2
  exit 1
fi

# Force-add the reproduction manifest because the original .gitignore excludes
# several generated data/report paths that are intentionally included here.
git add -f --pathspec-from-file=REPO_MANIFEST.txt

if git diff --cached --quiet; then
  echo "No staged changes to commit."
else
  git commit -m "License and reproduce TBXT hackathon research repository"
fi

if git remote get-url origin >/dev/null 2>&1; then
  git remote set-url origin "$REMOTE_URL"
else
  git remote add origin "$REMOTE_URL"
fi

git push -u origin "$BRANCH"
