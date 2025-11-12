#!/bin/zsh
# shellcheck shell=bash
# shellcheck disable=SC1091,SC1090,SC2034,SC2296

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source ~/zsh-defer/zsh-defer.plugin.zsh
source $(brew --prefix autoenv)/activate.sh

export ZSH=$HOME/.oh-my-zsh
# Dotfiles exports 
export DOTFILES="$HOME/dotfiles"
export PATH="$DOTFILES/scripts/git:$PATH"
export PATH="$DOTFILES/scripts:$PATH"

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

cdpath="($HOME/dev $HOME/dotfiles)"

# Plugins
plugins=(
  evalcache
  git
  git-open
  extract
  per-directory-history
  fzf-tab
  fzf
  copypath
  you-should-use
  z
  tmux
)

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
	export EDITOR="vi"
else
	export EDITOR="code"
fi

# docker
zstyle ":completion:*:*:docker:*" option-stacking yes
zstyle ":completion:*:*:docker-*:*" option-stacking yes
zstyle ":completion:*" accept-exact "*(N)"
zstyle ":completion:*" use-cache on
zstyle ":completion:*" cache-path ~/.zsh/cache

zstyle ":completion:*:options" list-colors "=^(-- *)=34"
zstyle ":omz:plugins:nvm" lazy true
# zstyle ":omz:plugins:pyenv" lazy true
# Ignore useless files, like .pyc.
zstyle ":completion:*:(all-|)files" ignored-patterns "(|*/).pyc"
zstyle ':autocomplete:*' default-context history-incremental-search-backward

skip_global_compinit=1
source "$ZSH/oh-my-zsh.sh"

# Only source these third-party plugin scripts when not running in Warp.
if [ "$TERM_PROGRAM" = "WarpTerminal" ]; then
    ZSH_THEME="powerlevel10k/powerlevel10k"
    plugins+=(zsh-syntax-highlighting zsh-autosuggestions zsh-completions)

    zsh-defer -t 0.05 source "$ZSH/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
    zsh-defer -t 0.05 source "$ZSH/custom/plugins/zsh-completions/zsh-completions.plugin.zsh"
    zsh-defer -t 0.05 source "$ZSH/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi

source "$DOTFILES/zsh/.exports"
zsh-defer source "$ZSH/custom/plugins/zsh-autoenv/autoenv.zsh"
zsh-defer source "$DOTFILES/zsh/.functions"
zsh-defer source "$DOTFILES/zsh/.aliases"
zsh-defer source "$DOTFILES/zsh/.dockerfunc"
zsh-defer source "$DOTFILES/kubernetes/.kube"
zsh-defer source "$DOTFILES/git/.git-functions"

if [ -f "$HOME/.cargo/env" ]; then
    zsh-defer source "$HOME/.cargo/env"
fi

# Privat env variables
PRIVATE_EXPORT_PATH="$HOME/dotfiles/zsh/.exports-private"
if test -f "$PRIVATE_EXPORT_PATH"; then
    source "$PRIVATE_EXPORT_PATH"
fi

# Version manager for everything
# brew install asdf
# if [ -f "$HOME/.asdf/asdf.sh" ]; then
#     . "$HOME/.asdf/asdf.sh"
#     . "$HOME/.asdf/completions/asdf.bash"
# fi

# Custom settings depending on OS
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  DISTRIB=$(awk -F= '/^NAME/{gsub("\"", "", $2); print $2}' /etc/os-release)

    # Homebrew for Linux
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

  if [[ ${DISTRIB} = "Ubuntu"* ]]; then
    zsh-defer source "$HOME/dotfiles/linux/.linux-aliases"
    zsh-defer source "$HOME/dotfiles/linux/.linux-functions"
    zsh-defer source "$HOME/dotfiles/linux/.linux-exports"

    skip_global_compinit=1

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

    # Disable fork security feature for python multiprocessing
    export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES

    # Use GNU version of sed, awk
    export BREW_PREFIX=${BREW_PREFIX:-/opt/homebrew}
    export PATH="$BREW_PREFIX/opt/gnu-sed/libexec/gnubin:$PATH"
    export PATH="$BREW_PREFIX/opt/gawk/libexec/gnubin:$PATH"
fi

autoload -U add-zsh-hook
# general autocomplete helpers
autoload -U +X bashcompinit && bashcompinit
autoload -Uz compinit

if [[ $(date +'%j') != $(stat -f '%Sm' -t '%j' ~/.zcompdump 2>/dev/null) ]]; then
  compinit
else
  compinit -C
fi

# increase number of file descriptors from default of 254
ulimit -n 10240

chpwd_functions=(change_node_version python_venv)

eval "$(zoxide init zsh)"

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
export PIPENV_PYTHON="$PYENV_ROOT/shims/python"
_evalcache pyenv init --path

if [[ -f ~/dotfiles/starship/starship.zsh ]]; then
    source ~/dotfiles/starship/starship.zsh
    _evalcache starship init zsh
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Terraform autocomplete
if command -v terraform &> /dev/null
then
    complete -o nospace -C /opt/homebrew/bin/terraform terraform
fi

export PNPM_HOME="${HOME}/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

zsh-defer source <(kubectl completion zsh)
# source ~/.kubectl_fzf.plugin.zsh
