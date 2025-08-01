#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# 统计变量
created_softlinks=0
created_hardlinks=0
skipped_existing=0
skipped_ignored=0
created_dirs=0

info() {
    echo -e "${BLUE}[INFO]${NC} $*"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $*"
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $*"
}

# 读取模式文件，如果不存在返回不匹配任何文件的模式
read_patterns() {
    local file="$1"
    if [[ -f "$file" ]]; then
        paste -s -d '|' "$file"
    else
        echo "a^"  # 不匹配任何文件的正则表达式
    fi
}

# 获取指定目录下的文件列表
get_files() {
    local dir="$1"
    if [[ "$dir" == "." ]]; then
        # 根目录：排除 private/ 目录下的所有内容，包括 private 目录本身
        git ls-files --exclude-standard -oc --full-name | { grep -vE '^private(/|$)' || true; }
    elif [[ "$dir" == "private" ]]; then
        # private 是 submodule，需要进入目录内部获取文件
        if [[ -d "private" ]]; then
            (cd private && git ls-files --exclude-standard -oc --full-name | sed 's|^|private/|')
        fi
    else
        # 其他目录：获取该目录下的所有文件
        git ls-files --exclude-standard -oc --full-name "$dir/" | { grep . || true; }
    fi
}

# 处理指定目录的部署
deploy_directory() {
    local source_dir="$1"
    local target_prefix="$2"
    local display_name="$3"
    
    # 读取配置文件
    local ignore_file="${source_dir:+$source_dir/}.dotignore"
    local hardlink_file="${source_dir:+$source_dir/}.dothardlink"
    
    local skip_pattern hardlink_pattern
    skip_pattern=$(read_patterns "$ignore_file")
    hardlink_pattern=$(read_patterns "$hardlink_file")
    
    # 获取文件列表
    local files=()
    while IFS= read -r line; do
        [[ -n "$line" ]] && files+=("$line")
    done < <(get_files "$source_dir")
    
    if [[ ${#files[@]} -eq 0 ]]; then
        echo "  没有找到文件"
        return
    fi
    
    local processed=0
    # 处理每个文件
    for source_file in "${files[@]}"; do
        # 计算目标路径
        local target_file="${source_file#$target_prefix}"
        local target_path="$HOME/$target_file"
        local source_path="$PWD/$source_file"
        
        # 检查是否需要跳过
        if [[ -n "$skip_pattern" && "$target_file" =~ ($skip_pattern) ]]; then
            ((skipped_ignored++))
            continue
        fi
        
        # 确保目标目录存在
        local target_dir
        target_dir=$(dirname "$target_path")
        if [[ ! -d "$target_dir" ]]; then
            mkdir -p "$target_dir"
            ((created_dirs++))
        fi
        
        # 检查目标是否已存在
        if [[ -e "$target_path" || -L "$target_path" ]]; then
            ((skipped_existing++))
            continue
        fi
        
        # 创建链接
        if [[ -n "$hardlink_pattern" && "$target_file" =~ ($hardlink_pattern) ]]; then
            ln "$source_path" "$target_path"
            ((created_hardlinks++))
        else
            ln -s "$source_path" "$target_path"
            ((created_softlinks++))
        fi
        ((processed++))
    done
}

# 打印最终统计
print_summary() {
    echo -e "${GREEN}========== 部署完成 ==========${NC}"
    echo -e "${GREEN}✓${NC} 创建软链接: ${GREEN}$created_softlinks${NC} 个"
    echo -e "${GREEN}✓${NC} 创建硬链接: ${GREEN}$created_hardlinks${NC} 个"
    echo -e "${BLUE}ℹ${NC} 创建目录: ${BLUE}$created_dirs${NC} 个"
    echo -e "${YELLOW}⚠${NC} 跳过已存在: ${YELLOW}$skipped_existing${NC} 个"
    echo -e "${YELLOW}⚠${NC} 跳过忽略文件: ${YELLOW}$skipped_ignored${NC} 个"
    echo -e "${GREEN}============================${NC}"
}

# 主程序
main() {
    # 部署根目录文件
    deploy_directory "." "" "根目录"
    
    # 部署 private 目录文件（如果存在）
    if [[ -d "private" ]]; then
        deploy_directory "private" "private/" "private 目录"
    fi
    
    print_summary
}

main "$@"
