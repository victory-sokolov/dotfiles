#!/bin/bash

# Set your GitHub username or organization here
OWNER="victory-sokolov"

# Check dependencies
for cmd in gh jq fzf glow; do
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

# Function to extract project ID from URL
extract_project_id() {
    local url="$1"
    # Extract the project ID from URL like https://github.com/users/victory-sokolov/projects/2
    echo "$url" | grep -oE '[0-9]+$'
}

# Function to show project tasks
show_project_tasks() {
    local project_id="$1"
    local project_title="$2"
    
    # Fetch project items
    local items_json
    items_json=$(gh project item-list "$project_id" --owner "$OWNER" --format json 2>/dev/null)
    
    if [[ $? -ne 0 || -z "$items_json" ]]; then
        echo "Error: Failed to fetch project tasks"
        return 1
    fi
    
    # Extract tasks - filter out "Done" status and use content.title for the task name and content.body for description
    local tasks_data
    tasks_data=$(echo "$items_json" | jq -r '.items[]? | select(.status != "Done") | [.content.title, (.content.body // "No description" | @base64)] | @tsv')
    
    if [[ -z "$tasks_data" ]]; then
        echo "No tasks found in this project"
        return 1
    fi
    
    # Display tasks in fzf
    echo "$tasks_data" | fzf \
        --delimiter=$'\t' \
        --with-nth=1 \
        --preview 'echo {2} | base64 -d | glow -s dark -w 80 -' \
        --preview-window=right:60%:wrap \
        --height=40% \
        --border \
        --header="Tasks in: $project_title • ESC to exit"
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

# Get selected project using fzf without execute binding
selected_line=$(echo "$processed_data" | fzf \
    --delimiter='\t' \
    --with-nth=1 \
    --preview 'echo {3}' \
    --preview-window=right:60%:wrap \
    --height=40% \
    --border \
    --header="GitHub Projects (Owner: $OWNER) • Enter: Show Tasks • ESC: Exit")

# If a project was selected, show its tasks
if [[ -n "$selected_line" ]]; then
    IFS=$'\t' read -r clean_title original_title url <<< "$selected_line"
    project_id=$(extract_project_id "$url")
    
    if [[ -n "$project_id" ]]; then
        show_project_tasks "$project_id" "$clean_title"
    else
        echo "Error: Could not extract project ID from URL: $url"
    fi
fi
