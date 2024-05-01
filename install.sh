#!/usr/bin/sh

DOTFILES_DIR="$(pwd)"

findFiles() {
  find "$1" -type f -printf '%P\n'
}

if ! pacman -Qq yay >/dev/null; then
  echo "Need to install yay before proceeding"
  sudo pacman -Sy yay
fi

if ! cat package.list | xargs yay -Qqi >/dev/null; then
  echo "Installing dependencies..."
  cat package.list | xargs yay -Syq --needed
fi

OIFS="$IFS"
IFS=$'\n'

backup() {
  SUDO=""
  if ! [ -z $3 ]; then
    SUDO="sudo"
  fi

  for file in $(findFiles "$1"); do
    if [ -d "$2/$file" ] || [ -f "$2/$file" ]; then
      echo "Moving $2/$file to $file.bak"
      $SUDO mv "$2/$file" "$2/$file.bak"
    fi
  done
}

backup "$DOTFILES_DIR/config" "$HOME/.config"
backup "$DOTFILES_DIR/home" "$HOME"
backup "$DOTFILES_DIR/etc" "/etc" 1

linkFiles() {
  SUDO=""
  if ! [ -z $3 ]; then
    SUDO="sudo"
  fi

  for file in $(findFiles "$1"); do
    echo "Linking $1/$file to $2/$file"
    $SUDO mkdir -p "$(dirname "$2/$file")"
    $SUDO ln -s "$1/$file" "$2/$file"
  done
}

linkFiles "$DOTFILES_DIR/home" "$HOME"
linkFiles "$DOTFILES_DIR/config" "$HOME/.config"
linkFiles "$DOTFILES_DIR/etc" /etc 1

IFS="$OIFS"

echo "Installation complete"
