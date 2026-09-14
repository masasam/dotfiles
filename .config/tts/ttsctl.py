#!/usr/bin/env python3
"""Read Japanese and English text with local Piper services."""

from __future__ import annotations

import argparse
import io
import json
import os
import re
import signal
import subprocess
import sys
import time
import wave
from pathlib import Path
from urllib.error import URLError
from urllib.request import Request, urlopen

SERVERS = {
    "ja": ("http://127.0.0.1:5123", "piper-tts.service"),
    "en": ("http://127.0.0.1:5124", "piper-tts-en.service"),
}
MAX_TEXT_LENGTH = 50_000
JAPANESE_CHARACTER = re.compile(r"[\u3040-\u30ff\u3400-\u9fff]")
LATIN_CHARACTER = re.compile(r"[A-Za-z]")
SENTENCE = re.compile(r".+?(?:[。！？!?]+|\.(?=\s|$)|\n+|$)", re.DOTALL)

_player: subprocess.Popen[bytes] | None = None


def runtime_dir() -> Path:
    base = Path(os.environ.get("XDG_RUNTIME_DIR", f"/tmp/tts-{os.getuid()}"))
    path = base / "tts"
    path.mkdir(mode=0o700, parents=True, exist_ok=True)
    return path


def pid_file() -> Path:
    return runtime_dir() / "speak.pid"


def clear_own_pid() -> None:
    """Remove the PID file only when it still belongs to this process."""
    path = pid_file()
    try:
        owner = int(path.read_text(encoding="ascii").strip())
    except (FileNotFoundError, ValueError):
        return
    if owner == os.getpid():
        path.unlink(missing_ok=True)


def notify(message: str) -> None:
    if not os.environ.get("WAYLAND_DISPLAY"):
        return
    subprocess.Popen(
        ["notify-send", "-a", "tts", "読み上げ", message],
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
    )


def stop_existing() -> bool:
    path = pid_file()
    try:
        pid = int(path.read_text(encoding="ascii").strip())
    except (FileNotFoundError, ValueError):
        path.unlink(missing_ok=True)
        return False

    try:
        command = Path(f"/proc/{pid}/cmdline").read_bytes()
    except OSError:
        path.unlink(missing_ok=True)
        return False

    if b"ttsctl.py" not in command:
        path.unlink(missing_ok=True)
        return False

    try:
        os.kill(pid, signal.SIGTERM)
    except ProcessLookupError:
        pass
    path.unlink(missing_ok=True)
    return True


def handle_signal(_signum: int, _frame: object) -> None:
    if _player is not None and _player.poll() is None:
        _player.terminate()
    clear_own_pid()
    raise SystemExit(0)


def server_ready(language: str) -> bool:
    server, _service = SERVERS[language]
    try:
        with urlopen(f"{server}/info", timeout=0.5) as response:
            return response.status == 200
    except (OSError, URLError):
        return False


def ensure_server(language: str) -> None:
    if server_ready(language):
        return
    _server, service = SERVERS[language]
    subprocess.run(
        ["systemctl", "--user", "start", service],
        check=True,
        stdout=subprocess.DEVNULL,
    )
    for _ in range(150):
        if server_ready(language):
            return
        time.sleep(0.1)
    raise RuntimeError(f"{language} Piperの起動がタイムアウトしました")


def clipboard_text() -> str:
    result = subprocess.run(
        ["wl-paste", "--no-newline"],
        check=True,
        stdout=subprocess.PIPE,
        text=True,
    )
    return result.stdout


def input_text(use_clipboard: bool, words: list[str]) -> str:
    if use_clipboard:
        text = clipboard_text()
    elif words:
        text = " ".join(words)
    elif not sys.stdin.isatty():
        text = sys.stdin.read()
    else:
        text = clipboard_text()
    text = text.strip()
    if not text:
        raise ValueError("読み上げるテキストがありません")
    if len(text) > MAX_TEXT_LENGTH:
        raise ValueError(f"テキストが長すぎます（上限{MAX_TEXT_LENGTH}文字）")
    return text


