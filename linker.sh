#!/bin/bash

DOTFILES=$HOME/dotfiles

\rm -rf $HOME/.zsh $HOME/.vim
ln -s $DOTFILES/dot.zsh $HOME/.zsh
ln -s $DOTFILES/dot.vim $HOME/.vim

for i in $DOTFILES/dot.*; do
    if [ -f $i ]; then
        ln -sf $i $HOME/`basename $i | sed 's/^dot//'`
    fi
done
