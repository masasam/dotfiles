import argparse
import contextlib
import io
import json
import os
import subprocess
import tempfile
import unittest
from pathlib import Path
from unittest.mock import patch

import relay


class RelayTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.directory = Path(self.temp.name)
        self.path = self.directory / "session.jsonl"

    def write(self, items):
        self.path.write_text("".join(json.dumps(item) + "\n" for item in items))

    def test_codex_filters_internal_messages_and_progress(self):
        self.write(
            [
                {
                    "type": "response_item",
                    "payload": {"role": "system", "text": "secret"},
                },
                {
                    "type": "event_msg",
                    "payload": {"type": "agent_reasoning", "text": "secret"},
                },
                {
                    "type": "event_msg",
                    "payload": {"type": "user_message", "message": "hello"},
                },
                {
                    "type": "event_msg",
                    "payload": {
                        "type": "agent_message",
                        "phase": "commentary",
                        "message": "wait",
                    },
                },
                {
                    "type": "event_msg",
                    "payload": {
                        "type": "agent_message",
                        "phase": "final_answer",
                        "message": "answer",
                    },
                },
            ]
        )
        self.assertEqual(
            relay.messages(self.path, "codex"),
            [
                {"role": "user", "text": "hello"},
                {"role": "assistant", "text": "answer"},
            ],
        )

    def test_claude_filters_tools_thinking_meta_and_duplicates(self):
        item = {
            "type": "assistant",
            "uuid": "a",
            "message": {
                "role": "assistant",
                "content": [
                    {"type": "thinking", "thinking": "private"},
                    {"type": "tool_use", "name": "shell"},
                    {"type": "text", "text": "answer"},
                ],
            },
        }
        self.write(
            [
                item,
                item,
                {
                    "type": "user",
                    "isMeta": True,
                    "message": {"role": "user", "content": "private"},
                },
            ]
        )
        self.assertEqual(
            relay.messages(self.path, "claude"),
            [{"role": "assistant", "text": "answer"}],
        )

    def test_partial_record_is_ignored(self):
        self.path.write_text('{"unfinished":')
        self.assertEqual(list(relay.records(self.path)), [])

    def test_malformed_complete_record_fails(self):
        self.path.write_text('{"unfinished":\n')
        with self.assertRaises(ValueError):
            list(relay.records(self.path))

    def test_cursor_detects_rewrites_and_truncation(self):
        items = [{"role": "user", "text": "one"}]
        cursor = {"count": 1, "digest": relay.digest(items)}
        self.assertEqual(
            relay.pending(items + [{"role": "assistant", "text": "two"}], cursor),
            [{"role": "assistant", "text": "two"}],
        )
        for changed in ([], [{"role": "user", "text": "changed"}]):
            with self.assertRaises(ValueError):
                relay.pending(changed, cursor)

    def transfer(self, preview=False):
        args = argparse.Namespace(
            source="codex",
            session=str(self.path),
            to="claude",
            note="",
            preview=preview,
        )
        with (
            patch.dict(os.environ, {"XDG_STATE_HOME": str(self.directory)}),
            contextlib.redirect_stdout(io.StringIO()),
        ):
            relay.transfer(args)

    def seed(self):
        self.write(
            [
                {
                    "type": "event_msg",
                    "payload": {"type": "user_message", "message": "hello"},
                }
            ]
        )

    def test_preview_does_not_copy_or_advance(self):
        self.seed()
        with patch.object(relay.subprocess, "run") as copy:
            self.transfer(preview=True)
        copy.assert_not_called()
        self.assertFalse((self.directory / "relay/cursors.json").exists())

    def test_copy_failure_does_not_advance(self):
        self.seed()
        with (
            patch.object(relay.sys.stdin, "isatty", return_value=True),
            patch("builtins.input", return_value="y"),
            patch.object(
                relay.subprocess,
                "run",
                side_effect=subprocess.CalledProcessError(1, "wl-copy"),
            ),
            self.assertRaises(subprocess.CalledProcessError),
        ):
            self.transfer()
        self.assertFalse((self.directory / "relay/cursors.json").exists())

    def test_copy_success_and_no_duplicate_copy(self):
        self.seed()
        with (
            patch.object(relay.sys.stdin, "isatty", return_value=True),
            patch("builtins.input", return_value="y"),
            patch.object(relay.subprocess, "run") as copy,
        ):
            self.transfer()
            self.transfer()
        self.assertEqual(copy.call_count, 1)
        path = self.directory / "relay/cursors.json"
        self.assertEqual(path.stat().st_mode & 0o777, 0o600)
        self.assertNotIn("hello", path.read_text())


if __name__ == "__main__":
    unittest.main()
