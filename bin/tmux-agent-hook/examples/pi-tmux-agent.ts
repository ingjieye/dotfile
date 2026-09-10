/**
 * tmux Agent Hook for pi
 *
 * Keeps the tmux window/session name for the pane running pi in sync with the
 * shared tmux-agent-hook state (⌛️ while the agent is working, ☑️ when done).
 *
 * Install (see README):
 *   mkdir -p ~/.pi/agent/extensions
 *   ln -sf ~/bin/tmux-agent-hook/examples/pi-tmux-agent.ts \
 *     ~/.pi/agent/extensions/pi-tmux-agent.ts
 *   # then run /reload in pi (or restart it)
 *
 * Lifecycle mapping:
 *   agent_start      -> mark-running   (user prompt starts an agent run)
 *   agent_settled    -> mark-done      (no retry/compaction/follow-up left)
 *   session_shutdown -> clear          (pi exits or the session is replaced)
 */

import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

const STATUS_SCRIPT =
	process.env.PI_TMUX_AGENT_STATUS ??
	process.env.TMUX_AGENT_STATUS ??
	"/Users/yeyj/bin/tmux-agent-hook/bin/tmux-agent-status";

export default function (pi: ExtensionAPI) {
	const run = async (action: string): Promise<void> => {
		try {
			await pi.exec(STATUS_SCRIPT, [action]);
		} catch {
			// Best-effort: hooks must never interrupt or break pi.
		}
	};

	pi.on("agent_start", () => void run("mark-running"));
	pi.on("agent_settled", () => void run("mark-done"));
	pi.on("session_shutdown", async () => {
		// Await so the prefix clears before pi's process exits.
		await run("clear");
	});
}