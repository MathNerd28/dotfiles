export ZSH="$HOME/.oh-my-zsh"

ZSH_DISABLE_COMPFIX=true
ZSH_THEME="refined"

HYPHEN_INSENSITIVE="true"
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"

plugins=(colorize git zsh-autosuggestions zsh-syntax-highlighting)
zstyle ':omz:update' mode reminder

source $ZSH/oh-my-zsh.sh

export EDITOR=code
export ARCHFLAGS="-arch x86_64"

export PGDATA=/var/lib/postgres/data
