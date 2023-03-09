export ZSH=$HOME/.oh-my-zsh
export TERM="xterm-256color"

eval "$(starship init zsh)"

set -m
#$unsetopt PROMPT_SP
ZSH_DISABLE_COMPFIX=true
ZSH_THEME="powerlevel10k/powerlevel10k"
# POWERLEVEL10K_MODE="nerdfont-complete"

# History
HISTSIZE=10000 # Lines of history to keep in memory for current session
HISTFILESIZE=10000 # Number of commands to save in the file
SAVEHIST=10000 # Number of history entries to save to disk
HIST_STAMPS="mm/dd/yyyy"

# Setopts autocorrections 
setopt correct
setopt correct_all
setopt autocd
setopt hist_ignore_dups # Ignore duplicates

cdpath=($HOME/dev $HOME/dotfiles)

DISABLE_UPDATE_PROMPT=true
ENABLE_CORRECTION="true"

# Plugins
plugins=(
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
	z
)

skip_global_compinit=1

# Tell ZSH not to nice background process
unsetopt BG_NICE

if [ -f thefuck ]; then
    eval $(thefuck --alias)
fi

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
	export EDITOR='vim'
else
	export EDITOR='code'
fi

# NPM
NPM_PACKAGES="${HOME}/.npm-packages"
export PATH="$PATH:$NPM_PACKAGES/bin"

# docker
zstyle ':completion:*:*:docker:*' option-stacking yes
zstyle ':completion:*:*:docker-*:*' option-stacking yes
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache
# how often to update omz
zstyle ':omz:update' frequency 7
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':omz:plugins:nvm' lazy true
# Ignore useless files, like .pyc.
zstyle ':completion:*:(all-|)files' ignored-patterns '(|*/).pyc'

# fzf
export FZF_DEFAULT_COMMAND="rg --files --hidden --follow --glob '!.git'"
export FZF_DEFAULT_OPTS="--color=dark"

source $ZSH/oh-my-zsh.sh
source $ZSH/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $ZSH/custom/plugins/zsh-completions/zsh-completions.plugin.zsh
source $ZSH/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source $ZSH/custom/plugins/zsh-autoenv/autoenv.zsh
source $HOME/dotfiles/zsh/.functions
source $HOME/dotfiles/zsh/.aliases
source $HOME/dotfiles/zsh/.exports
source $HOME/dotfiles/zsh/.dockerfunc

if [ -f $HOME/.cargo/env ]; then
    source $HOME/.cargo/env
fi

source '/home/viktor/.nvm/versions/node/v18.6.0/lib/node_modules/@hyperupcall/autoenv/activate.sh'

# Privat env variables
PRIVATE_EXPORT_PATH="$HOME/dotfiles/zsh/.exports-private"
if test -f "$PRIVATE_EXPORT_PATH"; then
    source $PRIVATE_EXPORT_PATH 
fi

if [ -f $HOME/.asdf/asdf.sh ]; then
    . $HOME/.asdf/asdf.sh
    . $HOME/.asdf/completions/asdf.bash
fi

# Custom settings depending on OS
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  local DISTRIB=$(awk -F= '/^NAME/{print $2}' /etc/os-release)
  if [[ ${DISTRIB} = "Ubuntu"* ]]; then
    if uname -a | grep -q '^Linux.*Microsoft'; then
      # ubuntu via WSL Windows Subsystem for Linux
      # Set symlink for vscode
      ln -s '/mnt/c/Program Files/Microsoft VS Code/bin/code' /usr/local/bin/code
    else
      # native ubuntu
    fi
  elif [[ ${DISTRIB} = "Debian"* ]]; then
    # debian
  fi
elif [[ "$OSTYPE" == "darwin"* ]]; then
  # macOS OSX
fi

# Auto change node version with .nvm
function change_node_version {
	nvmrc="./.nvmrc"
	if [ -f "$nvmrc" ]; then
		version="$(cat "$nvmrc")"
		nvm use $version
	fi
}

autoload -U add-zsh-hook
autoload -Uz compinit && compinit

chpwd_functions=(change_node_version, python_venv)
