#!/bin/zsh

# Check if required commands are available
command -v gh >/dev/null 2>&1 || { echo "Error: gh CLI is not installed"; exit 1; }
command -v fzf >/dev/null 2>&1 || { echo "Error: fzf is not installed"; exit 1; }

# Fetch repos, filter out archived and forked, format for fzf
echo "Fetching repositories..."
repos=$(gh repo list --limit 1000 --json name,url,description,isArchived,isFork | \
  jq -r '.[] | select(.isArchived == false and .isFork == false) | "\(.url)\t\(.description // "No description")"')

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
      --preview 'echo {2}' \
      --preview-window=right:30%:wrap \
      --header="Select repos to clone (TAB to select multiple, ENTER to confirm)" \
      --prompt="Repos > " \
      --height=100% \
      --layout=reverse \
      --border)

# Extract only the URLs from selected
selected=$(echo "$selected" | awk -F'\t' '{print $1}')

# Check if any repos were selected
if [ -z "$selected" ]; then
  echo "No repositories selected"
  exit 0
fi

# Clone selected repositories
echo ""
echo "Cloning selected repositories..."
echo "$selected" | while read -r url; do
  repo_name=$(basename "$url" .git)
  echo ""
  echo "Cloning: $repo_name"
  
  if [ -d "$repo_name" ]; then
    echo "⚠️  Directory '$repo_name' already exists, skipping..."
  else
    gh repo clone "$url"
    if [ $? -eq 0 ]; then
      echo "✓ Successfully cloned $repo_name"
    else
      echo "✗ Failed to clone $repo_name"
    fi
  fi
done

echo ""
echo "Done!"
