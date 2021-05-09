#!/bin/bash
set -e

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
    git clone --depth=1 https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/install.git brew-install
    /bin/bash brew-install/install.sh
    rm -rf brew-install
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
