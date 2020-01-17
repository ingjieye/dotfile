HISTFILE=~/.histfile
HISTSIZE=1000000
SAVEHIST=10000000
setopt HIST_IGNORE_DUPS
bindkey -e

source ~/.zsh/antigen.zsh
#antigen bundle zsh-users/zsh-syntax-highlighting
#antigen bundle zsh-users/zsh-autosuggestions
antigen apply

zstyle :compinstall filename '/home/yeyj/.zshrc'

PROMPT=$'%F{blue}%F{CYAN}%B%F{cyan}%n %F{white}@ %F{magenta}%m %F{white}>>= %F{green}%~ %1(j,%F{red}:%j,)%b\n%F{blue}%B%(?..[%?] )%{%F{red}%}%# %F{white}%b'

if [[ $UNAME = Linux ]]; then
  if [[ "$TERM" = *256color* && -f $HOME/.lscolor256 ]]; then
    eval $(dircolors -b ~/.lscolor256)
  else if [[ -f $HOME/.lscolor ]];
    eval $(dircolors -b ~/.lscolor)
  fi
fi

alias ls='ls --color=auto'

zstyle ':completion:*' list-colors "${(@s.:.)LS_COLORS}"
autoload -Uz compinit
compinit
#setopt AUTO_LIST
#setopt AUTO_MENU
#setopt MENU_COMPLETE
#setopt complete_in_word   # complete /v/c/a/p
#setopt no_nomatch  # enhanced bash wildcard completion
#setopt magic_equal_subst
#setopt noautoremoveslash
#setopt null_glob

export GOROOT=/usr/lib/go
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

alias go='http_proxy=http://192.168.10.23:8118 https_proxy=http://192.168.10.23:8118 go'
alias ..='cd ..'
alias ....='cd ../..'

function _cmakeSave(){
	\cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=YES "$@" && 
		echo `date` `pwd` >> ~/cmake_history.txt &&
	    echo "cmake $@" >> ~/cmake_history.txt
		echo "" >> ~/cmake_history.txt
}
alias cmake=_cmakeSave

# manpages colored
export LESS_TERMCAP_mb=$'\e[1;32m'
export LESS_TERMCAP_md=$'\e[1;32m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;4;31m'
export LESS_TERMCAP_so=$'\E[30;43m'

stty -ixon #防止 ctrl+s silent 当前 shell
set -o ignoreeof #防止ctrl+d kill 当前 shell
IGNOREEOF=100000000

alias m='make'
alias cm=cmake

if [[ -z "$TMUX" ]] && [ "$SSH_CONNECTION" != "" ]; then
    tmux attach-session|| tmux new-session
fi

export EDITOR=vim

alias socks5="http_proxy=http://192.168.10.23:8118 https_proxy=http://192.168.10.23:8118 all_proxy=http://192.168.10.23:8118 HTTP_PROXY=$https_proxy HTTPS_PROXY=$https_proxy ALL_PROXY=$all_proxy "
alias zh=LC_ALL=zh_CN.UTF-8

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

export HOMEBREW_NO_AUTO_UPDATE=1

export PATH="$HOME/.local/bin:$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$HOME/dev/source_code/webrtc/depot_tools:$PATH"


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Enable Ctrl-x-e to edit command line
autoload -U edit-command-line
# Emacs style
zle -N edit-command-line
bindkey '^xe' edit-command-line
bindkey '^x^e' edit-command-line

eval $(thefuck --alias)
