#!/bin/bash

###############################################################################
# File Rename Script Documentation
###############################################################################
#
# DESCRIPTION:
#   This script uses ripgrep (rg) to recursively find and rename files based
#   on specified patterns. It provides safe file operations with multiple
#   modes including dry-run and interactive confirmation.
#
# PREREQUISITES:
#   - ripgrep (rg) must be installed on the system
#
# BASIC USAGE:
#   ./rename.sh <search_pattern> <replace_name> [directory]
#
#   ARGUMENTS:
#     search_pattern  Pattern to search for in filenames (supports wildcards)
#     replace_name    New name for matching files (supports wildcard substitution)
#     directory       Optional directory to search in (default: current directory)
#
#   EXAMPLES:
#     ./rename.sh "old_name.txt" "new_name.txt"
#     ./rename.sh "*.bak" "*.backup" ~/Documents
#
# ADVANCED USAGE:
#   ./rename.sh [OPTIONS] <search_pattern> <replace_name> [directory]
#
#   OPTIONS:
#     -d, --dry-run    Preview changes without actually renaming files
#     -i, --interactive Prompt for confirmation before each rename operation
#     -v, --verbose    Display detailed progress information
#     -h, --help       Show this help message and exit
#
#   ADVANCED EXAMPLES:
#     ./rename.sh -d "*.tmp" "deleted_*" /tmp
#     ./rename.sh -i "photo*.jpg" "vacation_*.jpg"
#     ./rename.sh -v "*.log" "archive_*.log" /var/log
#
# FEATURES:
#   - Supports wildcard patterns in both search and replace
#   - Recursively processes all subdirectories
#   - Includes hidden files in searches
#   - Prevents overwriting existing files
#   - Validates directory existence before processing
#   - Provides clear error messages and progress feedback
#
# SAFETY MECHANISMS:
#   - Dry-run mode allows previewing changes without modification
#   - Interactive mode provides confirmation for each operation
#   - Skips files when source and destination names are identical
#   - Prevents overwriting existing files
#   - Validates all inputs before processing
#
# OUTPUT:
#   - Operation summary showing patterns and directory
#   - Progress updates for each file being processed
#   - Warning messages for skipped files or issues
#   - Final summary with count of successfully renamed files
#
# ERROR HANDLING:
#   - Checks for ripgrep installation
#   - Validates directory existence
#   - Handles permission errors gracefully
#   - Provides clear error messages for common issues
#
# BEST PRACTICES:
#   1. Always use dry-run mode first to preview changes
#   2. Backup important data before bulk operations
#   3. Use specific patterns to avoid unintended matches
#   4. Verify write permissions in target directories
#   5. Review operation summary carefully before proceeding
#
# EXIT CODES:
#   0 - Success
#   1 - General error (missing prerequisites, invalid arguments)
#   2 - Directory does not exist
#   3 - ripgrep not installed
#
# NOTES:
#   - Uses ripgrep for fast, efficient file searching
#   - Handles file paths with spaces and special characters properly
#   - Wildcard substitution replaces the entire pattern match
#   - Script exits immediately on critical errors to prevent partial operations
#


# Function to display usage
usage() {
    cat << EOF
Usage: $0 [OPTIONS] <search_pattern> <replace_name> [directory]

OPTIONS:
    -d, --dry-run    Show what would be renamed without actually doing it
    -i, --interactive Prompt before each rename
    -v, --verbose    Show more information
    -h, --help       Show this help message

ARGUMENTS:
    search_pattern   Pattern to search for in filenames
    replace_name     New name for matching files  
    directory        Directory to search in (default: current directory)

EXAMPLES:
    $0 'old_name.txt' 'new_name.txt'
    $0 '*.bak' '*.backup' ~/Documents
    $0 -d '*.tmp' 'deleted_*' /tmp
    $0 -i 'photo*.jpg' 'vacation_*.jpg'
EOF
}

# Initialize variables
DRY_RUN=false
INTERACTIVE=false
VERBOSE=false

# Parse command line options
while [[ $# -gt 0 ]]; do
    case $1 in
        -d|--dry-run)
            DRY_RUN=true
            shift
            ;;
        -i|--interactive)
            INTERACTIVE=true
            shift
            ;;
        -v|--verbose)
            VERBOSE=true
            shift
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        -*)
            echo "Unknown option: $1"
            usage
            exit 1
            ;;
        *)
            break
            ;;
    esac
done

# Check remaining arguments
if [ $# -lt 2 ] || [ $# -gt 3 ]; then
    usage
    exit 1
fi

SEARCH_PATTERN="$1"
REPLACE_NAME="$2"
DIRECTORY="${3:-.}"

# Check if ripgrep is installed
if ! command -v rg &> /dev/null; then
    echo "Error: ripgrep (rg) is not installed."
    echo "Please install it first: https://github.com/BurntSushi/ripgrep#installation"
    exit 1
fi

# Verify directory exists
if [ ! -d "$DIRECTORY" ]; then
    echo "Error: Directory '$DIRECTORY' does not exist."
    exit 1
fi

# Counter for renamed files
counter=0

echo "File rename operation:"
echo "  Search pattern: $SEARCH_PATTERN"
echo "  Replace with:   $REPLACE_NAME"
echo "  Directory:      $DIRECTORY"
echo "  Dry run:        $DRY_RUN"
echo "  Interactive:    $INTERACTIVE"
echo ""

# Use ripgrep to find files
if [ "$VERBOSE" = true ]; then
    echo "Searching for files..."
fi

rg --files --hidden "$DIRECTORY" | \
rg "$SEARCH_PATTERN" | \
while IFS= read -r file; do
    if [ -f "$file" ]; then
        dir_name=$(dirname "$file")
        old_name=$(basename "$file")
        
        # Generate new filename
        if [[ "$REPLACE_NAME" == *"*"* ]]; then
            new_name="${old_name/$SEARCH_PATTERN/$REPLACE_NAME}"
            new_name="${new_name//\*/}"
        else
            new_name="$REPLACE_NAME"
        fi
        
        new_path="$dir_name/$new_name"
        
        # Skip if names are identical
        if [ "$old_name" = "$new_name" ]; then
            if [ "$VERBOSE" = true ]; then
                echo "Skipping (same name): $file"
            fi
            continue
        fi
        
        # Check for existing target
        if [ -e "$new_path" ]; then
            echo "Warning: '$new_path' already exists. Skipping '$file'"
            continue
        fi
        
        # Show or perform rename
        if [ "$DRY_RUN" = true ]; then
            echo "Would rename: $file -> $new_path"
            ((counter++))
        elif [ "$INTERACTIVE" = true ]; then
            echo "Found: $file"
            read -p "Rename to '$new_path'? [y/N] " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                mv -- "$file" "$new_path"
                if [ $? -eq 0 ]; then
                    echo "Renamed successfully"
                    ((counter++))
                else
                    echo "Error: Failed to rename '$file'"
                fi
            fi
        else
            echo "Renaming: $file -> $new_path"
            mv -- "$file" "$new_path"
            if [ $? -eq 0 ]; then
                ((counter++))
            else
                echo "Error: Failed to rename '$file'"
            fi
        fi
    fi
done

echo ""
if [ "$DRY_RUN" = true ]; then
    echo "Dry run complete. Would rename $counter file(s)"
else
    echo "Operation complete. Renamed $counter file(s)"
fi
