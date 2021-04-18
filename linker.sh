#!/bin/bash

DOTFILES=$HOME/dotfiles

for i in .zsh .peco; do
  \rm -rf $HOME/$i
  ln -s $DOTFILES/dot$i $HOME/$i
done

for i in $DOTFILES/dot.*; do
    if [ -f $i ]; then
        ln -sf $i $HOME/`basename $i | sed 's/^dot//'`
    fi
done

mkdir -p $HOME/.local/share/code-server/User
ln -sf $DOTFILES/vscode/*.json $HOME/.local/share/code-server/User/

curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim +PlugInstall +PlugClean! +qall
(cd ~/.vim/plugged/vimproc && make)
