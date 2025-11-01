#!/bin/bash

fzf_repomix_advanced() {
    local selected_items=()
    local item
    
    # Use fd (if available) for faster searching, fallback to find
    if command -v fd >/dev/null 2>&1; then
        local find_cmd="fd --type f --type d --hidden --exclude .git"
    else
        local find_cmd="find . -type f -o -type d -name '*'"
    fi
    
    # Use a temporary file to store fzf output
    local temp_file
    temp_file=$(mktemp)
    
    # Run fzf and save selections to temp file
    eval "$find_cmd" | \
    fzf --multi \
        --prompt="Select files/dirs for repomix: " \
        --bind 'ctrl-a:select-all,ctrl-d:deselect-all' \
        --preview='
            if [ -f {} ]; then
                if command -v bat >/dev/null 2>&1; then
                    bat --color=always --style=numbers {} 2>/dev/null || head -100 {}
                else
                    head -100 {}
                fi
            else
                if command -v tree >/dev/null 2>&1; then
                    tree -C {} 2>/dev/null | head -100
                else
                    ls -la {}
                fi
            fi
        ' \
        --preview-window=right:60% \
        --height=80% > "$temp_file"
    
    # Read selections from temp file
    while IFS= read -r item; do
        [ -n "$item" ] && selected_items+=("$item")
    done < "$temp_file"
    
    # Clean up temp file
    rm -f "$temp_file"
    
    if [ ${#selected_items[@]} -eq 0 ]; then
        echo "No items selected."
        return 1
    fi
    
    # Ask user for format preference
    echo "Select format for repomix --include:"
    echo "1) Comma-separated glob patterns (default)"
    echo "2) Individual --include flags for each item"
    echo "3) Show command without executing"
    read -r -p "Choice [1]: " format_choice
    format_choice=${format_choice:-1}
    
    case $format_choice in
        1)
            # Format 1: Comma-separated glob patterns
            local include_args=()
            for item in "${selected_items[@]}"; do
                item="${item#./}"
                if [ -d "$item" ]; then
                    include_args+=("${item}/**/*")
                else
                    include_args+=("$item")
                fi
            done
            
            printf -v include_string '%s,' "${include_args[@]}"
            include_string="${include_string%,}"
            cmd="repomix --include \"$include_string\""
            ;;
            
        2)
            # Format 2: Individual --include flags
            cmd="repomix"
            for item in "${selected_items[@]}"; do
                item="${item#./}"
                if [ -d "$item" ]; then
                    cmd="$cmd --include \"${item}/**/*\""
                else
                    cmd="$cmd --include \"$item\""
                fi
            done
            ;;
            
        3)
            # Just show the command
            local include_args=()
            for item in "${selected_items[@]}"; do
                item="${item#./}"
                if [ -d "$item" ]; then
                    include_args+=("${item}/**/*")
                else
                    include_args+=("$item")
                fi
            done
            
            printf -v include_string '%s,' "${include_args[@]}"
            include_string="${include_string%,}"
            cmd="repomix --include \"$include_string\""
            echo "Command: $cmd"
            return 0
            ;;
            
        *)
            echo "Invalid choice."
            return 1
            ;;
    esac
    
    echo "Executing: $cmd"
    eval "$cmd"
}

# Call the function if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    fzf_repomix_advanced
fi
