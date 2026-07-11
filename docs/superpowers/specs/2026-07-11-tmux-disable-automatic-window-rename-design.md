# 关闭 tmux 窗口自动重命名

## 目标

顶部状态栏中的 tmux 窗口名不再随当前工作目录变化，保留已有名称，并允许用户继续手动重命名窗口。

## 当前行为

- `.tmux.conf` 全局启用了 `automatic-rename`。
- 当前 tmux server 的 `automatic-rename-format` 是当前 pane 路径的 basename，因此执行 `cd` 后窗口名会变成目录名。
- pane 边框标题未显示，`allow-rename` 也已关闭；问题来自 tmux 自身的窗口自动重命名。

## 设计

仅将 `.tmux.conf` 中的：

```tmux
setw -g automatic-rename on
```

改为：

```tmux
setw -g automatic-rename off
```

不修改窗口状态栏格式、pane 配置、agent 状态 hook 或其他 tmux 选项。当前 server 中残留的 `automatic-rename-format` 可以保留，因为关闭自动重命名后它不会生效。

## 应用与验证

1. 重新加载 `~/.tmux.conf`，让当前 tmux server 立即采用新值。
2. 确认 `tmux show-options -gw automatic-rename` 输出 `automatic-rename off`。
3. 确认配置 diff 只包含目标行，未改动用户现有的其他未提交内容。

## 预期结果

- 切换目录不会再改变窗口名。
- 现有窗口名保持不变。
- `tmux rename-window` 等手动命名方式继续可用。
- 新启动的 tmux server 同样默认关闭窗口自动重命名。
