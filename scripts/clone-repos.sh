#!/bin/bash

# shellcheck source=lib/common.sh
if [ -L "$0" ]; then
  SCRIPT_DIR="$(dirname "$(readlink "$0")")"
else
  SCRIPT_DIR="$(dirname "$0")"
fi
source "${SCRIPT_DIR}/lib/common.sh"

check_deps gh fzf jq || exit 1

# Fetch repos, filter out archived and forked
echo "Fetching repositories..."
repos=$(gh repo list --limit 1000 --json name,url,description,isArchived,isFork | \
  jq -r '.[] | select(.isArchived == false and .isFork == false) | "\(.name)\t\(.url)\t\(.description // "No description")"')

# Check if any repos were found
if [ -z "$repos" ]; then
  echo "No repositories found (or all are archived/forked)"
  exit 1
fi

# Use fzf for selection with custom display
selected=$(echo "$repos" | \
  fzf --multi \
      --delimiter='\t' \
      --with-nth=1 \
      --preview 'echo {3}' \
      --preview-window=right:30%:wrap \
      --header="Select repos to clone (TAB to select multiple, ENTER to confirm)" \
      --prompt="Repos > " \
      --height=100% \
      --layout=reverse \
      --border)

# Exit if no repos are selected
if [ -z "$selected" ]; then
  echo "No repositories selected."
  exit 0
fi

# Extract URLs and clone repositories
echo ""
echo "Cloning selected repositories..."
echo "$selected" | awk -F'\t' '{print $2}' | while read -r url; do
  repo_name=$(basename "$url" .git)
  if [ ! -d "$repo_name" ]; then
    gh repo clone "$url"
    echo "✓ Successfully cloned $repo_name"
  fi
done

echo ""
echo "Done!"
