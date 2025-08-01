#!/bin/zsh

OUTPUT_FILE="$HOME/current_wifi_ssid.txt"

current_ssid=$(for i in ${(o)$(ifconfig -lX "en[0-9]")};do ipconfig getsummary ${i} | awk '/ SSID/ {print $NF}';done 2> /dev/null)

# 检查 current_ssid 变量是否为空
# -n "$string"  --  如果字符串 "$string" 的长度不为零，则为真
if [ -n "$current_ssid" ]; then
    # 如果 SSID 不为空，说明已连接到 WiFi
    echo "成功获取 WiFi 名称: $current_ssid"
    echo "正在将名称写入到文件: $OUTPUT_FILE"
    
    # 将 SSID 写入到指定文件，> 会覆盖文件原有内容
    echo "$current_ssid" > "$OUTPUT_FILE"
    
    echo "操作完成。"
else
    # 如果 SSID 为空，说明 WiFi 未连接或已关闭
    echo "错误：未能获取 WiFi 名称。请检查你的 WiFi 是否已连接。"
    # 在这种情况下，我们不修改输出文件，并以非零状态码退出，表示有错误发生
    exit 1
fi

# 以状态码 0 正常退出
exit 0
