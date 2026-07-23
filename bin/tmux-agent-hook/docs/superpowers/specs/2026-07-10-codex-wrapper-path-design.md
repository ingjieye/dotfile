# Codex tmux wrapper 路径修复设计

## 背景

Codex standalone 安装位于 `$HOME/.local/bin/codex`，当前版本为 `0.143.0`。交互式 zsh 中的 `codex()` 函数会调用 `bin/codex-tmux-agent`，但该 wrapper 将默认可执行文件固定为 `/opt/homebrew/bin/codex`，因此实际运行的是旧 npm 安装 `0.137.0`。

## 目标

- 让交互式 zsh 中的 `codex` 默认运行 standalone 安装。
- 保留 wrapper 退出时清理 tmux agent 状态的现有行为。
- 保留通过 `CODEX_BIN` 环境变量临时覆盖 Codex 路径的能力。

## 方案比较

1. 将 wrapper 默认路径固定为 `$HOME/.local/bin/codex`。行为确定，符合当前安装方式；采用此方案。
2. 在 wrapper 中通过 `PATH` 动态查找 `codex`。更灵活，但 PATH 顺序变化时可能再次命中旧安装。
3. 删除 zsh 中的 wrapper 函数。可以直接命中 standalone 安装，但会失去 Codex 退出时的 tmux 状态清理。

## 设计

仅修改 `bin/codex-tmux-agent` 中 `CODEX_BIN` 的默认值：

```bash
CODEX_BIN="${CODEX_BIN:-$HOME/.local/bin/codex}"
```

显式设置 `CODEX_BIN` 时仍优先使用用户提供的路径。wrapper 的信号处理、退出码传播和 tmux 状态清理逻辑均保持不变。不修改 `~/.zshrc`、PATH 或已有 npm 安装。

## 错误处理

如果默认路径不存在或不可执行，底层 shell 会返回执行失败，与当前 wrapper 对固定路径失效时的行为一致。本次不增加自动回退，避免静默运行另一套旧安装。

## 验证

1. 直接执行 `bin/codex-tmux-agent --version`，应输出 `codex-cli 0.143.0`。
2. 启动全新的交互式 zsh 并执行 `codex --version`，应输出 `codex-cli 0.143.0`。
3. 设置 `CODEX_BIN=/opt/homebrew/bin/codex` 后调用 wrapper，确认显式覆盖仍然生效。
4. 运行现有测试，确认 tmux 状态逻辑无回归。

## 非目标

- 不卸载或升级 `/opt/homebrew/bin/codex` 对应的旧 npm 包。
- 不改变 Claude Code wrapper。
- 不重构 tmux agent 状态脚本。
