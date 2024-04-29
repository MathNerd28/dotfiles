#!/usr/bin/sh

DOTFILES_DIR="$(pwd)"
LS="ls -A"

# Script dependencies
SCRIPT_DEPENDENCIES="yay findutils"
if ! pacman -Qqi $SCRIPT_DEPENDENCIES >/dev/null; then
  echo "Need to install packages before proceeding"
  sudo pacman -Sy --needed $SCRIPT_DEPENDENCIES
fi

# # Install packages
# if ! cat package.list | xargs yay -Qqi >/dev/null; then
#   echo "Installing dependencies..."
#   cat package.list | xargs yay -Syq --needed
# else
#   echo "All dependencies present, skipping"
# fi

# BACKUP
echo "Backing up current configuration..."

backup() {
  # Only if file/directory exists
  if [ -d "$1" ] || [ -f "$1" ]; then
    echo "Moving $1 to $1.bak"
    mv "$1" "$1.bak"
  else
    echo "Skipping $1"
  fi
}

backupSudo() {
  if [ -d "$1" ] || [ -f "$1" ]; then
    echo "Backing up $1 to $1.bak"
    sudo mv "$1" "$1.bak"
  else
    echo "Skipping backup of $1"
  fi
}

OIFS="$IFS"
IFS=$'\n'

for f in $(find "$DOTFILES_DIR/home" -type f -printf '%P\n'); do
  echo $f
  backup "$HOME/$f"
done

for f in $(find "$DOTFILES_DIR/config" -type f -printf '%P\n'); do
  backup "$HOME/.config/$f"
done

for f in $(find "$DOTFILES_DIR/etc" -type f -printf '%P\n'); do
  backupSudo "/etc/$f"
done

echo "Backup complete"

# Link everything to its proper place
echo "Linking dotfiles..."

linkFiles() {
  for file in $(find "$1" -type f -printf '%P\n'); do
    echo "Linking $1/$file to $2/$file"
    mkdir -p "$(dirname "$2/$file")"
    ln -s "$1/$file" "$2/$file"
  done
}

linkFilesSudo() {
  for file in $(find "$1" -type f -printf '%P\n'); do
    echo "Linking $1/$file to $2/$file"
    sudo mkdir -p "$(dirname "$2/file")"
    sudo ln -s "$1/$file" "$2/$file"
  done
}

linkFiles "$DOTFILES_DIR/home" "$HOME"
linkFiles "$DOTFILES_DIR/config" "$HOME/.config"
linkFilesSudo "$DOTFILES_DIR/etc" /etc

IFS="$OIFS"

echo "Installation complete"
