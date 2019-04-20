#!/bin/bash
set -e

files=$(git ls-files)

if [ ! -f ~/.vim/autoload/plug.vim ]; then
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

# soft link each file to their relative directory
for f in $files; do
    mkdir -p ~/`dirname $f`
    ln -sf $PWD/$f ~/`dirname $f`
done