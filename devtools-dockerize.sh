#!/bin/bash

# docker build -t devtools - < devtools.Dockerfile

mkdir -p $HOME/bin
cp devtools $HOME/bin
for i in \
    ag \
    global \
    gtags \
    jq \
    nkf \
    tig \
    ; do
    ln -sf $HOME/bin/devtools $HOME/bin/$i
done
