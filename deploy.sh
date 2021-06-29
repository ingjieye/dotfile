#!/bin/bash
set -e

# soft link each file to their relative directory
files=$(git ls-files |grep -v "deploy.sh")
for f in $files; do
    mkdir -p ~/`dirname $f`
    ln -sf $PWD/$f ~/`dirname $f`
done

install_brew() {
    if command -v brew &> /dev/null
    then
        echo 'brew exist. skip install'
        return
    fi

    echo 'Installing brew...'
    if [[ "$(uname -s)" == "Linux" ]]; then BREW_TYPE="linuxbrew"; else BREW_TYPE="homebrew"; fi
    export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"
    export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/${BREW_TYPE}-core.git"
    export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/${BREW_TYPE}-bottles"

    git clone --depth=1 https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/install.git brew-install
    /bin/bash brew-install/install.sh
    rm -rf brew-install

    echo 'Configuring tsinghua mirror'
    git -C "$(brew --repo homebrew/core)" remote set-url origin https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git
    git -C "$(brew --repo homebrew/cask)" remote set-url origin https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-cask.git
    git -C "$(brew --repo homebrew/cask-fonts)" remote set-url origin https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-cask-fonts.git
    git -C "$(brew --repo homebrew/cask-drivers)" remote set-url origin https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-cask-drivers.git
    git -C "$(brew --repo homebrew/cask-versions)" remote set-url origin https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-cask-versions.git
}

install_essentials_osx() {
    brew update
    brew instal fzf nvim node tmux
}

echo -e "System type: \c"
if [[ "$OSTYPE" == "linux-gnu" ]]; then
	echo "linux-gnu"
elif [[ "$OSTYPE" == "darwin"* ]]; then
	echo "drawin"
    install_brew
    install_essentials_osx
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
