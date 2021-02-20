#!/bin/bash

DOTFILES=$HOME/dotfiles

\rm -rf $HOME/.zsh $HOME/.vim
ln -s $DOTFILES/dot.zsh $HOME/.zsh
ln -s $DOTFILES/dot.peco $HOME/.peco

for i in $DOTFILES/dot.*; do
    if [ -f $i ]; then
        ln -sf $i $HOME/`basename $i | sed 's/^dot//'`
    fi
done

curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim +PluginInstall +qall
