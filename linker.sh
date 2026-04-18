#!/bin/bash

set -ex

DOTFILES=$HOME/dotfiles

for i in .zsh .peco; do
  \rm -rf $HOME/$i
  ln -s $DOTFILES/dot$i $HOME/$i
done

for i in $DOTFILES/dot.*; do
    if [ "$i" = "$DOTFILES/dot.config" ]; then
        mkdir -p $HOME/.config
	for j in $DOTFILES/dot.config/*; do
            ln -sf $j $HOME/.config/`basename $j `
        done
    elif [ -f $i ]; then
        ln -sf $i $HOME/`basename $i | sed 's/^dot//'`
    fi
done
exit 1

tmux new-session -d
tmux send-keys C-t I
sleep 1
tmux kill-server
