#!/usr/bin/env python3
"""Recognize screen regions and images with PP-OCRv6 medium."""

from __future__ import annotations

import argparse
import os
import subprocess
import sys
import tempfile
import warnings
from collections.abc import Iterable, Sequence
from pathlib import Path
from typing import Any

TOOL_PYTHON = Path.home() / ".local/share/uv/tools/paddleocr/bin/python"
DETECTION_MODEL = "PP-OCRv6_medium_det"
RECOGNITION_MODEL = "PP-OCRv6_medium_rec"
NOTIFICATION_ID = "7348"


class CaptureCancelled(Exception):
    """The user cancelled screen-region selection."""


def notify(message: str, *, timeout: int = 1800) -> None:
    if not os.environ.get("WAYLAND_DISPLAY"):
        return
    try:
        subprocess.Popen(
            [
                "notify-send",
                "-a",
                "ocr",
                "-r",
                NOTIFICATION_ID,
                "-t",
                str(timeout),
                "-i",
                "edit-copy-symbolic",
                "PP-OCRv6",
                message,
            ],
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
        )
    except OSError:
        pass


def ensure_tool_python() -> None:
    """Re-execute this controller in PaddleOCR's isolated uv environment."""
    if Path(sys.executable).resolve() == TOOL_PYTHON.resolve():
        return
    if not TOOL_PYTHON.is_file():
        raise RuntimeError(
            "PaddleOCRが未導入です。dotfilesで `make ocr` を実行してください"
        )
    environment = os.environ.copy()
    environment.setdefault("PADDLE_PDX_DISABLE_MODEL_SOURCE_CHECK", "True")
    os.execve(
        TOOL_PYTHON,
        [str(TOOL_PYTHON), str(Path(__file__).resolve()), *sys.argv[1:]],
        environment,
    )


def create_engine() -> Any:
    os.environ.setdefault("PADDLE_PDX_DISABLE_MODEL_SOURCE_CHECK", "True")
    warnings.filterwarnings("ignore", message="No ccache found.*")
    from paddleocr import PaddleOCR

    return PaddleOCR(
        text_detection_model_name=DETECTION_MODEL,
        text_recognition_model_name=RECOGNITION_MODEL,
        use_doc_orientation_classify=False,
        use_doc_unwarping=False,
        use_textline_orientation=False,
        enable_mkldnn=False,
        device="cpu",
    )


def result_payload(result: Any) -> dict[str, Any]:
    payload = result.json
    if not isinstance(payload, dict):
        return {}
    nested = payload.get("res", payload)
    return nested if isinstance(nested, dict) else {}


def extract_text(results: Iterable[Any]) -> str:
    lines: list[str] = []
    for result in results:
        texts = result_payload(result).get("rec_texts", [])
        if not isinstance(texts, list):
            continue
        lines.extend(
            text.strip() for text in texts if isinstance(text, str) and text.strip()
        )
    return "\n".join(lines)


def recognize(image: Path) -> str:
    if not image.is_file():
        raise FileNotFoundError(image)
    return extract_text(create_engine().predict(str(image)))


def capture_region() -> bytes:
    result = subprocess.run(
        ["hyprshot", "-m", "region", "--raw"],
        check=False,
        capture_output=True,
    )
    # hyprshot 1.3.0 can exit with status 1 after a successful region capture
    # because its background slurp watcher wins a race with the capture job.
    # The PNG data is authoritative; only an empty stdout means cancellation.
    if not result.stdout:
        raise CaptureCancelled
    return result.stdout


def copy_to_clipboard(text: str) -> None:
    subprocess.run(["wl-copy"], input=text, text=True, check=True)


def process_image(image: Path, *, copy: bool) -> str:
    notify("文字を認識しています…", timeout=0)
    text = recognize(image)
    if not text:
        notify("文字を検出できませんでした")
        return ""
    if copy:
        copy_to_clipboard(text)
    line_count = len(text.splitlines())
    suffix = "、クリップボードへコピーしました" if copy else ""
    notify(f"{line_count}行を認識しました{suffix}")
    return text


def process_region() -> str:
    image_data = capture_region()
    with tempfile.TemporaryDirectory(prefix="ppocr-") as directory:
        image = Path(directory) / "capture.png"
        image.write_bytes(image_data)
        return process_image(image, copy=True)


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description=__doc__)
    subparsers = parser.add_subparsers(dest="command", required=True)
    subparsers.add_parser("region", help="選択した画面領域を認識してコピーする")
    image_parser = subparsers.add_parser("image", help="画像ファイルを認識する")
    image_parser.add_argument("path", type=Path)
    image_parser.add_argument("--copy", action="store_true")
    subparsers.add_parser("warmup", help="モデルを事前ダウンロードして初期化する")
    return parser


def main(argv: Sequence[str] | None = None) -> int:
    args = build_parser().parse_args(argv)
    try:
        ensure_tool_python()
        if args.command == "warmup":
            create_engine()
            print(f"{DETECTION_MODEL} + {RECOGNITION_MODEL}: ready")
            return 0
        if args.command == "region":
            text = process_region()
        else:
            text = process_image(args.path.expanduser(), copy=args.copy)
        if text:
            print(text)
        return 0
    except CaptureCancelled:
        return 0
    except (
        FileNotFoundError,
        OSError,
        RuntimeError,
        subprocess.SubprocessError,
    ) as error:
        print(f"ocrctl: {error}", file=sys.stderr)
        notify(f"エラー: {error}", timeout=4000)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
