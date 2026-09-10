# tmux Agent Hook

Small hook helper for Codex and Claude Code running inside tmux.

When an agent starts handling a prompt, the current tmux window and session names
are prefixed with `⌛️`. When the agent stops, the window prefix changes to `☑️`
and the session prefix is recomputed from tracked pane state in that session.

This intentionally does not run a poller. Only hook events update names.
It keeps pane-level state in `~/.cache/tmux-agent-hook/state.json`, so multiple
agents in the same tmux window or session do not overwrite each other.
After each state change, it refreshes the status line for every attached tmux
client so `status-right` counts update without waiting for another window redraw.

## Behavior

- `mark-running`: `node` -> `⌛️node`
- `mark-done`: `⌛️node` -> `☑️node`
- `mark-interrupted`: clear the current pane status, so an interrupted
  conversation does not leave `⌛️` or `☑️` behind.
- `clear`: clear the current pane status, for example `☑️node` -> `node`
- `refresh`: re-read live tmux pane locations and refresh affected window and
  session prefixes. Use this from tmux hooks when panes move.
- `status-right`: print `⌛️<running> ☑️<done>` for tmux `status-right`.
- Existing `⌛️` / `☑️` prefixes are replaced, not stacked.
- Session names are derived from tracked pane state: any running pane makes the
  session `⌛️`; otherwise any done pane makes it `☑️`; otherwise the session
  prefix is cleared.
- Agent counts are derived from the same tracked pane state. Panes cleared with
  `prefix + u` are removed from the state file, so they are not counted.
- If `TMUX_PANE` is missing, the script falls back to the current tmux pane;
  outside tmux it exits without changing anything.
- Split panes in the same tmux window share one `window_name`, so this marks the
  window that owns the current agent pane.

tmux displays windows as `index:name`, so a window shown as `6:node` becomes
`6:⌛️node` or `6:☑️node`.

## tmux pane movement

Agent lifecycle hooks do not fire when a pane is moved to another window or
broken out into its own window. Add these tmux hooks so the stored pane state is
reconciled with the live tmux layout after pane movement:

```tmux
set-hook -g window-layout-changed[90] 'run-shell -b "/Users/yeyj/dev/playground/tmux_agent_hook/bin/tmux-agent-status refresh"'
set-hook -g window-linked[90] 'run-shell -b "/Users/yeyj/dev/playground/tmux_agent_hook/bin/tmux-agent-status refresh"'
set-hook -g window-unlinked[90] 'run-shell -b "/Users/yeyj/dev/playground/tmux_agent_hook/bin/tmux-agent-status refresh"'
```

The numeric hook index keeps this entry from replacing your other hooks.

## tmux status-right

Add the status command immediately before the time segment in your `status-right`
format, keeping `[agent status] [time]` as separate groups:

```tmux
set -g status-right '[#(/Users/yeyj/dev/playground/tmux_agent_hook/bin/tmux-agent-status status-right)] [%H:%M]'
```

If your existing `status-right` already has date, battery, or style segments,
keep them and place this `#(...)` command directly to the left of the time.

## Codex

Add the snippet from [examples/codex-config.toml](examples/codex-config.toml)
to `~/.codex/config.toml`, then open `/hooks` in Codex and trust the new hooks.

Codex currently has no `SessionEnd` hook. To clear the prefix when the Codex
CLI exits, launch Codex through the wrapper:

```bash
bin/codex-tmux-agent
```

The wrapper runs normal `codex` and calls `tmux-agent-status clear` from a shell
`EXIT` trap. This is not a poller.

Codex does not emit a hook when Ctrl-C interrupts an in-flight turn. Add this
tmux binding so Ctrl-C clears only the current agent pane before forwarding
Ctrl-C to the application:

```tmux
bind-key -n C-c run-shell -b '/Users/yeyj/dev/playground/tmux_agent_hook/bin/tmux-agent-status mark-interrupted --pane "#{pane_id}"' \; send-keys C-c
```

To manually clear the current pane's agent status with prefix + u:

```tmux
bind-key u run-shell -b '/Users/yeyj/dev/playground/tmux_agent_hook/bin/tmux-agent-status clear --pane "#{pane_id}"'
```

## Claude Code

Merge the hook entries from
[examples/claude-settings.fragment.json](examples/claude-settings.fragment.json)
into `~/.claude/settings.json`.

`Stop` fires whenever the turn ends, even if the assistant is only waiting on
a background subagent (e.g. a forked agent) to notify it later. The
`SubagentStart`/`SubagentStop` hooks track a per-pane count of subagents that
are still running, so `mark-done` from `Stop` is skipped while that count is
above zero — the pane stays `⌛️` until the subagent actually finishes and the
follow-up turn's own `Stop` fires.

To clear the prefix when the Claude Code CLI exits, launch Claude through the
wrapper:

```bash
bin/claude-tmux-agent
```

## pi

Install the extension from [examples/pi-tmux-agent.ts](examples/pi-tmux-agent.ts)
into pi's auto-discovered extensions directory:

```bash
mkdir -p ~/.pi/agent/extensions
ln -sf ~/bin/tmux-agent-hook/examples/pi-tmux-agent.ts \
  ~/.pi/agent/extensions/pi-tmux-agent.ts
```

Then reload extensions in a running pi session with `/reload`, or restart pi.

The extension maps pi lifecycle events to the shared hook script:

| pi event          | action         |
|-------------------|----------------|
| `agent_start`     | `mark-running` |
| `agent_settled`   | `mark-done`    |
| `session_shutdown`| `clear`        |

`agent_settled` fires only after auto-retry, auto-compaction, and queued
follow-ups finish, so the window flips to ☑️ only once pi is truly idle. pi's
`session_shutdown` fires on exit and session replacement, so no wrapper is
required to clear the prefix.

Override the status script path with `PI_TMUX_AGENT_STATUS` (or
`TMUX_AGENT_STATUS`) if it lives elsewhere.

## Manual Check

```bash
bin/tmux-agent-status mark-running
bin/tmux-agent-status mark-done
bin/tmux-agent-status mark-interrupted
bin/tmux-agent-status clear
bin/tmux-agent-status refresh
bin/tmux-agent-status status-right
```
