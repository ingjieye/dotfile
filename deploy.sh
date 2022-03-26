#!/bin/bash
set -e

# soft link each file to their relative directory
files=$(git ls-files |grep -v "deploy.sh")
for f in $files; do
    mkdir -p ~/`dirname $f`
    ln -sf $PWD/$f ~/`dirname $f`
done

