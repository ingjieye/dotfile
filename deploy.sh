#!/bin/bash
set -e

# tmux plugin manager
if [ ! -d ~/.tmux/plugins/tpm ]; then
	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

 #vim plugin manager
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

echo -e "OS type: \c"
if [[ "$OSTYPE" == "linux-gnu" ]]; then
	echo "linux-gnu"
elif [[ "$OSTYPE" == "darwin"* ]]; then
	echo "drawin"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
elif [[ "$OSTYPE" == "cygwin" ]]; then
    echo "cygin"
elif [[ "$OSTYPE" == "msys" ]]; then
    echo "msys"
elif [[ "$OSTYPE" == "win32" ]]; then
    echo "win32"
elif [[ "$OSTYPE" == "freebsd"* ]]; then
    echo "freebsd"
else
    echo "unknow: $OSTYPE"
fi
