export ZSH="$HOME/.oh-my-zsh"

ZSH_DISABLE_COMPFIX=true
ZSH_THEME="refined"

HYPHEN_INSENSITIVE="true"
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"

plugins=(
  zsh-autosuggestions
  zsh-syntax-highlighting
  command-not-found
  z
)
zstyle ':omz:update' mode reminder

source $ZSH/oh-my-zsh.sh
unsetopt correct_all

export EDITOR=code
export ARCHFLAGS="-arch x86_64"

eval $(thefuck --alias)
alias please="fc -ln -1 | xargs sudo"

export XDG_SCREENSHOTS_DIR="$HOME/Downloads"

export JAVA_HOME="/usr/lib/jvm/default"
