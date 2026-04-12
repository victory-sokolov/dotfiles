#!/bin/bash

# Get the directory where this script is located
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Install homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Add homebrew to path
echo >> $HOME/.zprofile
echo 'eval "$(/opt/homebrew/bin/brew shellenv zsh)"' >> $HOME/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv zsh)"

# Brew packages
brew install stow

# Package installation for Dotfiles
git clone https://github.com/romkatv/zsh-defer.git $HOME/zsh-defer
git clone https://github.com/mroth/evalcache "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"/plugins/evalcache
git clone https://github.com/Aloxaf/fzf-tab "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"/plugins/fzf-tab
git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf
$HOME/.fzf/install -y

yes | sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"


# Create backup directory with timestamp
BACKUP_DIR="$HOME/.dotfiles-backup-$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

# Function to backup existing files
backup_existing_files() {
    local package="$1"
    local target_dir="${2:-$HOME}"
    
    if [ ! -d "$DOTFILES_DIR/$package" ]; then
        return
    fi
    
    echo "Checking for existing files in $package..."
    
    # Find all files that would be linked by stow
    cd "$DOTFILES_DIR" || exit
    find "$package" -type f -o -type l | while read -r file; do
        # Remove the package prefix to get the target path
        target_path="${file#"$package"/}"
        full_target_path="$target_dir/$target_path"
        
        # Check if target exists and is not a symlink to our dotfiles
        if [ -e "$full_target_path" ] && [ ! -L "$full_target_path" ]; then
            # Create corresponding directory structure in backup
            backup_target_dir="$BACKUP_DIR/${target_path%/*}"
            mkdir -p "$backup_target_dir"
            
            echo "Backing up: $full_target_path -> $BACKUP_DIR/$target_path"
            mv "$full_target_path" "$BACKUP_DIR/$target_path"
        elif [ -L "$full_target_path" ]; then
            # Check if symlink points to our dotfiles
            link_target=$(readlink "$full_target_path")
            if [[ "$link_target" != *"$DOTFILES_DIR"* ]]; then
                # It's a symlink to somewhere else, backup it
                backup_target_dir="$BACKUP_DIR/${target_path%/*}"
                mkdir -p "$backup_target_dir"
                
                echo "Backing up external symlink: $full_target_path -> $BACKUP_DIR/$target_path"
                mv "$full_target_path" "$BACKUP_DIR/$target_path"
            fi
        fi
    done
}

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
        echo "Processing $package..."
        
        target_dir="$HOME"
        if [ "$package" = "nvim" ]; then
            target_dir="$HOME/.config/nvim"
            mkdir -p "$target_dir"
        fi
        
        # Backup existing files before stowing
        backup_existing_files "$package" "$target_dir"
        
        echo "Stowing $package to $target_dir..."
        cd "$DOTFILES_DIR" || exit
        stow --target="$target_dir" "$package"
    else
        echo "Warning: Package $package not found"
    fi
done



# Function to symlink scripts to a target directory
symlink_scripts() {
    local scripts_dir="$1"
    local target_dir="$2"
    shift 2
    local scripts=("$@")

    mkdir -p "$target_dir"

    for script in "${scripts[@]}"; do
        local source="$scripts_dir/$script"
        local target="$target_dir/${script%.sh}"  # remove .sh extension

        if [ ! -f "$source" ]; then
            echo "Warning: Script not found: $source"
            continue
        fi

        # Backup existing file if not a symlink to our dotfiles
        if [ -e "$target" ] && [ ! -L "$target" ]; then
            mkdir -p "$BACKUP_DIR"
            echo "Backing up: $target -> $BACKUP_DIR/"
            mv "$target" "$BACKUP_DIR/"
        fi

        # Remove existing symlink (even if pointing elsewhere)
        [ -L "$target" ] && rm "$target"

        echo "Linking: $source -> $target"
        ln -s "$source" "$target"
        chmod +x "$source"
    done
}

# Scripts to symlink
SCRIPTS=(
    "backup.sh"
    "clone-repos.sh"
    "clone_repo_by_topic.sh"
    "clean-xcode.sh"
    "gh-projects.sh"
    "refactoring.sh"
    "rename.sh"
    "run-gh-pr-comments.sh"
)

# Install global npm packages
npm install -g $(cat install/npmfile)

# Symlink scripts to ~/.local/bin
SCRIPTS_TARGET="$HOME/.local/bin"
symlink_scripts "$DOTFILES_DIR/scripts" "$SCRIPTS_TARGET" "${SCRIPTS[@]}"

echo "Dotfiles setup complete!"
echo "Any conflicting files have been backed up to: $BACKUP_DIR"
