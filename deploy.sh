#!/bin/bash
set -e

sudo apt update && sudo apt install privoxy

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

if [ ! -f ~/.vim/autoload/plug.vim ]; then
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

# soft link each file to their relative directory
files=$(git ls-files)
for f in $files; do
    mkdir -p ~/`dirname $f`
    ln -sf $PWD/$f ~/`dirname $f`
done
