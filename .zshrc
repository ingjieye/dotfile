# ---------- Exports --------- {{{1
# ---------- General --------- {{{2
export LC_ALL=en_US.UTF-8
export GOPATH=$HOME/go
export EDITOR=nvim
export MANPAGER='nvim +Man!'

# PATH: 用 zsh path 数组统一管理，typeset -U 自动去重
typeset -U path
path=(
    $HOME/.local/bin
    $HOME/.cargo/bin
    $HOME/bin
    $HOME/.yarn/bin
    $HOME/.config/yarn/global/node_modules/.bin
    $GOPATH/bin
    /opt/homebrew/bin
    $path
)

# JAVA_HOME: 按需启用
if command -v /opt/homebrew/bin/brew &>/dev/null; then
    local _java_prefix="/opt/homebrew/Cellar/openjdk/23.0.2"
    if [[ -d "$_java_prefix/libexec/openjdk.jdk/Contents/Home" ]]; then
        export JAVA_HOME="$_java_prefix/libexec/openjdk.jdk/Contents/Home"
        path=($JAVA_HOME/bin $path)
    fi
fi

# ---------- brew --------- {{{2
if [[ "$(uname -s)" == "Linux" ]]; then BREW_TYPE="linuxbrew"; else BREW_TYPE="homebrew"; fi
# brew 清华源
# export HOMEBREW_API_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles/api"
# export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles"
# export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"
# export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git"
# export HOMEBREW_PIP_INDEX_URL="https://pypi.tuna.tsinghua.edu.cn/simple"

# brew 中科大源
export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.ustc.edu.cn/brew.git"
export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.ustc.edu.cn/homebrew-core.git"
export HOMEBREW_API_DOMAIN="https://mirrors.ustc.edu.cn/homebrew-bottles/api"
export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.ustc.edu.cn/homebrew-bottles"


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
setopt INC_APPEND_HISTORY   # 每条命令执行后立即追加到历史文件
setopt HIST_IGNORE_DUPS
setopt HIST_VERIFY          # 历史命令执行前先展示，确认后再执行
setopt EXTENDED_HISTORY      # 记录时间戳和执行时长
setopt SHARE_HISTORY         # 跨终端实时共享历史
bindkey -e

zstyle :compinstall filename "$HOME/.zshrc"
PROMPT=$'%F{blue}%F{CYAN}%B%F{cyan}%n %F{white}@ %F{magenta}%m %F{white}>>= %F{green}%~ %1(j,%F{red}:%j,)%b\n%F{blue}%B%(?..[%?] )%{%F{red}%}%# %F{white}%b'

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
    alias vim=nvim
fi
alias ll='ls -alh'
# alias python=python3.11
# alias python3=python3.11
# alias pip=pip3.11

# --- Git ---
alias gs='git status'
alias gc='git checkout'
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
        export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43'
        export DOCKER_HOST="unix://${HOME}/.colima/default/docker.sock"
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
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [[ ! -d "$ZINIT_HOME" ]]; then
    mkdir -p "$(dirname $ZINIT_HOME)"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "${ZINIT_HOME}/zinit.zsh"

zinit light zsh-users/zsh-completions

fpath=(~/.zsh/completions /opt/homebrew/share/zsh/site-functions $fpath)

# 清理失效的补全软链接，避免 compinit 读取到历史残留文件后报错。
() {
    local comp_dir="$HOME/.zsh/completions"
    local comp_dump="$HOME/.zcompdump"
    local repaired=0
    local completion_file

    [[ -d "$comp_dir" ]] || return 0

    for completion_file in "$comp_dir"/_*(N); do
        if [[ -L "$completion_file" && ! -e "$completion_file" ]]; then
            rm -f "$completion_file"
            repaired=1
        fi
    done

    if (( repaired )); then
        rm -f "$comp_dump" "${comp_dump}.zwc"
    fi
}

autoload -Uz compinit
compinit

zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.cache/zsh

zinit light Aloxaf/fzf-tab
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-syntax-highlighting

# 定期后台维护（不阻塞 shell 启动）
() {
    local stamp_dir="$HOME/.zsh/.stamps"
    mkdir -p "$stamp_dir"

    if [[ "$(uname -s)" == "Darwin" ]]; then
        _stale() { [[ ! -f "$1" ]] || (( $(date +%s) - $(stat -f%m "$1" 2>/dev/null || echo 0) > $2 )) }
    else
        _stale() { [[ ! -f "$1" ]] || (( $(date +%s) - $(stat -c%Y "$1" 2>/dev/null || echo 0) > $2 )) }
    fi

    # 每天：扫描并生成缺失的 zsh completions
    if _stale "$stamp_dir/completions" 86400; then
        { zsh-gen-completions >/dev/null 2>&1; touch "$stamp_dir/completions" } &!
    fi

    # 每周：更新 zinit 插件
    if _stale "$stamp_dir/zinit-update" 604800; then
        { zinit update --parallel --quiet >/dev/null 2>&1; touch "$stamp_dir/zinit-update" } &!
    fi
}

# Plug-in settings {{{1
# ----- fzf-tab ----- {{{2
# disable sort when completing options of any command
zstyle ':completion:complete:*:options' sort false

# set descriptions format to enable group support
# NOTE: don't use escape sequences (like '%F{red}%d%f') here, fzf-tab will ignore them
zstyle ':completion:*:descriptions' format '[%d]'

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

# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# give a preview of commandline arguments when completing `kill`
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm,cmd -w -w"
zstyle ':fzf-tab:complete:kill:argument-rest' extra-opts --preview=$extract'ps --pid=$in[(w)1] -o cmd --no-headers -w -w' --preview-window=down:3:wrap

# give a preview of directory by exa when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'

# }}}
#----- rbenv ----- {{{2
if command -v rbenv &> /dev/null; then 
    eval "$(rbenv init - zsh)"
fi

#nvm {{{4
#export NVM_DIR="$HOME/.nvm"
#[ -s "/usr/local/opt/nvm/nvm.sh" ] && \. "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
#[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

#----- lazygit ----- {{{2
# export AUTO_NOTIFY_IGNORE=(
# 'vim' 'nvim' 'less' 'more' 'man' 'tig' 'watch' 'git commit' 'top' 'htop' 'ssh' 'nano' 'vi' 'lazygit' 'scrcpy' 'lg'
# )

# Keymap {{{1
# Enable Ctrl-x-e to edit command line
autoload -U edit-command-line
# Emacs style
zle -N edit-command-line
bindkey '^xe' edit-command-line
bindkey '^x^e' edit-command-line

# opencode
[[ -d "$HOME/.opencode/bin" ]] && path=($HOME/.opencode/bin $path)

# tmux agent status wrapper for Codex.
# Keeps the normal `codex` command name while clearing tmux window prefixes on exit.
codex() {
    local wrapper="$HOME/bin/tmux-agent-hook/bin/codex-tmux-agent"
    if [[ -x "$wrapper" ]]; then
        "$wrapper" "$@"
    else
        command codex "$@"
    fi
}

# tmux agent status wrapper for Claude Code.
claude() {
    local wrapper="$HOME/bin/tmux-agent-hook/bin/claude-tmux-agent"
    if [[ -x "$wrapper" ]]; then
        "$wrapper" "$@"
    else
        command claude "$@"
    fi
}

# 最终 PATH 清理：过滤不存在的目录
path=( ${^path}(N-/) )

# >>> Claude Code Router CLI >>>
# Added by Claude Code Router. Enables the ccr command in new shells.
case ":$PATH:" in
  *":$HOME/.claude-code-router/bin:"*) ;;
  *) export PATH="$HOME/.claude-code-router/bin:$PATH" ;;
esac
# <<< Claude Code Router CLI <<<
