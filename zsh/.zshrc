#!/bin/zsh
# shellcheck shell=bash
# shellcheck disable=SC1091,SC1090,SC2034`

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

set -m

export ZSH=$HOME/.oh-my-zsh
export PROMPT_SP=
export ZSH_DISABLE_COMPFIX=true

if [ "$TERM_PROGRAM" != "WarpTerminal" ]; then
    ZSH_THEME="powerlevel10k/powerlevel10k"
fi

# POWERLEVEL10K_MODE="nerdfont-complete"

# Setopts autocorrections
setopt correct
setopt correct_all
setopt autocd
setopt hist_ignore_dups # Ignore duplicates
setopt HIST_IGNORE_SPACE

cdpath="($HOME/dev $HOME/dotfiles)"
skip_global_compinit=1

export DISABLE_UPDATE_PROMPT="true"
export ENABLE_CORRECTION="true"

# Plugins
plugins=(
    evalcache
	git
    git-open
	npm
    nvm
	extract
	sudo
	docker
	per-directory-history
	react-native
	fzf
	copypath
	web-search
	you-should-use
	zsh-syntax-highlighting
	zsh-autosuggestions
	zsh-completions
    zsh-vi-mode
	z
    tmux
)

# Tell ZSH not to nice background process
unsetopt BG_NICE
unsetopt CORRECT_ALL
unsetopt share_history  # prevent sharing between running shells


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
# how often to update omz
zstyle ":omz:update" frequency 7
zstyle ":completion:*:options" list-colors "=^(-- *)=34"
zstyle ":omz:plugins:nvm" lazy true
zstyle ":omz:plugins:rbenv" lazy true
zstyle ":omz:plugins:pyenv" lazy true
# Ignore useless files, like .pyc.
zstyle ":completion:*:(all-|)files" ignored-patterns "(|*/).pyc"

source "$ZSH/oh-my-zsh.sh"
source "$ZSH/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
source "$ZSH/custom/plugins/zsh-completions/zsh-completions.plugin.zsh"
source "$ZSH/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$ZSH/custom/plugins/zsh-autoenv/autoenv.zsh"
source "$HOME/dotfiles/zsh/.functions"
source "$HOME/dotfiles/zsh/.aliases"
source "$HOME/dotfiles/zsh/.exports"
source "$HOME/dotfiles/zsh/.dockerfunc"

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
  DISTRIB=$(awk -F= "/^NAME/{print $2}" /etc/os-release)
  if [[ ${DISTRIB} = "Ubuntu"* ]]; then
    source "$HOME/dotfiles/linux/.linux-aliases"
    if uname -a | grep -q "^Linux.*Microsoft"; then
      # ubuntu via WSL Windows Subsystem for Linux
      # Set symlink for vscode
      ln -s "/mnt/c/Program Files/Microsoft VS Code/bin/code" /usr/local/bin/code
    fi
  fi
elif [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS OSX
    source "$HOME/dotfiles/macos/.macos-aliases"
    source "$HOME/dotfiles/macos/.macos-exports"

    # Disable fork security feature for python multiprocessing
    export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES
fi
#   elif [[ ${DISTRIB} = "Debian"* ]]; then
#   fi


# Auto change node version with .nvm
function change_node_version {
	nvmrc="./.nvmrc"
	if [ -f "$nvmrc" ]; then
		version="$(cat "$nvmrc")"
		nvm use "$version"
	fi
}

autoload -U add-zsh-hook

autoload -Uz compinit
if [ "(date +'%j') != $(stat -f '%Sm' -t '%j' ~/.zcompdump)" ]; then
  compinit
else
  compinit -C
fi

chpwd_functions=(change_node_version python_venv)

pyenv() {
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    export PIPENV_PYTHON="$PYENV_ROOT/shims/python"
    _evalcache pyenv init --path
}

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
