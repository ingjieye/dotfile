# ~/.zshenv —— 所有 zsh 进程都会加载:交互式、脚本、`zsh -c`。
# 只放纯环境变量和 PATH,保持轻量;交互体验配置在 .zshrc。

# ---------- PATH ----------
export PATH="/opt/homebrew/bin:$PATH"

# 用 zsh path 数组统一管理,typeset -U 自动去重
typeset -U path
path=(
    $HOME/.local/bin
    $HOME/.cargo/bin
    $HOME/bin
    $HOME/.yarn/bin
    $HOME/.config/yarn/global/node_modules/.bin
    /opt/homebrew/bin
    $path
)

# ---------- General ----------
export LC_ALL=en_US.UTF-8
export GOPATH=$HOME/go
export EDITOR=nvim
export MANPAGER='nvim +Man!'

path=($GOPATH/bin $path)

# JAVA_HOME: 按需启用(存在对应版本才启用)
_java_prefix="/opt/homebrew/Cellar/openjdk/23.0.2"
if [[ -d "$_java_prefix/libexec/openjdk.jdk/Contents/Home" ]]; then
    export JAVA_HOME="$_java_prefix/libexec/openjdk.jdk/Contents/Home"
    path=($JAVA_HOME/bin $path)
fi
unset _java_prefix

# ---------- proxy (ClashX Meta mixed-port) ----------
export {http,https,all,rsync}_proxy=http://127.0.0.1:7890
export {HTTP,HTTPS,ALL,RSYNC}_PROXY=http://127.0.0.1:7890

# 临时开关代理(仅影响当前 shell 及其后代)
unproxy() {
    unset {http,https,all,rsync}_proxy {HTTP,HTTPS,ALL,RSYNC}_PROXY no_proxy NO_PROXY
}
proxy() {
    export {http,https,all,rsync}_proxy=http://127.0.0.1:7890
    export {HTTP,HTTPS,ALL,RSYNC}_PROXY=http://127.0.0.1:7890
}

# ---------- brew (中科大源) ----------
# 备选清华源:
# export HOMEBREW_API_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles/api"
# export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles"
# export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"
# export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git"
# export HOMEBREW_PIP_INDEX_URL="https://pypi.tuna.tsinghua.edu.cn/simple"
export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.ustc.edu.cn/brew.git"
export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.ustc.edu.cn/homebrew-core.git"
export HOMEBREW_API_DOMAIN="https://mirrors.ustc.edu.cn/homebrew-bottles/api"
export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.ustc.edu.cn/homebrew-bottles"
export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_NO_INSTALLED_DEPENDENTS_CHECK=1

# ---------- misc env ----------
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

# ---------- OS specific ----------
if [[ "$(uname -s)" == "Darwin" ]]; then
    export DOCKER_HOST="unix://${HOME}/.colima/default/docker.sock"
    export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43'
fi

# 最终 PATH 清理:过滤不存在的目录
path=( ${^path}(N-/) )
