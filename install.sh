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

    local packages=(
        fzf nvim node tmux p7zip
        bat              # color previewer for fzf
        eza              # ls alternative
        oath-toolkit     # Google 2 factor authentication
        coreutils        # realpath, dircolors
        tldr
        rbenv            # ruby version manager
        ripgrep
        fd               # https://github.com/chinanf-boy/fd-zh
        git-delta        # syntax highlighting pager
        cmake conan@1 ccache ninja
        plantuml         # weirongxu/plantuml-previewer
        golang
        wget
        m1ddc            # control external monitor through cli
        jesseduffield/lazygit/lazygit
    )

    for pkg in "${packages[@]}"; do
        echo "Installing $pkg..."
        brew install "$pkg" || echo "WARNING: failed to install $pkg"
    done

    ~/.tmux/plugins/tpm/bin/install_plugins

    go install golang.org/x/tools/gopls@latest

    sudo gem install cocoapods
    sudo spctl --master-disable
    sudo pwpolicy -clearaccountpolicies

    brew install --cask "font-caskaydia-cove-nerd-font"
}

install_essentials_linux() {
    if [ -n "$(uname -a | grep Ubuntu)" ]; then
        echo 'Installing essentials for Ubuntu...'
        apt install software-properties-common

        #nodejs(dependency of coc.nvim)
        curl -sL install-node.vercel.app/lts | bash

        #neovim ppa
        add-apt-repository ppa:neovim-ppa/stable

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
