#!/bin/bash

set -ex

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

curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim +PlugInstall +PlugClean! +qall
(cd ~/.vim/plugged/vimproc && make)

mkdir -p $HOME/.local/share/code-server/User
ln -sf $DOTFILES/vscode/*.json $HOME/.local/share/code-server/User/
# code-server --list-extensions
cat << EOF | while read i; do code-server --install-extension $i; done
    daltonjorge.scala
    golang.go
    ms-vscode.cpptools
    redhat.java
    scala-lang.scala
    scalameta.metals
    vscjava.vscode-java-debug
    vscjava.vscode-java-dependency
    vscjava.vscode-java-pack
    vscjava.vscode-java-test
    vscjava.vscode-maven
    vscodevim.vim
EOF
