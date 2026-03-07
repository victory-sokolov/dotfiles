#!/bin/bash
# Accepts optional PR number as first arg, otherwise auto-detects.
# Retrieves and prints PR review comments every 15s, for 5 runs, with an initial wait of 30s.

set -euo pipefail

if ! command -v gh >/dev/null 2>&1; then
    echo "Error: gh CLI not found. Install: https://github.com/cli/cli"
    exit 1
fi

OWNER_REPO=$(gh repo view --json nameWithOwner --jq .nameWithOwner)

# PR number can be passed as first positional argument
PR_NUMBER="${1:-}"

# If no PR provided, try to auto-detect from current branch
if [[ -z "$PR_NUMBER" ]]; then
    PR_NUMBER=$(gh pr view --json number --jq .number 2>/dev/null || true)
fi

if [[ -z "$PR_NUMBER" ]]; then
    echo "Usage: $0 [pr-number]"
    exit 1
fi

echo "Starting run-gh-pr-comments for $OWNER_REPO PR#$PR_NUMBER: initial wait 30s..."
sleep 30

for i in {1..5}; do
    echo "Run #$i — $(date)"
    gh pr-review review view --repo "$OWNER_REPO" "$PR_NUMBER" | jq || echo "(fetch failed)" >&2
    if [[ $i -lt 5 ]]; then
        echo "Sleeping 15s before next check..."
        sleep 15
    fi
done

echo "Completed all runs: $(date)"
