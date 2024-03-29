#!/bin/bash
echo "Deploying..."
set -e
SAVEIFS=$IFS   # Save current IFS (Internal Field Separator)
IFS=$'\n'      # Change IFS to newline char

skipPattern="deploy.sh|install.sh|README.md"
hardlinkPattern="Library/Application Support/Firefox/"
hardlinkPattern="$hardlinkPattern|Library/Fonts/"

# soft link each file except skipPattern and hardlinkPattern to their relative directory
files=( $(git ls-files |grep -vE "$skipPattern|$hardlinkPattern") )
for f in "${files[@]}"; do
    echo "soft linking ~/$f"
    mkdir -p ~/`dirname $f`
    ln -sf $PWD/$f ~/`dirname $f`
done

# hard link each hardlinkPattern file to their relative directory
files=( $(git ls-files |grep -E $hardlinkPattern) )
for f in "${files[@]}"; do
    echo "hard linking ~/$f"
    mkdir -p ~/`dirname $f`
    ln -f $PWD/$f ~/`dirname $f`
done

IFS=$SAVEIFS   # Restore original IFS
echo "Done"
