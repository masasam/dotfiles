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
            {"address": "0xaaa", "pid": 10},
            {"address": "0xbbb", "pid": 20},
        ]
        self.assertEqual(
            codex_notify.find_terminal_window(clients, [99, 20, 10]),
            ("0xbbb", 20),
        )

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
