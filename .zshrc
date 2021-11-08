# zsh settings {{{1
HISTFILE=~/.histfile
HISTSIZE=1000000
SAVEHIST=10000000
setopt HIST_IGNORE_DUPS
bindkey -e

zstyle :compinstall filename '/home/yeyj/.zshrc'
PROMPT=$'%F{blue}%F{CYAN}%B%F{cyan}%n %F{white}@ %F{magenta}%m %F{white}>>= %F{green}%~ %1(j,%F{red}:%j,)%b\n%F{blue}%B%(?..[%?] )%{%F{red}%}%# %F{white}%b'

zstyle ':completion:*' list-colors "${(@s.:.)LS_COLORS}"
autoload -Uz compinit
compinit

function _cmakeSave() {
	\cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=YES "$@" && 
		echo `date` `pwd` >> ~/cmake_history.txt &&
	    echo "cmake $@" >> ~/cmake_history.txt
		echo "" >> ~/cmake_history.txt
}

stty -ixon #防止 ctrl+s silent 当前 shell
set -o ignoreeof #防止ctrl+d kill 当前 shell
IGNOREEOF=100000000

#if [[ -z "$TMUX" ]] && [ "$SSH_CONNECTION" != "" ]; then
if [[ -z "$TMUX" ]] ; then
    tmux attach-session|| tmux new-session
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Enable Ctrl-x-e to edit command line
autoload -U edit-command-line
# Emacs style
zle -N edit-command-line
bindkey '^xe' edit-command-line
bindkey '^x^e' edit-command-line

# Exports {{{1
export LC_ALL=en_US.UTF-8
export GOROOT=/usr/lib/go
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin
if [[ "$(uname -s)" == "Linux" ]]; then BREW_TYPE="linuxbrew"; else BREW_TYPE="homebrew"; fi
#export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"
#export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/${BREW_TYPE}-core.git"
#export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/${BREW_TYPE}-bottles"

    # manpages colored
export LESS_TERMCAP_mb=$'\e[1;32m'
export LESS_TERMCAP_md=$'\e[1;32m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;4;31m'
export LESS_TERMCAP_so=$'\E[30;43m'
export EDITOR=vim
export HOMEBREW_NO_AUTO_UPDATE=1
export PATH="$HOME/bin:$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$HOME/dev/source_code/webrtc/depot_tools:$PATH"
export PATH="$HOME/dev/source_code/depot_tools:$PATH"
export PATH="~/Library/Python/3.8/bin:$PATH"
export PATH="~/.cargo/bin:$PATH"
#export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'

# Aliases {{{1
alias ..='cd ..'
alias ....='cd ../..'
alias socks5="http_proxy=http://192.168.1.204:8118 https_proxy=$http_proxy all_proxy=$http_proxy HTTP_PROXY=$https_proxy HTTPS_PROXY=$https_proxy ALL_PROXY=$all_proxy "
alias zh=LC_ALL=zh_CN.UTF-8
# git alias
alias gs='git status'
alias gc='git checkout'
alias gp='git pull origin $(git rev-parse --abbrev-ref HEAD)' 
#alias wget='socks5 wget'
if command -v nvim &> /dev/null; then alias vim=nvim; fi
alias ll='ls -lh'
#alias m='make'
#alias cm=cmake
#alias cmake=_cmakeSave
function _adb_export_and_connect() {
    export ANDROID_SERIAL=$1
    adb connect $ANDROID_SERIAL
}
alias x30='_adb_export_and_connect x30'
alias tc8='_adb_export_and_connect tc8'
alias tablet='_adb_export_and_connect tablet'
alias cu360='_adb_export_and_connect cu360'

# OS specific settings {{{1
case "$OSTYPE" in
    darwin*)
        alias ls='ls -G '

    ;;
    linux*)
        function brew_enable() {
            BREW='/home/linuxbrew/.linuxbrew'
            brew_disable
            export PATH="$BREW/bin:$BREW/sbin:$PATH"
            export MANPATH="$BREW/share/man:$MANPATH"
            export INFOPATH="$BREW/share/info:$INFOPATH"
            export HOMEBREW_NO_AUTO_UPDATE=1
        }

        function brew_disable() {
            export PATH=${PATH##*"/.linuxbrew/bin:"}
            export PATH=${PATH##*"/.linuxbrew/sbin:"}
            export MANPATH=${MANPATH##*"/.linuxbrew/share/man:"}
            export INFOPATH=${INFOPATH##*"/.linuxbrew/share/info:"}
        }

        function brew() {
            PATH="/home/linuxbrew/.linuxbrew/bin:$PATH" /home/linuxbrew/.linuxbrew/bin/brew "$@"
        }

        # ls colors
        if [[ "$TERM" = *256color* && -f $HOME/.lscolor256 ]]; then
          eval $(dircolors -b ~/.lscolor256)
        else if [[ -f $HOME/.lscolor ]];
          eval $(dircolors -b ~/.lscolor)
        fi
        alias ls='ls --color=auto'
    ;;
    dragonfly*|freebsd*|netbsd*|openbsd*)
    ;;
esac
# Plug-in {{{1
source ~/.zsh/antigen.zsh
antigen bundle Aloxaf/fzf-tab
antigen bundle 'wfxr/forgit'
antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions
antigen apply
# Plug-in settings {{{2
#fzf-tab {{{3
# disable sort when completing options of any command
zstyle ':completion:complete:*:options' sort false

# use input as query string when completing zlua
zstyle ':fzf-tab:complete:_zlua:*' query-string input

# (experimental, may change in the future)
# some boilerplate code to define the variable `extract` which will be used later
# please remember to copy them
local extract="
# trim input(what you select)
local in=\${\${\"\$(<{f})\"%\$'\0'*}#*\$'\0'}
# get ctxt for current completion(some thing before or after the current word)
local -A ctxt=(\"\${(@ps:\2:)CTXT}\")
# real path
local realpath=\${ctxt[IPREFIX]}\${ctxt[hpre]}\$in
realpath=\${(Qe)~realpath}
"

# give a preview of commandline arguments when completing `kill`
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm,cmd -w -w"
zstyle ':fzf-tab:complete:kill:argument-rest' extra-opts --preview=$extract'ps --pid=$in[(w)1] -o cmd --no-headers -w -w' --preview-window=down:3:wrap

# give a preview of directory by exa when completing cd
zstyle ':fzf-tab:complete:cd:*' extra-opts --preview=$extract'exa -1 --color=always $realpath'
