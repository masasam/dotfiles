import io
import json
import subprocess
import unittest
from unittest.mock import patch

import codex_notify


class CodexNotifyTest(unittest.TestCase):
    def test_validates_hyprland_window_addresses(self) -> None:
        self.assertTrue(codex_notify.valid_window_address("0xabc123"))
        self.assertFalse(codex_notify.valid_window_address("abc123"))
        self.assertFalse(codex_notify.valid_window_address("0xnot-hex"))

    def test_chooses_nearest_ancestor_window(self) -> None:
        clients = [
            {"address": "0xaaa", "pid": 10, "class": "foot"},
            {"address": "0xbbb", "pid": 20, "class": "footclient"},
        ]
        self.assertEqual(
            codex_notify.find_terminal_window(clients, [99, 20, 10]),
            ("0xbbb", 20),
        )

    def test_does_not_choose_a_non_foot_ancestor_window(self) -> None:
        clients = [{"address": "0xaaa", "pid": 10, "class": "emacs"}]
        self.assertIsNone(codex_notify.find_terminal_window(clients, [10]))

    def test_does_not_validate_a_non_foot_window_as_terminal(self) -> None:
        clients = [{"address": "0xaaa", "pid": 10, "class": "emacs"}]
        completed = subprocess.CompletedProcess([], 0, json.dumps(clients), "")
        with (
            patch.object(codex_notify, "which", return_value="/usr/bin/hyprctl"),
            patch.object(codex_notify.subprocess, "run", return_value=completed),
        ):
            self.assertFalse(codex_notify.terminal_window_exists("0xaaa", 10))

    def test_uses_launch_captured_foot_window_before_process_ancestry(self) -> None:
        with (
            patch.dict(
                codex_notify.os.environ,
                {
                    "CODEX_NOTIFY_WINDOW_ADDRESS": "0xabc",
                    "CODEX_NOTIFY_WINDOW_PID": "42",
                },
                clear=False,
            ),
            patch.object(codex_notify, "terminal_window_exists", return_value=True),
            patch.object(codex_notify, "terminal_window_for_pid_chains") as fallback,
        ):
            self.assertEqual(
                codex_notify.codex_terminal_window([[99, 42]]),
                ("0xabc", 42),
            )
        fallback.assert_not_called()

    def test_recognizes_launch_captured_foot_as_focused(self) -> None:
        with (
            patch.dict(
                codex_notify.os.environ,
                {
                    "CODEX_NOTIFY_WINDOW_ADDRESS": "0xabc",
                    "CODEX_NOTIFY_WINDOW_PID": "42",
                },
                clear=False,
            ),
            patch.object(codex_notify, "active_hyprland_pid", return_value=42),
            patch.object(codex_notify, "parent_pids", return_value=set()),
        ):
            self.assertTrue(codex_notify.codex_terminal_is_focused())

    def test_notifies_with_launch_target_even_without_process_chain(self) -> None:
        captured_payload: dict[str, object] = {}

        def capture_payload(payload: dict[str, object]) -> bool:
            captured_payload.update(payload)
            return True

        with (
            patch.dict(
                codex_notify.os.environ,
                {
                    "CODEX_NOTIFY_WINDOW_ADDRESS": "0xabc",
                    "CODEX_NOTIFY_WINDOW_PID": "42",
                },
                clear=False,
            ),
            patch.object(codex_notify, "ONLY_WHEN_UNFOCUSED", False),
            patch.object(codex_notify, "codex_terminal_pid_chains", return_value=[]),
            patch.object(
                codex_notify, "codex_terminal_window", return_value=("0xabc", 42)
            ),
            patch.object(codex_notify, "which", return_value="/usr/bin/tool"),
            patch.object(
                codex_notify,
                "spawn_actionable_notification",
                side_effect=capture_payload,
            ),
            patch.object(codex_notify, "play_sound"),
        ):
            codex_notify.notify(
                "Test",
                "Body",
                urgency="normal",
                timeout_ms=1000,
                sound_name="complete",
            )
        self.assertEqual(captured_payload["address"], "0xabc")
        self.assertEqual(captured_payload["pid"], 42)

    def test_routing_diagnostics_include_only_foot_pid_and_address(self) -> None:
        clients = [
            {
                "address": "0xf00",
                "pid": 50,
                "class": "foot",
                "title": "must not be logged",
            },
            {"address": "0xdef", "pid": 51, "class": "google-chrome"},
        ]
        completed = subprocess.CompletedProcess([], 0, json.dumps(clients), "")
        with (
            patch.object(codex_notify, "which", return_value="/usr/bin/hyprctl"),
            patch.object(codex_notify.subprocess, "run", return_value=completed),
        ):
            details = codex_notify.routing_diagnostics([[1, 2]])
        self.assertEqual(details["pid_chains"], [[1, 2]])
        self.assertEqual(details["hyprland_query_ok"], True)
        self.assertEqual(details["foot_clients"], [{"pid": 50, "address": "0xf00"}])
        self.assertNotIn("title", details)

    def test_parses_tmux_clients_by_session_and_activity(self) -> None:
        output = "101\twork\t10\n202\tother\t99\n303\twork\t30\ninvalid\twork\t40\n"
        self.assertEqual(codex_notify.parse_tmux_clients(output, "work"), [303, 101])

    def test_resolves_clients_attached_to_current_tmux_session(self) -> None:
        session = subprocess.CompletedProcess([], 0, "work\n", "")
        clients = subprocess.CompletedProcess(
            [], 0, "101\twork\t10\n202\tother\t99\n303\twork\t30\n", ""
        )
        with (
            patch.dict(
                codex_notify.os.environ,
                {"TMUX": "/tmp/tmux/default,1,0", "TMUX_PANE": "%7"},
            ),
            patch.object(codex_notify, "which", return_value="/usr/bin/tmux"),
            patch.object(
                codex_notify.subprocess,
                "run",
                side_effect=[session, clients],
            ),
        ):
            self.assertEqual(codex_notify.tmux_client_pids(), [303, 101])

    def test_finds_terminal_through_tmux_client(self) -> None:
        clients = [{"address": "0xf00", "pid": 50, "class": "foot"}]
        hyprland = subprocess.CompletedProcess([], 0, json.dumps(clients), "")
        with (
            patch.dict(
                codex_notify.os.environ,
                {"HYPRLAND_INSTANCE_SIGNATURE": "test"},
            ),
            patch.object(codex_notify, "which", return_value="/usr/bin/tool"),
            patch.object(codex_notify.subprocess, "run", return_value=hyprland),
            patch.object(codex_notify, "tmux_client_pids", return_value=[200]),
            patch.object(
                codex_notify,
                "parent_pid_chain",
                side_effect=lambda pid: [pid, 50] if pid == 200 else [pid, 1],
            ),
        ):
            self.assertEqual(codex_notify.codex_terminal_window(), ("0xf00", 50))

    def test_focuses_terminal_with_hyprland_lua_dispatcher(self) -> None:
        completed = subprocess.CompletedProcess([], 0, "ok\n", "")
        with (
            patch.object(codex_notify, "which", return_value="/usr/bin/hyprctl"),
            patch.object(codex_notify, "terminal_window_exists", return_value=True),
            patch.object(codex_notify.subprocess, "run", return_value=completed) as run,
        ):
            self.assertTrue(codex_notify.focus_terminal("0xabc", 42))
        run.assert_called_once_with(
            [
                "hyprctl",
                "dispatch",
                'hl.dsp.focus({ window = "address:0xabc" })',
            ],
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
            timeout=1.5,
            check=False,
        )

    def test_does_not_focus_a_stale_terminal_window(self) -> None:
        with (
            patch.object(codex_notify, "which", return_value="/usr/bin/hyprctl"),
            patch.object(codex_notify, "terminal_window_exists", return_value=False),
            patch.object(codex_notify.subprocess, "run") as run,
        ):
            self.assertFalse(codex_notify.focus_terminal("0xabc", 42))
        run.assert_not_called()

    def test_worker_focuses_only_for_default_action(self) -> None:
        payload = {
            "title": "Codex",
            "body": "Done",
            "urgency": "normal",
            "timeout_ms": 7000,
            "address": "0xabc",
            "pid": 42,
        }
        completed = subprocess.CompletedProcess([], 0, "default\n", "")
        with (
            patch.object(codex_notify.sys, "stdin", io.StringIO(json.dumps(payload))),
            patch.object(codex_notify, "which", return_value="/usr/bin/notify-send"),
            patch.object(codex_notify.subprocess, "run", return_value=completed) as run,
            patch.object(codex_notify, "focus_terminal") as focus,
        ):
            self.assertEqual(codex_notify.notification_worker(), 0)
        self.assertIn("default=ターミナルへ移動", run.call_args.args[0])
        focus.assert_called_once_with("0xabc", 42)

    def test_worker_does_not_focus_when_notification_is_dismissed(self) -> None:
        payload = {
            "title": "Codex",
            "body": "Done",
            "urgency": "normal",
            "timeout_ms": 7000,
            "address": "0xabc",
            "pid": 42,
        }
        completed = subprocess.CompletedProcess([], 0, "", "")
        with (
            patch.object(codex_notify.sys, "stdin", io.StringIO(json.dumps(payload))),
            patch.object(codex_notify, "which", return_value="/usr/bin/notify-send"),
            patch.object(codex_notify.subprocess, "run", return_value=completed),
            patch.object(codex_notify, "focus_terminal") as focus,
        ):
            self.assertEqual(codex_notify.notification_worker(), 0)
        focus.assert_not_called()


if __name__ == "__main__":
    unittest.main()
