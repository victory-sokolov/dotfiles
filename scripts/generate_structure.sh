#!/bin/bash

# Script to generate folder structure from a text file representation
# Usage: ./generate_structure.sh structure.txt
# Input file format example:
# project/
# ├── src/
# │   ├── main.py
# │   └── utils.py
# ├── README.md
# └── docs/

STRUCTURE_FILE="$1"

if [ -z "$STRUCTURE_FILE" ]; then
  echo "Usage: $0 <structure-file>"
  exit 1
fi

current_path=""

while IFS= read -r line; do
  # Remove tree characters
  clean="${line//[│├└─ ]/}"

  # Skip empty lines
  [ -z "$clean" ] && continue

  # Detect indent level (4 spaces per level)
  indent_level=$(echo "$line" | sed -e 's/[^ ].*//' | awk '{ print length/4 }')

  # Extract name
  name="$clean"

  # If ends with "/", it's a directory
  if [[ "$name" == */ ]]; then
    # Remove trailing slash
    folder="${name%/}"

    # Adjust current path according to indent level
    IFS='/' read -ra path_parts <<< "$current_path"
    new_path=""
    for ((i=0; i<indent_level; i++)); do
      new_path+="${path_parts[i]}/"
    done
    new_path+="$folder"

    # Create folder if needed
    mkdir -p "$new_path"

    current_path="$new_path"
  else
    # It's a file
    file_path="$current_path/$name"
    mkdir -p "$(dirname "$file_path")"
    touch "$file_path"
  fi

done < "$STRUCTURE_FILE"

echo "Folder structure created successfully."
