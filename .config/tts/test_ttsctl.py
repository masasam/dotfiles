from __future__ import annotations

import importlib.util
import io
import json
import os
import signal
import subprocess
import sys
import tempfile
import unittest
import wave
from pathlib import Path
from unittest.mock import MagicMock, patch

sys.dont_write_bytecode = True

MODULE_PATH = Path(__file__).with_name("ttsctl.py")
SPEC = importlib.util.spec_from_file_location("ttsctl", MODULE_PATH)
assert SPEC is not None and SPEC.loader is not None
ttsctl = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(ttsctl)


def make_wav(
    frames: bytes,
    *,
    channels: int = 1,
    sample_width: int = 2,
    sample_rate: int = 8_000,
) -> bytes:
    output = io.BytesIO()
    with wave.open(output, "wb") as writer:
        writer.setnchannels(channels)
        writer.setsampwidth(sample_width)
        writer.setframerate(sample_rate)
        writer.writeframes(frames)
    return output.getvalue()


class LanguageTest(unittest.TestCase):
    def test_detects_japanese_scripts(self) -> None:
        for text in ("ひらがな", "カタカナ", "日本語", "Emacsで読む"):
            with self.subTest(text=text):
                self.assertEqual(ttsctl.detect_language(text), "ja")

    def test_detects_english_and_respects_fallback(self) -> None:
        self.assertEqual(ttsctl.detect_language("Hello, world."), "en")
        self.assertEqual(ttsctl.detect_language("123 ...", "en"), "en")
        self.assertEqual(ttsctl.detect_language("123 ..."), "ja")

    def test_plans_mixed_sentences_in_order(self) -> None:
        self.assertEqual(
            ttsctl.plan_text("Hello world. 日本語です。Goodbye!", "auto"),
            [
                ("en", "Hello world."),
                ("ja", " 日本語です。"),
                ("en", "Goodbye!"),
            ],
        )

    def test_merges_adjacent_sentences_using_the_same_voice(self) -> None:
        self.assertEqual(
            ttsctl.plan_text("First. Second! Third?", "auto"),
            [("en", "First. Second! Third?")],
        )

    def test_explicit_language_overrides_detection(self) -> None:
        self.assertEqual(
            ttsctl.plan_text("これは日本語です。", "en"),
            [("en", "これは日本語です。")],
        )
        self.assertEqual(
            ttsctl.plan_text("This is English.", "ja"),
            [("ja", "This is English.")],
        )


class AudioTest(unittest.TestCase):
    def test_returns_a_single_wav_unchanged(self) -> None:
        audio = make_wav(b"\x01\x02" * 10)
        self.assertIs(ttsctl.combine_wavs([audio]), audio)

    def test_combines_wavs_with_a_short_silence(self) -> None:
        first = b"\x01\x02" * 10
        second = b"\x03\x04" * 5
        combined = ttsctl.combine_wavs([make_wav(first), make_wav(second)])

        with wave.open(io.BytesIO(combined), "rb") as reader:
            self.assertEqual(reader.getnchannels(), 1)
            self.assertEqual(reader.getsampwidth(), 2)
            self.assertEqual(reader.getframerate(), 8_000)
            frames = reader.readframes(reader.getnframes())

        silence = b"\0" * int(8_000 * 2 * 0.08)
        self.assertEqual(frames, first + silence + second)

    def test_rejects_incompatible_wav_formats(self) -> None:
        with self.assertRaisesRegex(RuntimeError, "音声形式"):
            ttsctl.combine_wavs(
                [
                    make_wav(b"\0\0", sample_rate=8_000),
                    make_wav(b"\0\0", sample_rate=16_000),
                ]
            )


class InputTest(unittest.TestCase):
    def test_joins_command_line_words(self) -> None:
        self.assertEqual(ttsctl.input_text(False, ["hello", "world"]), "hello world")

    def test_reads_standard_input(self) -> None:
        with patch.object(ttsctl.sys, "stdin", io.StringIO("  stdin text\n")):
            self.assertEqual(ttsctl.input_text(False, []), "stdin text")

    def test_reads_clipboard_when_requested(self) -> None:
        with patch.object(ttsctl, "clipboard_text", return_value=" clipboard "):
            self.assertEqual(ttsctl.input_text(True, ["ignored"]), "clipboard")

    def test_rejects_empty_and_oversized_text(self) -> None:
        with self.assertRaisesRegex(ValueError, "ありません"):
            ttsctl.input_text(False, [" "])
        with self.assertRaisesRegex(ValueError, "長すぎます"):
            ttsctl.input_text(False, ["x" * (ttsctl.MAX_TEXT_LENGTH + 1)])


