# ---------- Exports --------- {{{1
# ---------- General --------- {{{2
export LC_ALL=en_US.UTF-8
export GOPATH=$HOME/go

export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:/opt/homebrew/bin
export PATH="$HOME/bin:$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
export PATH="$HOME/Library/Python/3.8/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"

export EDITOR=vim

# ---------- brew --------- {{{2
if [[ "$(uname -s)" == "Linux" ]]; then BREW_TYPE="linuxbrew"; else BREW_TYPE="homebrew"; fi
# brew 清华源
export HOMEBREW_API_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles/api"
export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles"
export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"
export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git"
export HOMEBREW_PIP_INDEX_URL="https://pypi.tuna.tsinghua.edu.cn/simple"
#export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.aliyun.com/homebrew/homebrew-bottles"
export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_NO_INSTALLED_DEPENDENTS_CHECK=1

# ---------- others --------- {{{2
# manpages colored
export LESS_TERMCAP_mb=$'\e[1;32m'
export LESS_TERMCAP_md=$'\e[1;32m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;4;31m'
export LESS_TERMCAP_so=$'\E[30;43m'

export TLDR_AUTO_UPDATE_DISABLED=1
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --no-ignore --ignore-file ~/.fd-ignore'

# ---------- zsh settings --------- {{{1
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

stty -ixon #防止 ctrl+s silent 当前 shell
set -o ignoreeof #防止ctrl+d kill 当前 shell
IGNOREEOF=100000000

#if [[ -z "$TMUX" ]] && [ "$SSH_CONNECTION" != "" ]; then
if [[ "$TERM_PROGRAM" == "kitty" ]]; then
    if [[ -z "$TMUX" ]] && command -v tmux > /dev/null ; then
        tmux attach-session|| tmux new-session
    fi
fi

# FZF
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Enable Ctrl-x-e to edit command line
autoload -U edit-command-line
# Emacs style
zle -N edit-command-line
bindkey '^xe' edit-command-line
bindkey '^x^e' edit-command-line

# ---------- Aliases --------- {{{1
# --- General ---
function ..() {
  cd ..
}

function ../..() {
  cd ../..
}
alias socks5="http_proxy=http://192.168.1.204:8118 https_proxy=$http_proxy all_proxy=$http_proxy HTTP_PROXY=$https_proxy HTTPS_PROXY=$https_proxy ALL_PROXY=$all_proxy "
alias zh=LC_ALL=zh_CN.UTF-8
if command -v nvim &> /dev/null; then 
    alias vim=nvim; 
    export EDITOR=nvim
fi
alias ll='ls -alh'
alias python=python3
alias pip=pip3

# --- Git ---
alias gs='git status'
alias gc='git commit'
alias gp='git pull origin $(git rev-parse --abbrev-ref HEAD)'
alias gd='git diff'
alias ga='git add'
alias gl='git log'
alias lg=lazygit

# --- Adb ---
function _adb_export_and_connect() {
    export ANDROID_SERIAL=$1
    adb connect $ANDROID_SERIAL
}
alias x30='_adb_export_and_connect x30'
alias tc8='_adb_export_and_connect tc8'
alias tablet='_adb_export_and_connect tablet'
alias cu360='_adb_export_and_connect cu360'
alias s7='_adb_export_and_connect s7'


function enable_depot_tools()
{
    export PATH="$HOME/dev/source_code/depot_tools:$PATH"
    export PATH="$HOME/dev/source_code/depot_tools/python-bin:$PATH"
}

# OS specific settings {{{1
case "$OSTYPE" in
    darwin*)
        alias ls='ls -G '
        alias code='/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin/code'
        export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
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
        elif [[ -f $HOME/.lscolor ]]; then
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
#antigen bundle 'wfxr/forgit'
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

# }}}
#rbenv {{{3
if command -v rbenv &> /dev/null; then 
    eval "$(rbenv init - zsh)"
fi

#nvm {{{4
#export NVM_DIR="$HOME/.nvm"
#[ -s "/usr/local/opt/nvm/nvm.sh" ] && \. "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
#[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
# Functions {{{1
