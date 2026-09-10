import importlib.machinery
import importlib.util
import os
import sys
import unittest
from pathlib import Path
from unittest.mock import call, patch


SCRIPT = Path(__file__).resolve().parents[1] / "bin" / "tmux-agent-status"
LOADER = importlib.machinery.SourceFileLoader("tmux_agent_status", str(SCRIPT))
SPEC = importlib.util.spec_from_loader("tmux_agent_status", LOADER)
MODULE = importlib.util.module_from_spec(SPEC)
assert SPEC.loader is not None
sys.modules[SPEC.name] = MODULE
SPEC.loader.exec_module(MODULE)


class TmuxAgentStatusTest(unittest.TestCase):
    def test_strip_status_prefix_removes_known_prefixes(self):
        self.assertEqual(MODULE.strip_status_prefix("⌛️node"), "node")
        self.assertEqual(MODULE.strip_status_prefix("⌛ node"), "node")
        self.assertEqual(MODULE.strip_status_prefix("☑️node"), "node")
        self.assertEqual(MODULE.strip_status_prefix("☑ node"), "node")

    def test_prefixed_name_replaces_existing_prefix(self):
        self.assertEqual(
            MODULE.prefixed_name("⌛️node", MODULE.DONE_PREFIX),
            "☑️node",
        )
        self.assertEqual(
            MODULE.prefixed_name("☑️ node", MODULE.RUNNING_PREFIX),
            "⌛️node",
        )

    def test_name_status(self):
        self.assertEqual(MODULE.name_status("⌛️node"), "running")
        self.assertEqual(MODULE.name_status("⌛ node"), "running")
        self.assertEqual(MODULE.name_status("☑️node"), "done")
        self.assertEqual(MODULE.name_status("☑ node"), "done")
        self.assertIsNone(MODULE.name_status("node"))

    def test_session_prefix_for_window_names_prefers_running(self):
        self.assertEqual(
            MODULE.session_prefix_for_window_names(["☑️api", "⌛️node"]),
            MODULE.RUNNING_PREFIX,
        )
        self.assertEqual(
            MODULE.session_prefix_for_window_names(["☑️api", "node"]),
            MODULE.DONE_PREFIX,
        )
        self.assertIsNone(MODULE.session_prefix_for_window_names(["api", "node"]))

    def test_prefix_for_statuses_prefers_running(self):
        self.assertEqual(
            MODULE.prefix_for_statuses(["done", "running"]),
            MODULE.RUNNING_PREFIX,
        )
        self.assertEqual(MODULE.prefix_for_statuses(["done"]), MODULE.DONE_PREFIX)
        self.assertIsNone(MODULE.prefix_for_statuses([]))

    def test_agent_status_counts_counts_running_and_done_panes(self):
        state = {
            "panes": {
                "%1": {"status": "running"},
                "%2": {"status": "done"},
                "%3": {"status": "done"},
                "%4": {"status": "idle"},
                "%5": "not-a-dict",
            }
        }

        self.assertEqual(MODULE.agent_status_counts(state), (1, 2))

    def test_format_agent_status_includes_running_and_done_counts(self):
        state = {
            "panes": {
                "%1": {"status": "running"},
                "%2": {"status": "done"},
            }
        }

        self.assertEqual(
            MODULE.format_agent_status(state),
            f"{MODULE.RUNNING_PREFIX}1 {MODULE.DONE_PREFIX}1",
        )

    def test_normalize_pane_id(self):
        self.assertEqual(MODULE.normalize_pane_id("%42\n"), "%42")
        self.assertEqual(MODULE.normalize_pane_id("42\n"), "%42")
        self.assertEqual(MODULE.normalize_pane_id(""), "")

    def test_default_pane_id_prefers_tmux_pane_env(self):
        with patch.dict(os.environ, {"TMUX_PANE": "%7", "TMUX": "socket"}, clear=False):
            self.assertEqual(MODULE.default_pane_id(), "%7")

    def test_default_pane_id_falls_back_to_tmux_display_message(self):
        class Result:
            returncode = 0
            stdout = "42\n"

        with patch.dict(os.environ, {"TMUX": "socket"}, clear=False):
            with patch.dict(os.environ, {"TMUX_PANE": ""}, clear=False):
                with patch.object(MODULE, "run_tmux", return_value=Result()):
                    self.assertEqual(MODULE.default_pane_id(), "%42")

    def test_desired_name_from_prefix(self):
        self.assertEqual(
            MODULE.desired_name_from_prefix("☑️Playground", MODULE.RUNNING_PREFIX),
            "⌛️Playground",
        )
        self.assertEqual(MODULE.desired_name_from_prefix("⌛️node", None), "node")

    def test_mark_interrupted_clears_current_pane_state(self):
        target = MODULE.TmuxTarget(
            pane_id="%1",
            session_id="$1",
            session_name="⌛️dev",
            window_id="@1",
            window_name="⌛️node",
        )
        state = {
            "panes": {
                "%1": {"session_id": "$1", "window_id": "@1", "status": "running"},
                "%2": {"session_id": "$1", "window_id": "@2", "status": "done"},
            }
        }

        MODULE.apply_state_action("mark-interrupted", target, state)

        self.assertNotIn("%1", state["panes"])
        self.assertIn("%2", state["panes"])
        self.assertEqual(MODULE.agent_status_counts(state), (0, 1))

    def test_clear_clears_current_pane_state(self):
        target = MODULE.TmuxTarget(
            pane_id="%1",
            session_id="$1",
            session_name="☑️dev",
            window_id="@1",
            window_name="☑️node",
        )
        state = {
            "panes": {
                "%1": {"session_id": "$1", "window_id": "@1", "status": "done"},
                "%2": {"session_id": "$1", "window_id": "@2", "status": "running"},
            }
        }

        MODULE.apply_state_action("clear", target, state)

        self.assertNotIn("%1", state["panes"])
        self.assertIn("%2", state["panes"])
        self.assertEqual(MODULE.agent_status_counts(state), (1, 0))

    def test_mark_done_keeps_pane_running_while_subagent_is_active(self):
        target = MODULE.TmuxTarget(
            pane_id="%1",
            session_id="$1",
            session_name="⌛️dev",
            window_id="@1",
            window_name="⌛️node",
        )
        state = {
            "panes": {
                "%1": {
                    "session_id": "$1",
                    "window_id": "@1",
                    "status": "running",
                    "active_subagents": 1,
                },
            }
        }

        MODULE.apply_state_action("mark-done", target, state)

        self.assertEqual(state["panes"]["%1"]["status"], "running")

    def test_mark_done_marks_pane_done_once_subagent_finishes(self):
        target = MODULE.TmuxTarget(
            pane_id="%1",
            session_id="$1",
            session_name="⌛️dev",
            window_id="@1",
            window_name="⌛️node",
        )
        state = {
            "panes": {
                "%1": {
                    "session_id": "$1",
                    "window_id": "@1",
                    "status": "running",
                    "active_subagents": 1,
                },
            }
        }

        MODULE.apply_state_action("subagent-stop", target, state)
        MODULE.apply_state_action("mark-done", target, state)

        self.assertEqual(state["panes"]["%1"]["status"], "done")

    def test_subagent_start_increments_counter_on_fresh_pane(self):
        target = MODULE.TmuxTarget(
            pane_id="%1",
            session_id="$1",
            session_name="dev",
            window_id="@1",
            window_name="node",
        )
        state = {"panes": {}}

        MODULE.apply_state_action("subagent-start", target, state)

        self.assertEqual(state["panes"]["%1"]["active_subagents"], 1)
        self.assertEqual(state["panes"]["%1"]["status"], "running")

    def test_action_from_event_maps_subagent_start_and_stop(self):
        self.assertEqual(MODULE.action_from_event("SubagentStart"), "subagent-start")
        self.assertEqual(MODULE.action_from_event("SubagentStop"), "subagent-stop")

    def test_sync_state_updates_moved_pane_and_reports_old_and_new_targets(self):
        state = {
            "panes": {
                "%1": {
                    "session_id": "$old",
                    "window_id": "@old",
                    "status": "running",
                },
            }
        }

        affected_window_ids, affected_session_ids = MODULE.sync_state_with_live_panes(
            state,
            {
                "%1": MODULE.LivePane(
                    session_id="$new",
                    window_id="@new",
                ),
            },
        )

        self.assertEqual(state["panes"]["%1"]["session_id"], "$new")
        self.assertEqual(state["panes"]["%1"]["window_id"], "@new")
        self.assertEqual(affected_window_ids, {"@old", "@new"})
        self.assertEqual(affected_session_ids, {"$old", "$new"})

    def test_sync_state_prunes_closed_pane_and_reports_old_targets(self):
        state = {
            "panes": {
                "%1": {
                    "session_id": "$old",
                    "window_id": "@old",
                    "status": "running",
                },
            }
        }

        affected_window_ids, affected_session_ids = MODULE.sync_state_with_live_panes(
            state,
            {},
        )

        self.assertEqual(state["panes"], {})
        self.assertEqual(affected_window_ids, {"@old"})
        self.assertEqual(affected_session_ids, {"$old"})

    def test_refresh_names_updates_old_and_new_locations(self):
        state = {
            "panes": {
                "%1": {"session_id": "$2", "window_id": "@2", "status": "running"},
            }
        }

        with patch.object(
            MODULE,
            "list_windows",
            return_value={
                "@1": MODULE.WindowInfo(session_id="$1", window_name="⌛️old"),
                "@2": MODULE.WindowInfo(session_id="$2", window_name="node"),
            },
        ), patch.object(
            MODULE,
            "list_sessions",
            return_value={
                "$1": MODULE.SessionInfo(session_name="⌛️dev"),
                "$2": MODULE.SessionInfo(session_name="work"),
            },
        ), patch.object(MODULE, "rename_window") as rename_window, patch.object(
            MODULE, "rename_session"
        ) as rename_session:
            MODULE.refresh_names(state, {"@1", "@2"}, {"$1", "$2"})

        self.assertEqual(
            rename_window.call_args_list,
            [call("@1", "old"), call("@2", "⌛️node")],
        )
        self.assertEqual(
            rename_session.call_args_list,
            [call("$1", "dev"), call("$2", "⌛️work")],
        )

    def test_apply_refresh_refreshes_tmux_status_line(self):
        with patch.object(
            MODULE,
            "refresh_state",
            return_value=({"panes": {}}, set(), set()),
        ), patch.object(MODULE, "refresh_names") as refresh_names, patch.object(
            MODULE, "refresh_tmux_status_line"
        ) as refresh_status:
            self.assertEqual(MODULE.apply_refresh(), 0)

        refresh_names.assert_called_once_with({"panes": {}}, set(), set())
        refresh_status.assert_called_once_with()

    def test_apply_action_refreshes_tmux_status_line(self):
        target = MODULE.TmuxTarget(
            pane_id="%1",
            session_id="$1",
            session_name="dev",
            window_id="@1",
            window_name="node",
        )

        with patch.object(
            MODULE,
            "get_tmux_target",
            return_value=target,
        ), patch.object(
            MODULE,
            "update_state",
            return_value=({"panes": {}}, {"@1"}, {"$1"}),
        ), patch.object(MODULE, "refresh_names") as refresh_names, patch.object(
            MODULE, "refresh_tmux_status_line"
        ) as refresh_status:
            self.assertEqual(MODULE.apply_action("mark-running", "%1"), 0)

        refresh_names.assert_called_once_with({"panes": {}}, {"@1"}, {"$1"})
        refresh_status.assert_called_once_with()

    def test_refresh_tmux_status_line_refreshes_all_clients(self):
        class Result:
            returncode = 0
            stdout = "/dev/ttys001\n/dev/ttys007\n"

        with patch.object(MODULE, "run_tmux", return_value=Result()) as run_tmux:
            MODULE.refresh_tmux_status_line()

        self.assertEqual(
            run_tmux.call_args_list,
            [
                call(["list-clients", "-F", "#{client_name}"]),
                call(["refresh-client", "-S", "-t", "/dev/ttys001"]),
                call(["refresh-client", "-S", "-t", "/dev/ttys007"]),
            ],
        )

    def test_refresh_tmux_status_line_falls_back_when_clients_are_unavailable(self):
        class Result:
            returncode = 1
            stdout = ""

        with patch.object(MODULE, "run_tmux", return_value=Result()) as run_tmux:
            MODULE.refresh_tmux_status_line()

        self.assertEqual(
            run_tmux.call_args_list,
            [
                call(["list-clients", "-F", "#{client_name}"]),
                call(["refresh-client", "-S"]),
            ],
        )

    def test_action_from_event(self):
        self.assertEqual(MODULE.action_from_event("UserPromptSubmit"), "mark-running")
        self.assertEqual(MODULE.action_from_event("Stop"), "mark-done")
        self.assertEqual(MODULE.action_from_event("StopFailure"), "mark-done")
        self.assertEqual(MODULE.action_from_event("SessionEnd"), "clear")
        self.assertIsNone(MODULE.action_from_event("Unknown"))

    def test_read_hook_event_supports_common_field_names(self):
        self.assertEqual(MODULE.read_hook_event('{"hook_event_name":"Stop"}'), "Stop")
        self.assertEqual(
            MODULE.read_hook_event('{"hookEventName":"UserPromptSubmit"}'),
            "UserPromptSubmit",
        )
        self.assertIsNone(MODULE.read_hook_event("not-json"))

    def test_refresh_action_does_not_require_current_pane(self):
        with patch.object(MODULE, "apply_refresh", return_value=0) as apply_refresh:
            with patch.object(
                MODULE,
                "default_pane_id",
                side_effect=AssertionError("refresh should not read current pane"),
            ):
                self.assertEqual(MODULE.main(["refresh"]), 0)

        apply_refresh.assert_called_once_with()

    def test_status_right_action_does_not_require_current_pane(self):
        with patch.object(MODULE, "print_status_right", return_value=0) as print_status:
            with patch.object(
                MODULE,
                "default_pane_id",
                side_effect=AssertionError("status-right should not read current pane"),
            ):
                self.assertEqual(MODULE.main(["status-right"]), 0)

        print_status.assert_called_once_with()


if __name__ == "__main__":
    unittest.main()
