#!/bin/zsh
# shellcheck shell=bash
# shellcheck disable=SC1091,SC1090,SC2034,SC2296

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

source "$HOME/zsh-defer/zsh-defer.plugin.zsh"

export DOTFILES="$HOME/dotfiles"
export ZSH=$HOME/.oh-my-zsh
export EDITOR="nvim"

source "$DOTFILES/zsh/.exports"
# Initialize mise if available
if command -v mise &> /dev/null; then
    zsh-defer _evalcache "$(mise activate zsh)"
fi

# Setopts autocorrections
# Navigate without using cd command
setopt autocd
# Store history per tab
setopt inc_append_history

# Tell ZSH not to nice background process
unsetopt BG_NICE
unsetopt CORRECT_ALL

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

cdpath=($HOME/dev $HOME/dotfiles)

# Plugins
plugins=(
  evalcache
  # git
  extract
  per-directory-history
  fzf-tab
  fzf
  copypath
)


zstyle ":completion:*" use-cache on
zstyle ":completion:*" cache-path ~/.zsh/cache
zstyle ":completion:*:options" list-colors "=^(-- *)=34"
# Ignore useless files, like .pyc.
zstyle ":completion:*:(all-|)files" ignored-patterns "(|*/).pyc"
zstyle ':autocomplete:*' default-context history-incremental-search-backward
zstyle ':omz:plugins:*' lazy yes

# Prevent the default Zsh completion system from initializing
skip_global_compinit=1
source "$ZSH/oh-my-zsh.sh"

# Only source these third-party plugin scripts when not running in Warp.
if [ "$TERM_PROGRAM" != "WarpTerminal" ]; then
    ZSH_THEME="powerlevel10k/powerlevel10k"
    plugins+=(zsh-syntax-highlighting zsh-autosuggestions zsh-completions)

    zsh-defer -t 0.05 source "$ZSH/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
    zsh-defer -t 0.05 source "$ZSH/custom/plugins/zsh-completions/zsh-completions.plugin.zsh"
    zsh-defer -t 0.05 source "$ZSH/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi

source "$DOTFILES/zsh/.functions"
# Load node package manager functions immediately
source "$DOTFILES/zsh/.node"
# Load Rust environment immediately
if [ -f "$HOME/.cargo/env" ]; then source "$HOME/.cargo/env"; fi
# Lazy load other configs with zsh-defer
zsh-defer source "$DOTFILES/zsh/.aliases" && \
    source "$DOTFILES/zsh/.python" && \
    source "$DOTFILES/zsh/.dockerfunc" && \
    source "$DOTFILES/zsh/.envfunc" && \
    source "$DOTFILES/zsh/.kube" && \
    source "$DOTFILES/zsh/.brew" && \
    source "$DOTFILES/git/.git-functions"

# Private env variables
PRIVATE_EXPORT_PATH="$HOME/dotfiles/zsh/.exports-private"
if test -f "$PRIVATE_EXPORT_PATH"; then
    source "$PRIVATE_EXPORT_PATH"
fi

# Custom settings depending on OS
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    DISTRIB=$(awk -F= '/^NAME/{gsub("\"", "", $2); print $2}' /etc/os-release)

    # Homebrew for Linux
    _evalcache "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

  if [[ ${DISTRIB} = "Ubuntu"* ]]; then
    zsh-defer source "$HOME/dotfiles/linux/.linux-aliases"
    zsh-defer source "$HOME/dotfiles/linux/.linux-functions"
    zsh-defer source "$HOME/dotfiles/linux/.linux-exports"

    if uname -a | grep -q "^Linux.*Microsoft"; then
      # ubuntu via WSL Windows Subsystem for Linux
      # Set symlink for vscode
      ln -s "/mnt/c/Program Files/Microsoft VS Code/bin/code" /usr/local/bin/code
    
      alias open='explorer.exe'

      export DISPLAY=$(awk '/nameserver / {print $2; exit}' /etc/resolv.conf 2>/dev/null):0
      export LIBGL_ALWAYS_INDIRECT=1
    fi
  fi
elif [[ "$OSTYPE" == "darwin"* ]]; then
    zsh-defer source "$HOME/dotfiles/macos/.macos-aliases"
    zsh-defer source "$HOME/dotfiles/macos/.macos-exports"
fi

# general autocomplete helpers
autoload -U +X bashcompinit && bashcompinit
# ensure .zcompdump exists
[[ -f ~/.zcompdump ]] || compinit
autoload -U add-zsh-hook

add-zsh-hook chpwd load-nvmrc-deferred

autoload -Uz add-zsh-hook
# Reload env when changing directories
add-zsh-hook chpwd dotenv_check

# init autocomplete
autoload -U compinit
if [[ ! -f ~/.zcompdump || $(find ~/.zcompdump -mtime +1 2>/dev/null) ]]; then
  compinit
else
  compinit -C
fi

# increase number of file descriptors from default of 254
ulimit -n 10240

if [[ -f ~/dotfiles/starship/starship.zsh ]]; then
    source ~/dotfiles/starship/starship.zsh
    _evalcache starship init zsh
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh


# Terraform autocomplete
if command -v terraform &> /dev/null
then
    complete -o nospace -C /opt/homebrew/bin/terraform terraform
fi

# Initialize zoxide if available
if command -v zoxide &> /dev/null; then
    _evalcache zoxide init zsh
fi

_evalcache kubectl completion zsh

[[ "$TERM_PROGRAM" == "kiro" ]] && . "$(kiro --locate-shell-integration-path zsh)"

# OpenClaw Completion
source <(openclaw completion --shell zsh)
