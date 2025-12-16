#!/usr/bin/env bash
set -euo pipefail

# -------- ARGUMENTS --------
if [[ $# -ne 2 ]]; then
  echo "Usage: $0 <topic> <clone-directory>"
  exit 1
fi

TOPIC="$1"
CLONE_DIR="$2"

# -------- DEPENDENCY CHECK --------
command -v gh >/dev/null || { echo "gh CLI is required"; exit 1; }
command -v jq >/dev/null || { echo "jq is required"; exit 1; }

mkdir -p "$CLONE_DIR"

# -------- GET AUTH USER --------
OWNER=$(gh api user --jq '.login')

echo "User: $OWNER"
echo "Topic: $TOPIC"
echo "Directory: $CLONE_DIR"
echo "------------------------------"

# -------- FETCH REPOS --------
REPOS=$(gh api \
  "/search/repositories?q=user:$OWNER+topic:$TOPIC&per_page=100" \
  --paginate \
  --jq '.items[].ssh_url')

if [[ -z "$REPOS" ]]; then
  echo "No repositories found for topic '$TOPIC'"
  exit 0
fi

# -------- CLONE --------
cd "$CLONE_DIR"

for REPO in $REPOS; do
  NAME=$(basename "$REPO" .git)

  if [[ -d "$NAME" ]]; then
    echo "Skipping $NAME (already exists)"
  else
    echo "Cloning $NAME..."
    git clone "$REPO"
  fi
done

echo "Done."
