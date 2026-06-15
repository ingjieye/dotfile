#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

DOTFILE_DIR="$PWD"

read_patterns() {
    local file="$1"
    if [[ -f "$file" ]]; then
        paste -s -d '|' "$file"
    else
        echo "a^"
    fi
}

get_files() {
    local dir="$1"
    if [[ "$dir" == "." ]]; then
        git ls-files --exclude-standard -oc --full-name | { grep -vE '^private(/|$)' || true; }
    elif [[ "$dir" == "private" ]]; then
        if [[ -d "private" ]]; then
            (cd private && git ls-files --exclude-standard -oc --full-name | sed 's|^|private/|')
        fi
    fi
}

# --- deploy ---

deploy_created_softlinks=0
deploy_created_hardlinks=0
deploy_skipped_existing=0
deploy_skipped_ignored=0
deploy_created_dirs=0
deploy_softlink_files=()
deploy_hardlink_files=()
deploy_dir_files=()

deploy_directory() {
    local source_dir="$1"
    local target_prefix="$2"

    local ignore_file="${source_dir:+$source_dir/}.dotignore"
    local hardlink_file="${source_dir:+$source_dir/}.dothardlink"

    local skip_pattern hardlink_pattern
    skip_pattern=$(read_patterns "$ignore_file")
    hardlink_pattern=$(read_patterns "$hardlink_file")

    local files=()
    while IFS= read -r line; do
        [[ -n "$line" ]] && files+=("$line")
    done < <(get_files "$source_dir")

    if [[ ${#files[@]} -eq 0 ]]; then
        echo "  No files found"
        return
    fi

    for source_file in "${files[@]}"; do
        local target_file="${source_file#$target_prefix}"
        local target_path="$HOME/$target_file"
        local source_path="$DOTFILE_DIR/$source_file"

        if [[ -n "$skip_pattern" && "$target_file" =~ ($skip_pattern) ]]; then
            ((deploy_skipped_ignored++))
            continue
        fi

        local target_dir
        target_dir=$(dirname "$target_path")
        if [[ ! -d "$target_dir" ]]; then
            mkdir -p "$target_dir"
            ((deploy_created_dirs++))
            deploy_dir_files+=("$target_dir")
        fi

        if [[ -e "$target_path" || -L "$target_path" ]]; then
            ((deploy_skipped_existing++))
            continue
        fi

        if [[ -n "$hardlink_pattern" && "$target_file" =~ ($hardlink_pattern) ]]; then
            ln "$source_path" "$target_path"
            ((deploy_created_hardlinks++))
            deploy_hardlink_files+=("$target_path")
        else
            ln -s "$source_path" "$target_path"
            ((deploy_created_softlinks++))
            deploy_softlink_files+=("$target_path")
        fi
    done
}

cmd_deploy() {
    deploy_directory "." ""
    if [[ -d "private" ]]; then
        deploy_directory "private" "private/"
    fi

    echo -e "${GREEN}========== Deployment Complete ==========${NC}"
    echo -e "${GREEN}✓${NC} Created soft links: ${GREEN}$deploy_created_softlinks${NC}"
    for file in "${deploy_softlink_files[@]+"${deploy_softlink_files[@]}"}"; do
        echo -e "  ${GREEN}✓${NC} ${CYAN}$file${NC}"
    done
    echo -e "${GREEN}✓${NC} Created hard links: ${GREEN}$deploy_created_hardlinks${NC}"
    for file in "${deploy_hardlink_files[@]+"${deploy_hardlink_files[@]}"}"; do
        echo -e "  ${GREEN}✓${NC} ${CYAN}$file${NC}"
    done
    echo -e "${BLUE}ℹ${NC} Created directories: ${BLUE}$deploy_created_dirs${NC}"
    for file in "${deploy_dir_files[@]+"${deploy_dir_files[@]}"}"; do
        echo -e "  ${BLUE}ℹ${NC} ${CYAN}$file${NC}"
    done
    echo -e "${YELLOW}⚠${NC} Skipped existing: ${YELLOW}$deploy_skipped_existing${NC}"
    echo -e "${YELLOW}⚠${NC} Skipped ignored files: ${YELLOW}$deploy_skipped_ignored${NC}"
    echo -e "${GREEN}=====================================${NC}"
}

# --- check ---

check_missing=0
check_wrong=0
check_ok=0

check_directory() {
    local source_dir="$1"
    local target_prefix="$2"

    local ignore_file="${source_dir:+$source_dir/}.dotignore"
    local hardlink_file="${source_dir:+$source_dir/}.dothardlink"

    local skip_pattern hardlink_pattern
    skip_pattern=$(read_patterns "$ignore_file")
    hardlink_pattern=$(read_patterns "$hardlink_file")

    local files=()
    while IFS= read -r line; do
        [[ -n "$line" ]] && files+=("$line")
    done < <(get_files "$source_dir")

    for source_file in "${files[@]}"; do
        local target_file="${source_file#$target_prefix}"
        local target_path="$HOME/$target_file"
        local source_path="$DOTFILE_DIR/$source_file"

        if [[ -n "$skip_pattern" && "$target_file" =~ ($skip_pattern) ]]; then
            continue
        fi

        local is_hardlink=false
        if [[ -n "$hardlink_pattern" && "$target_file" =~ ($hardlink_pattern) ]]; then
            is_hardlink=true
        fi

        if [[ "$is_hardlink" == true ]]; then
            if [[ ! -e "$target_path" ]]; then
                echo -e "${RED}[MISSING]${NC} $target_file"
                ((check_missing++))
            elif [[ "$(stat -f %i "$source_path")" != "$(stat -f %i "$target_path")" ]]; then
                echo -e "${YELLOW}[WRONG]${NC}  $target_file (not hard-linked to dotfile)"
                ((check_wrong++))
            else
                ((check_ok++))
            fi
        else
            if [[ ! -L "$target_path" ]]; then
                if [[ -e "$target_path" ]]; then
                    echo -e "${YELLOW}[WRONG]${NC}  $target_file (exists but not a symlink)"
                    ((check_wrong++))
                else
                    echo -e "${RED}[MISSING]${NC} $target_file"
                    ((check_missing++))
                fi
            else
                local actual_target
                actual_target=$(readlink "$target_path")
                if [[ "$actual_target" != "$source_path" ]]; then
                    echo -e "${YELLOW}[WRONG]${NC}  $target_file (symlink -> $actual_target)"
                    ((check_wrong++))
                else
                    ((check_ok++))
                fi
            fi
        fi
    done
}

cmd_check() {
    check_directory "." ""
    if [[ -d "private" ]]; then
        check_directory "private" "private/"
    fi

    echo ""
    echo -e "${GREEN}OK: $check_ok${NC}  ${YELLOW}Wrong: $check_wrong${NC}  ${RED}Missing: $check_missing${NC}"
    if [[ $((check_missing + check_wrong)) -eq 0 ]]; then
        echo -e "${GREEN}All dotfiles are properly linked.${NC}"
    else
        exit 1
    fi
}

# --- main ---

usage() {
    echo "Usage: $(basename "$0") [deploy|check]"
    echo "  deploy  Create symlinks/hardlinks to \$HOME (default)"
    echo "  check   Verify all dotfiles are properly linked"
}

case "${1:-deploy}" in
    deploy) cmd_deploy ;;
    check)  cmd_check ;;
    -h|--help) usage ;;
    *) usage; exit 1 ;;
esac
