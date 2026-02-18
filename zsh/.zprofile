# shellcheck shell=zsh
eval "$(/opt/homebrew/bin/brew shellenv)"

export PATH="/opt/homebrew/bin:$PATH"
export PATH="/opt/homebrew/sbin:$PATH"

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
export PATH="$PNPM_HOME:$PATH"

# npm globals
export PATH="$HOME/.npm-packages/bin:$PATH"

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
# shellcheck source=~/.orbstack/shell/init.zsh
source ~/.orbstack/shell/init.zsh 2>/dev/null || :
