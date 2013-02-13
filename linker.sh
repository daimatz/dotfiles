#!/bin/bash

\rm -rf $HOME/.zsh $HOME/.vim
ln -s $HOME/conf/dot.zsh $HOME/.zsh
ln -s $HOME/conf/dot.vim $HOME/.vim

for i in $HOME/conf/dot.*; do
    if [ -f $i ]; then
        ln -sf $i $HOME/`basename $i | sed 's/^dot//'`
    fi
done
