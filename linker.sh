#!/bin/bash

set -ex

DOTFILES=$HOME/dotfiles

for i in .zsh .peco; do
  \rm -rf "$HOME/$i"
  ln -s "$DOTFILES/dot$i" "$HOME/$i"
done

mkdir -p "$HOME/.config"
for j in "$DOTFILES"/dot.config/*; do
  ln -sfn "$j" "$HOME/.config/$(basename "$j")"
done

for i in "$DOTFILES"/dot.*; do
  if [ -f "$i" ]; then
    ln -sf "$i" "$HOME/$(basename "$i" | sed 's/^dot//')"
  fi
done

if command -v tmux > /dev/null 2>&1 && ! tmux list-sessions > /dev/null 2>&1; then
  tmux new-session -d
  tmux send-keys C-t I
  sleep 1
  tmux kill-server
fi
