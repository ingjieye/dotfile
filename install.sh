#!/bin/bash
set -e
install_brew() {
    if command -v brew &> /dev/null
    then
        echo 'brew exist. skip install'
        return
    fi

    echo 'Installing brew...'
    if [[ "$(uname -s)" == "Linux" ]]; then BREW_TYPE="linuxbrew"; else BREW_TYPE="homebrew"; fi
    git clone --depth=1 https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/install.git brew-install
    /bin/bash brew-install/install.sh
    rm -rf brew-install
}

install_essentials_osx() {
    echo 'Installing essentials for osx...'
    brew update
    brew instal fzf nvim node tmux p7zip
    brew install oath-toolkit #Google 2 factor authentication
    brew install coreutils #realpath tool
    brew install tldr #tldr
    brew install rg #ripgrep
    brew install fd #https://github.com/chinanf-boy/fd-zh
    brew install git-delta #syntax hilighting pager
    brew install cmake conan ccache
    brew install plantuml #weirongxu/plantuml-previewer
    brew install golang
    go install golang.org/x/tools/gopls@latest #go LSP

    sudo gem install cocoapods
    sudo spctl --master-disable #alow unsigned application to run
    sudo pwpolicy -clearaccountpolicies #disable password length limit
}

install_essentials_linux() {
    if [ -n "$(uname -a | grep Ubuntu)" ]; then
        echo 'Installing essentials for Ubuntu...'
        apt install software-properties-common

        #nodejs(dependency of coc.nvim)
        curl -sL install-node.vercel.app/lts | bash

        #neovim ppa
        add-apt-repository ppa:neovim-ppa/unstable

        apt install -y neovim
        apt install -y ripgrep
        apt install -y fd-find
    fi
}

echo -e "System type: \c"
if [[ "$OSTYPE" == "linux-gnu" ]]; then
	echo "linux-gnu"
    install_essentials_linux
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