def detect_language(text: str, fallback: str = "ja") -> str:
    if JAPANESE_CHARACTER.search(text):
        return "ja"
    if LATIN_CHARACTER.search(text):
        return "en"
    return fallback


def plan_text(text: str, language: str) -> list[tuple[str, str]]:
    if language != "auto":
        return [(language, text)]

    plan: list[tuple[str, str]] = []
    previous_language = "ja"
    for match in SENTENCE.finditer(text):
        sentence = match.group(0)
        detected = detect_language(sentence, previous_language)
        previous_language = detected
        if plan and plan[-1][0] == detected:
            plan[-1] = (detected, plan[-1][1] + sentence)
        else:
            plan.append((detected, sentence))
    return plan or [(detect_language(text), text)]


def synthesize(text: str, language: str) -> bytes:
    ensure_server(language)
    server, _service = SERVERS[language]
    request = Request(
        f"{server}/synthesize",
        data=json.dumps({"text": text}, ensure_ascii=False).encode(),
        headers={"Content-Type": "application/json"},
        method="POST",
    )
    with urlopen(request, timeout=180) as response:
        return response.read()


def combine_wavs(audios: list[bytes]) -> bytes:
    if len(audios) == 1:
        return audios[0]

    chunks: list[bytes] = []
    audio_format: tuple[int, int, int, str, str] | None = None
    for audio in audios:
        with wave.open(io.BytesIO(audio), "rb") as reader:
            current_format = (
                reader.getnchannels(),
                reader.getsampwidth(),
                reader.getframerate(),
                reader.getcomptype(),
                reader.getcompname(),
            )
            if audio_format is None:
                audio_format = current_format
            elif current_format != audio_format:
                raise RuntimeError("日本語と英語の音声形式が一致しません")
            chunks.append(reader.readframes(reader.getnframes()))

    assert audio_format is not None
    channels, sample_width, sample_rate, compression, compression_name = audio_format
    silence = b"\0" * int(sample_rate * sample_width * channels * 0.08)
    output = io.BytesIO()
    with wave.open(output, "wb") as writer:
        writer.setnchannels(channels)
        writer.setsampwidth(sample_width)
        writer.setframerate(sample_rate)
        writer.setcomptype(compression, compression_name)
        writer.writeframes(silence.join(chunks))
    return output.getvalue()


def speak(text: str, language: str) -> None:
    global _player

    stop_existing()
    pid_file().write_text(str(os.getpid()), encoding="ascii")
    signal.signal(signal.SIGTERM, handle_signal)
    signal.signal(signal.SIGINT, handle_signal)

    try:
        audio = combine_wavs(
            [synthesize(chunk, lang) for lang, chunk in plan_text(text, language)]
        )
        _player = subprocess.Popen(["pw-play", "-"], stdin=subprocess.PIPE)
        _player.communicate(audio)
    finally:
        clear_own_pid()


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    subparsers = parser.add_subparsers(dest="command", required=True)
    speak_parser = subparsers.add_parser("speak", help="テキストを読み上げる")
    speak_parser.add_argument("--clipboard", action="store_true")
    speak_parser.add_argument(
        "--lang", choices=("auto", "ja", "en"), default="auto", help="読み上げ言語"
    )
    speak_parser.add_argument("text", nargs="*")
    subparsers.add_parser("stop", help="読み上げを停止する")
    args = parser.parse_args()

    try:
        if args.command == "stop":
            stop_existing()
            return 0
        speak(input_text(args.clipboard, args.text), args.lang)
        return 0
    except (
        OSError,
        RuntimeError,
        subprocess.CalledProcessError,
        URLError,
        ValueError,
    ) as error:
        print(f"ttsctl: {error}", file=sys.stderr)
        notify(str(error))
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
