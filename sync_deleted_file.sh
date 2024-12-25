#!/bin/bash

# 获取删除的文件列表
deleted_files=$(git diff --name-only --diff-filter=D HEAD)

# 如果没有删除的文件，退出脚本
if [ -z "$deleted_files" ]; then
  echo "没有找到删除的文件。"
  exit 0
fi

# 列出所有待删除的文件路径
echo "以下文件将被删除："
for file in $deleted_files; do
  echo ~/"$file"
done

# 提示用户确认
read -p "你确定要删除这些文件吗？(y/n): " confirm

# 如果用户确认，删除文件
if [ "$confirm" = "y" ]; then
  for file in $deleted_files; do
    rm -f ~/"$file"
  done
  echo "同步删除完成"
else
  echo "操作已取消"
fi
