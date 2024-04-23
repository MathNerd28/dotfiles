#!/usr/bin/sh

# Read install directory
if [ -z "$1" ]; then
  INSTALL_DIR="$HOME/dotfiles"
elif [ -d "$1" ]; then
  INSTALL_DIR="$1/dotfiles"
else
  echo "$1 is not a valid directory" && exit 64
fi

if [ -d "$INSTALL_DIR" ] || [ -f "$INSTALL_DIR" ]; then
  echo "Directory $INSTALL_DIR already exists"
  exit
else
  echo "Writing dotfiles to $INSTALL_DIR"
fi

SCRIPT_DEPENDENCIES="yay git findutils"

# Script dependencies
if ! pacman -Qqi $SCRIPT_DEPENDENCIES >/dev/null; then
  echo "Need to install the following before proceeding"
  sudo pacman -Sy --needed yay git
else
  echo "yay and git already installed, skipping..."
fi

# BACKUP

backup() {
  # Only if file/directory exists
  if [ -d "$1" ] || [ -f "$1" ]; then
    echo "Moving $1 to $1.bak"
    # mv "$1" "$1.bak"
  fi
}

echo "Backing up current configuration..."
cd $HOME
backup .config
backup .swaylock
backup .vscode-oss
backup .gitconfig
backup .nanorc
backup .zshrc
echo "Backup complete"

# Clone repository into specified directory or $HOME
git clone "https://github.com/MathNerd28/dotfiles.git" "$INSTALL_DIR"
cd $INSTALL_DIR

cat package.list | xargs

# Link everything to its proper place
