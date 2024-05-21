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

backupFiles() {
  for file in $(findFiles "$DOTFILES_DIR/$1"); do
    if [ -e "$2/$file" ] || [ -L "$2/$file" ]; then
      dir=$(dirname "$file")/
      name=$(basename "$file")
      if [ "$dir" = "./" ]; then
        dir=""
      fi
      echo "mv $2/$dir{$name => $name.bak}"
      $3 mv "$2/$file" "$2/$file.bak"
    fi
  done
}

backupFiles home "$HOME"
backupFiles etc /etc sudo

linkFiles() {
  for file in $(findFiles "$DOTFILES_DIR/$1"); do
    echo "ln -s {$2 => ./$1}/$file"
    $3 mkdir -p "$(dirname "$2/$file")"
    $3 ln -s "$DOTFILES_DIR/$1/$file" "$2/$file"
  done
}

linkFiles home "$HOME"
linkFiles etc /etc sudo

IFS="$OIFS"

echo "done"
