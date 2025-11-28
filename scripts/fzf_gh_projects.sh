#!/bin/bash

# Set your GitHub username or organization here
OWNER="victory-sokolov"

# Check dependencies
for cmd in gh jq fzf; do
    if ! command -v "$cmd" &> /dev/null; then
        echo "Error: $cmd is not installed or not in PATH"
        exit 1
    fi
done

# Function to extract projects from JSON
extract_projects() {
    local json_data="$1"
    
    # Try different possible JSON structures
    # Structure 1: Array of projects with direct fields
    if echo "$json_data" | jq -e 'type == "array" and length > 0 and .[0] | has("name") or has("title")' >/dev/null 2>&1; then
        echo "$json_data" | jq -r '.[] | select(.name != null or .title != null) | "\(.title // .name)\t\(.url // .htmlUrl // .webUrl // "")"'
    
    # Structure 2: Object with projects array
    elif echo "$json_data" | jq -e 'has("projects") or has("items")' >/dev/null 2>&1; then
        echo "$json_data" | jq -r '.projects[]? // .items[]? | select(.name != null or .title != null) | "\(.title // .name)\t\(.url // .htmlUrl // .webUrl // "")"'
    
    # Structure 3: Direct object with title/name
    elif echo "$json_data" | jq -e 'has("name") or has("title")' >/dev/null 2>&1; then
        echo "$json_data" | jq -r '"\(.title // .name)\t\(.url // .htmlUrl // .webUrl // "")"'
    
    # Structure 4: Try to extract any objects with name/title fields
    else
        echo "$json_data" | jq -r '.. | select(.name? != null or .title? != null) | "\(.title // .name)\t\(.url // .htmlUrl // .webUrl // .resourcePath // "")"' 2>/dev/null | grep -v "^\s*$"
    fi
}

# Function to clean project title (remove username prefix)
clean_title() {
    local title="$1"
    # Remove patterns like "@username's " from the beginning of the title
    echo "$title" | sed -E "s/^@[^']+'s //"
}

# Main script
echo "Fetching projects for: $OWNER" >&2

# Fetch projects
projects_json=$(gh project list --owner "$OWNER" --format json 2>/dev/null)

if [[ $? -ne 0 || -z "$projects_json" ]]; then
    echo "Error: Failed to fetch projects or no projects found"
    echo "Make sure:"
    echo "  1. You are authenticated with 'gh auth login'"
    echo "  2. The owner '$OWNER' exists and you have access to their projects"
    echo "  3. GitHub CLI is properly configured"
    exit 1
fi

# Check if we have any data
if [[ "$projects_json" == "[]" || "$projects_json" == "null" ]]; then
    echo "No projects found for: $OWNER"
    exit 0
fi

# Extract projects and clean titles
extracted_data=$(extract_projects "$projects_json")

if [[ -z "$extracted_data" ]]; then
    echo "Debug: Could not extract project data. Raw JSON:"
    echo "$projects_json" | jq .
    exit 1
fi

# Process the data to clean titles while keeping original for preview
processed_data=$(echo "$extracted_data" | while IFS=$'\t' read -r title url; do
    clean_title=$(clean_title "$title")
    printf "%s\t%s\t%s\n" "$clean_title" "$title" "$url"
done)

# Display in fzf
selected_url=$(echo "$processed_data" | fzf \
    --delimiter='\t' \
    --with-nth=1 \
    --preview 'echo {3}' \
    --preview-window=right:60%:wrap \
    --height=40% \
    --border \
    --header="GitHub Projects (Owner: $OWNER) • Enter: Open in browser • Ctrl-C: Exit" \
    --bind 'enter:execute(echo {3})')

# If a project was selected, open it in browser
if [[ -n "$selected_url" && "$selected_url" != "null" ]]; then
    echo "Opening: $selected_url"
    if command -v xdg-open &> /dev/null; then
        xdg-open "$selected_url"
    elif command -v open &> /dev/null; then
        open "$selected_url"
    else
        echo "URL: $selected_url"
    fi
fi