class ServiceTest(unittest.TestCase):
    def test_does_not_start_an_already_ready_server(self) -> None:
        with (
            patch.object(ttsctl, "server_ready", return_value=True),
            patch.object(ttsctl.subprocess, "run") as run,
        ):
            ttsctl.ensure_server("en")
        run.assert_not_called()

    def test_starts_the_selected_server_and_waits_until_ready(self) -> None:
        with (
            patch.object(ttsctl, "server_ready", side_effect=[False, False, True]),
            patch.object(ttsctl.subprocess, "run") as run,
            patch.object(ttsctl.time, "sleep") as sleep,
        ):
            ttsctl.ensure_server("en")

        run.assert_called_once_with(
            ["systemctl", "--user", "start", "piper-tts-en.service"],
            check=True,
            stdout=subprocess.DEVNULL,
        )
        sleep.assert_called_once_with(0.1)

    def test_reports_a_server_start_timeout(self) -> None:
        with (
            patch.object(ttsctl, "server_ready", return_value=False),
            patch.object(ttsctl.subprocess, "run"),
            patch.object(ttsctl.time, "sleep"),
            self.assertRaisesRegex(RuntimeError, "en Piper"),
        ):
            ttsctl.ensure_server("en")

    def test_synthesize_uses_the_language_endpoint_and_json(self) -> None:
        response = MagicMock()
        response.read.return_value = b"wave data"
        context = MagicMock()
        context.__enter__.return_value = response

        with (
            patch.object(ttsctl, "ensure_server") as ensure_server,
            patch.object(ttsctl, "urlopen", return_value=context) as urlopen,
        ):
            self.assertEqual(ttsctl.synthesize("Hello", "en"), b"wave data")

        ensure_server.assert_called_once_with("en")
        request = urlopen.call_args.args[0]
        self.assertEqual(request.full_url, "http://127.0.0.1:5124/synthesize")
        self.assertEqual(json.loads(request.data), {"text": "Hello"})


class ProcessTest(unittest.TestCase):
    def test_clear_own_pid_does_not_remove_a_newer_process_pid(self) -> None:
        with (
            tempfile.TemporaryDirectory() as temporary_directory,
            patch.dict(os.environ, {"XDG_RUNTIME_DIR": temporary_directory}),
        ):
            path = ttsctl.pid_file()
            path.write_text(str(os.getpid() + 1), encoding="ascii")
            ttsctl.clear_own_pid()
            self.assertTrue(path.exists())

    def test_stop_existing_signals_only_a_tts_process(self) -> None:
        with (
            tempfile.TemporaryDirectory() as temporary_directory,
            patch.dict(os.environ, {"XDG_RUNTIME_DIR": temporary_directory}),
            patch.object(
                ttsctl.Path,
                "read_bytes",
                return_value=b"python3\0/home/user/ttsctl.py\0speak",
            ),
            patch.object(ttsctl.os, "kill") as kill,
        ):
            path = ttsctl.pid_file()
            path.write_text("4321", encoding="ascii")
            self.assertTrue(ttsctl.stop_existing())
            self.assertFalse(path.exists())

        kill.assert_called_once_with(4321, signal.SIGTERM)

    def test_stop_existing_ignores_an_unrelated_process(self) -> None:
        with (
            tempfile.TemporaryDirectory() as temporary_directory,
            patch.dict(os.environ, {"XDG_RUNTIME_DIR": temporary_directory}),
            patch.object(ttsctl.Path, "read_bytes", return_value=b"other-command"),
            patch.object(ttsctl.os, "kill") as kill,
        ):
            ttsctl.pid_file().write_text("4321", encoding="ascii")
            self.assertFalse(ttsctl.stop_existing())

        kill.assert_not_called()

    def test_speak_synthesizes_the_plan_and_cleans_up_pid(self) -> None:
        player = MagicMock()
        first = make_wav(b"\x01\x02")
        second = make_wav(b"\x03\x04")
        with (
            tempfile.TemporaryDirectory() as temporary_directory,
            patch.dict(os.environ, {"XDG_RUNTIME_DIR": temporary_directory}),
            patch.object(ttsctl, "stop_existing"),
            patch.object(ttsctl, "synthesize", side_effect=[first, second]) as synth,
            patch.object(ttsctl.subprocess, "Popen", return_value=player) as popen,
            patch.object(ttsctl.signal, "signal"),
        ):
            ttsctl.speak("Hello. 日本語です。", "auto")
            self.assertFalse(ttsctl.pid_file().exists())

        self.assertEqual(
            [call.args for call in synth.call_args_list],
            [("Hello.", "en"), (" 日本語です。", "ja")],
        )
        popen.assert_called_once_with(["pw-play", "-"], stdin=subprocess.PIPE)
        player.communicate.assert_called_once()


if __name__ == "__main__":
    unittest.main()
