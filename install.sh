#!/usr/bin/sh

DOTFILES_DIR="$(pwd)"
LS="ls -A"

findFiles() {
  find "$1" -type f -printf '%P\n'
}

SCRIPT_DEPENDENCIES="yay findutils"
if ! pacman -Qqi $SCRIPT_DEPENDENCIES >/dev/null; then
  echo "Need to install packages before proceeding"
  sudo pacman -Sy --needed $SCRIPT_DEPENDENCIES
fi

if ! cat package.list | xargs yay -Qqi >/dev/null; then
  echo "Installing dependencies..."
  cat package.list | xargs yay -Syq --needed
fi

backup() {
  for file in $(findFiles "$1"); do
    if [ -d "$2/$file" ] || [ -f "$2/$file" ]; then
      echo "Moving $2/$file to $file.bak"
      if [ -z $3 ]; then
        mv "$2/$file" "$2/$file.bak"
      else
        sudo mv "$2/$file" "$2/$file.bak"
      fi
    else
      echo "$2/$file not present, skipping"
    fi
  done
}

OIFS="$IFS"
IFS=$'\n'

backup "$DOTFILES_DIR/config" "$HOME/.config"
backup "$DOTFILES_DIR/home" "$HOME"
backup "$DOTFILES_DIR/etc" "/etc" 1

linkFiles() {
  for file in $(findFiles "$1"); do
    echo "Linking $1/$file to $2/$file"
    if [ -z "$3" ]; then
      mkdir -p "$(dirname "$2/$file")"
      ln -s "$1/$file" "$2/$file"
    else
      sudo mkdir -p "$(dirname "$2/$file")"
      sudo ln -s "$1/$file" "$2/$file"
    fi
  done
}

linkFiles "$DOTFILES_DIR/home" "$HOME"
linkFiles "$DOTFILES_DIR/config" "$HOME/.config"
linkFiles "$DOTFILES_DIR/etc" /etc 1

IFS="$OIFS"

echo "Installation complete"
