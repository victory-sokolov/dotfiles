
export ZSH="$HOME/.oh-my-zsh"


ZSH_THEME="powerlevel9k/powerlevel9k"
POWERLEVEL9K_MODE="nerdfont-complete"

POWERLEVEL9K_PROMPT_ON_NEWLINE=true
POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
POWERLEVEL9K_RPROMPT_ON_NEWLINE=true
POWERLEVEL9K_SHORTEN_DIR_LENGTH=2
POWERLEVEL9K_SHORTEN_STRATEGY="truncate_beginning"
POWERLEVEL9K_STATUS_VERBOSE=false
POWERLEVEL9K_VCS_COMMIT_ICON="\uf417"
POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX="%F{blue}\u256D\u2500%f"
POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="%F{blue}\u2570\uf460%f"


ENABLE_CORRECTION="true"

# History.
HIST_STAMPS="yyyy-mm-dd"

# Plugins
plugins=(
	git
	cloudapp
	npm
	zsh-autosuggestions
	zsh-syntax-highlighting
	extract
	sudo
	web-search
)

eval $(thefuck --alias)


# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='code'
fi


source $ZSH/oh-my-zsh.sh
source $HOME/Documents/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $HOME/.functions