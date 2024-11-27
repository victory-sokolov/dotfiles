#!/bin/zsh
# shellcheck shell=bash
# shellcheck disable=SC1091,SC1090,SC2034`

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

if [ "$TERM_PROGRAM" != "WarpTerminal" ]; then
    ZSH_THEME="powerlevel10k/powerlevel10k"
fi

# POWERLEVEL10K_MODE="nerdfont-complete"

export ZSH=$HOME/.oh-my-zsh
# Dotfiles exports 
export DOTFILES="$HOME/dotfiles"
export PATH="$DOTFILES/scripts/git:$PATH"
export PATH="$DOTFILES/scripts:$PATH"


# Setopts autocorrections
setopt correct_all
setopt autocd
setopt HIST_IGNORE_ALL_DUPS # Ignore duplicates
# Store history per tab
setopt inc_append_history
setopt share_history

# Tell ZSH not to nice background process
unsetopt BG_NICE
unsetopt CORRECT_ALL

cdpath="($HOME/dev $HOME/dotfiles)"

# Plugins
plugins=(
    evalcache
    git
    # gitfast
    git-open
    nvm
    extract
    per-directory-history
    fzf-tab
    fzf
    copypath
    # docs: https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/web-search
    web-search
    you-should-use
    zsh-syntax-highlighting
    zsh-autosuggestions
    zsh-completions
    # zsh-vi-mode
    z
    tmux
    kubectl
)

if [ -f thefuck ]; then
    eval thefuck --alias
fi

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
	export EDITOR="vim"
else
	export EDITOR="code"
fi

# docker
zstyle ":completion:*:*:docker:*" option-stacking yes
zstyle ":completion:*:*:docker-*:*" option-stacking yes
zstyle ":completion:*" accept-exact "*(N)"
zstyle ":completion:*" use-cache on
zstyle ":completion:*" cache-path ~/.zsh/cache

# speed https://coderwall.com/p/9fksra/speed-up-your-zsh-completions
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

zstyle ":completion:*:options" list-colors "=^(-- *)=34"
zstyle ":omz:plugins:nvm" lazy true
# zstyle ":omz:plugins:rbenv" lazy true
# zstyle ":omz:plugins:pyenv" lazy true
# Ignore useless files, like .pyc.
zstyle ":completion:*:(all-|)files" ignored-patterns "(|*/).pyc"
zstyle ':autocomplete:*' default-context history-incremental-search-backward

source "$ZSH/oh-my-zsh.sh"
source "$ZSH/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
source "$ZSH/custom/plugins/zsh-completions/zsh-completions.plugin.zsh"
source "$ZSH/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$ZSH/custom/plugins/zsh-autoenv/autoenv.zsh"
source "$DOTFILES/zsh/.exports"
source "$DOTFILES/zsh/.functions"
source "$DOTFILES/zsh/.aliases"
source "$DOTFILES/zsh/.dockerfunc"
source "$DOTFILES/kubernetes/.kube"
source "$DOTFILES/git/.git-functions"

if [ -f "$HOME/.cargo/env" ]; then
    source "$HOME/.cargo/env"
fi

# Privat env variables
PRIVATE_EXPORT_PATH="$HOME/dotfiles/zsh/.exports-private"
if test -f "$PRIVATE_EXPORT_PATH"; then
    source "$PRIVATE_EXPORT_PATH"
fi

if [ -f "$HOME/.asdf/asdf.sh" ]; then
    . "$HOME/.asdf/asdf.sh"
    . "$HOME/.asdf/completions/asdf.bash"
fi

# Custom settings depending on OS
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  DISTRIB=$(awk -F= '/^NAME/{gsub("\"", "", $2); print $2}' /etc/os-release)

  if [[ ${DISTRIB} = "Ubuntu"* ]]; then
    source "$HOME/dotfiles/linux/.linux-aliases"
    source "$HOME/dotfiles/linux/.linux-functions"
    source "$HOME/dotfiles/linux/.linux-exports"

    skip_global_compinit=1

    if uname -a | grep -q "^Linux.*Microsoft"; then
      # ubuntu via WSL Windows Subsystem for Linux
      # Set symlink for vscode
      ln -s "/mnt/c/Program Files/Microsoft VS Code/bin/code" /usr/local/bin/code

      export DISPLAY=$(awk '/nameserver / {print $2; exit}' /etc/resolv.conf 2>/dev/null):0
      export LIBGL_ALWAYS_INDIRECT=1
    fi
  fi
elif [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS OSX
    export NVM_DIR=~/.nvm

    source "$HOME/dotfiles/macos/.macos-aliases"
    source "$HOME/dotfiles/macos/.macos-exports"
    source $(brew --prefix nvm)/nvm.sh

    # Disable fork security feature for python multiprocessing
    export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES

    # Use GNU version of sed, awk
    export PATH="$(brew --prefix)/opt/gnu-sed/libexec/gnubin:$PATH"
    export PATH="$(brew --prefix)/opt/gawk/libexec/gnubin:$PATH"
fi

autoload -U add-zsh-hook
# general autocomplete helpers
autoload -U +X bashcompinit && bashcompinit
autoload -Uz compinit

if [ "(date +'%j') != $(stat -f '%Sm' -t '%j' ~/.zcompdump)" ]; then
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

rbenv() {
    export PATH="$HOME/.rbenv/bin:$PATH"
    _evalcache rbenv init - --no-rehash
    rbenv "$@"
}

nvm() {
  unset -f nvm
  export NVM_PREFIX=$(brew --prefix nvm)
  [ -s "$NVM_PREFIX/nvm.sh" ] && . "$NVM_PREFIX/nvm.sh"
  nvm "$@"
}

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
