#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Statistics variables
created_softlinks=0
created_hardlinks=0
skipped_existing=0
skipped_ignored=0
created_dirs=0
created_softlink_files=()
created_hardlink_files=()
created_dir_files=()

info() {
    echo -e "${BLUE}[INFO]${NC} $*"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $*"
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $*"
}

# Read pattern file, returns a non-matching pattern if file doesn't exist
read_patterns() {
    local file="$1"
    if [[ -f "$file" ]]; then
        paste -s -d '|' "$file"
    else
        echo "a^"  # A regex that matches no files
    fi
}

# Get file list from a specified directory
get_files() {
    local dir="$1"
    if [[ "$dir" == "." ]]; then
        # Root directory: exclude all content under private/, including the directory itself
        git ls-files --exclude-standard -oc --full-name | { grep -vE '^private(/|$)' || true; }
    elif [[ "$dir" == "private" ]]; then
        # private is a submodule, need to enter it to get files
        if [[ -d "private" ]]; then
            (cd private && git ls-files --exclude-standard -oc --full-name | sed 's|^|private/|')
        fi
    else
        # Other directories: get all files under the directory
        git ls-files --exclude-standard -oc --full-name "$dir/" | { grep . || true; }
    fi
}

# Handle deployment for a specified directory
deploy_directory() {
    local source_dir="$1"
    local target_prefix="$2"
    
    # Read configuration files
    local ignore_file="${source_dir:+$source_dir/}.dotignore"
    local hardlink_file="${source_dir:+$source_dir/}.dothardlink"
    
    local skip_pattern hardlink_pattern
    skip_pattern=$(read_patterns "$ignore_file")
    hardlink_pattern=$(read_patterns "$hardlink_file")
    
    # Get file list
    local files=()
    while IFS= read -r line; do
        [[ -n "$line" ]] && files+=("$line")
    done < <(get_files "$source_dir")
    
    if [[ ${#files[@]} -eq 0 ]]; then
        echo "  No files found"
        return
    fi
    
    local processed=0
    # Process each file
    for source_file in "${files[@]}"; do
        # Calculate target path
        local target_file="${source_file#$target_prefix}"
        local target_path="$HOME/$target_file"
        local source_path="$PWD/$source_file"
        
        # Check if should be skipped
        if [[ -n "$skip_pattern" && "$target_file" =~ ($skip_pattern) ]]; then
            ((skipped_ignored++))
            continue
        fi
        
        # Ensure target directory exists
        local target_dir
        target_dir=$(dirname "$target_path")
        if [[ ! -d "$target_dir" ]]; then
            mkdir -p "$target_dir"
            ((created_dirs++))
            created_dir_files+=("$target_dir")
        fi
        
        # Check if target already exists
        if [[ -e "$target_path" || -L "$target_path" ]]; then
            ((skipped_existing++))
            continue
        fi
        
        # Create link
        if [[ -n "$hardlink_pattern" && "$target_file" =~ ($hardlink_pattern) ]]; then
            ln "$source_path" "$target_path"
            ((created_hardlinks++))
            created_hardlink_files+=("$target_path")
        else
            ln -s "$source_path" "$target_path"
            ((created_softlinks++))
            created_softlink_files+=("$target_path")
        fi
        ((processed++))
    done
}

# Print final summary
print_summary() {
    echo -e "${GREEN}========== Deployment Complete ==========${NC}"
    echo -e "${GREEN}✓${NC} Created soft links: ${GREEN}$created_softlinks${NC}"
    if [[ ${#created_softlink_files[@]} -gt 0 ]]; then
        for file in "${created_softlink_files[@]}"; do
            echo -e "  ${GREEN}✓${NC} ${CYAN}$file${NC}"
        done
    fi
    echo -e "${GREEN}✓${NC} Created hard links: ${GREEN}$created_hardlinks${NC}"
    if [[ ${#created_hardlink_files[@]} -gt 0 ]]; then
        for file in "${created_hardlink_files[@]}"; do
            echo -e "  ${GREEN}✓${NC} ${CYAN}$file${NC}"
        done
    fi
    echo -e "${BLUE}ℹ${NC} Created directories: ${BLUE}$created_dirs${NC}"
    if [[ ${#created_dir_files[@]} -gt 0 ]]; then
        for file in "${created_dir_files[@]}"; do
            echo -e "  ${BLUE}ℹ${NC} ${CYAN}$file${NC}"
        done
    fi
    echo -e "${YELLOW}⚠${NC} Skipped existing: ${YELLOW}$skipped_existing${NC}"
    echo -e "${YELLOW}⚠${NC} Skipped ignored files: ${YELLOW}$skipped_ignored${NC}"
    echo -e "${GREEN}=====================================${NC}"
}

# Main program
main() {
    # Deploy root directory files
    deploy_directory "." ""
    
    # Deploy private directory files (if it exists)
    if [[ -d "private" ]]; then
        deploy_directory "private" "private/"
    fi
    
    print_summary
}

main "$@"
