export GPG_TTY=$(tty)
export CLICOLOR=1
export LS_COLORS="$(vivid generate molokai)"
export TERM="xterm-256color"

# Prefer US English and use UTF-8.
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8

# ZSH
export PROMPT_SP=
export ZSH_DISABLE_COMPFIX=true
export ZSH_COMPDUMP=$ZSH/cache/.zcompdump-$HOST
export DISABLE_UPDATE_PROMPT="true"
export DISABLE_AUTO_UPDATE="true"
export ENABLE_CORRECTION="true"

export XDG_DATA_HOME=${XDG_DATA_HOME:="$HOME/.local/share"}
export XDG_CACHE_HOME=${XDG_CACHE_HOME:="$HOME/.cache"}
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:="$HOME/.config"}
