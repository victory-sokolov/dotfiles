#!/bin/bash

# Get the directory where this script is located
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# List of packages to stow
PACKAGES=(
    "zsh"
    "git"
    "python"
    "nvim"
    "starship"
    "core"
)

# Stow packages
for package in "${PACKAGES[@]}"; do
    if [ -d "$DOTFILES_DIR/$package" ]; then
        echo "Stowing $package..."
        cd "$DOTFILES_DIR"
        stow "$package"
    else
        echo "Warning: Package $package not found"
    fi
done

# Handle .config packages separately
if [ -d "$DOTFILES_DIR/.config" ]; then
    echo "Stowing .config packages..."
    cd "$DOTFILES_DIR"
    stow --target="$HOME/.config" .config
fi
