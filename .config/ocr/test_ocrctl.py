from __future__ import annotations

import importlib.util
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path
from types import SimpleNamespace
from unittest.mock import MagicMock, patch

sys.dont_write_bytecode = True

MODULE_PATH = Path(__file__).with_name("ocrctl.py")
SPEC = importlib.util.spec_from_file_location("ocrctl", MODULE_PATH)
assert SPEC is not None and SPEC.loader is not None
ocrctl = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(ocrctl)


class ResultTest(unittest.TestCase):
    def test_extracts_nonempty_lines_from_pipeline_results(self) -> None:
        results = [
            SimpleNamespace(json={"res": {"rec_texts": [" 日本語 ", "", "English"]}}),
            SimpleNamespace(json={"res": {"rec_texts": ["123"]}}),
        ]
        self.assertEqual(ocrctl.extract_text(results), "日本語\nEnglish\n123")

    def test_ignores_malformed_pipeline_results(self) -> None:
        results = [
            SimpleNamespace(json=[]),
            SimpleNamespace(json={"res": None}),
            SimpleNamespace(json={"res": {"rec_texts": "not-a-list"}}),
        ]
        self.assertEqual(ocrctl.extract_text(results), "")


class CaptureTest(unittest.TestCase):
    def test_captures_a_region_as_png_bytes(self) -> None:
        completed = subprocess.CompletedProcess([], 0, b"png", b"")
        with patch.object(ocrctl.subprocess, "run", return_value=completed) as run:
            self.assertEqual(ocrctl.capture_region(), b"png")
        run.assert_called_once_with(
            ["hyprshot", "-m", "region", "--raw"],
            check=False,
            capture_output=True,
        )

    def test_accepts_png_when_hyprshot_exits_one(self) -> None:
        completed = subprocess.CompletedProcess([], 1, b"png", b"")
        with patch.object(ocrctl.subprocess, "run", return_value=completed):
            self.assertEqual(ocrctl.capture_region(), b"png")

    def test_treats_empty_or_failed_capture_as_cancelled(self) -> None:
        for completed in (
            subprocess.CompletedProcess([], 1, b"", b"cancelled"),
            subprocess.CompletedProcess([], 0, b"", b""),
        ):
            with (
                self.subTest(returncode=completed.returncode),
                patch.object(ocrctl.subprocess, "run", return_value=completed),
                self.assertRaises(ocrctl.CaptureCancelled),
            ):
                ocrctl.capture_region()


class ProcessingTest(unittest.TestCase):
    def test_copies_recognized_text_and_reports_line_count(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            image = Path(directory) / "image.png"
            image.write_bytes(b"png")
            with (
                patch.object(ocrctl, "recognize", return_value="line 1\nline 2"),
                patch.object(ocrctl, "copy_to_clipboard") as copy,
                patch.object(ocrctl, "notify") as notify,
            ):
                text = ocrctl.process_image(image, copy=True)

        self.assertEqual(text, "line 1\nline 2")
        copy.assert_called_once_with("line 1\nline 2")
        self.assertEqual(
            notify.call_args_list[-1].args[0],
            "2行を認識しました、クリップボードへコピーしました",
        )

    def test_does_not_copy_empty_results(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            image = Path(directory) / "image.png"
            image.write_bytes(b"png")
            with (
                patch.object(ocrctl, "recognize", return_value=""),
                patch.object(ocrctl, "copy_to_clipboard") as copy,
                patch.object(ocrctl, "notify") as notify,
            ):
                self.assertEqual(ocrctl.process_image(image, copy=True), "")

        copy.assert_not_called()
        notify.assert_called_with("文字を検出できませんでした")

    def test_region_uses_a_temporary_image_and_copies_result(self) -> None:
        captured: dict[str, object] = {}

        def process_image(image: Path, *, copy: bool) -> str:
            captured["data"] = image.read_bytes()
            captured["copy"] = copy
            captured["path"] = image
            return "recognized"

        with (
            patch.object(ocrctl, "capture_region", return_value=b"png"),
            patch.object(ocrctl, "process_image", side_effect=process_image),
        ):
            self.assertEqual(ocrctl.process_region(), "recognized")
        self.assertEqual(captured["data"], b"png")
        self.assertTrue(captured["copy"])
        self.assertFalse(captured["path"].exists())

    def test_clipboard_uses_wl_copy_without_a_shell(self) -> None:
        with patch.object(ocrctl.subprocess, "run") as run:
            ocrctl.copy_to_clipboard("recognized")
        run.assert_called_once_with(
            ["wl-copy"], input="recognized", text=True, check=True
        )


class RuntimeTest(unittest.TestCase):
    def test_missing_runtime_has_an_actionable_error(self) -> None:
        with (
            patch.object(ocrctl, "TOOL_PYTHON", Path("/nonexistent/paddleocr")),
            patch.object(ocrctl.sys, "executable", "/usr/bin/python"),
            self.assertRaisesRegex(RuntimeError, "make ocr"),
        ):
            ocrctl.ensure_tool_python()

    def test_engine_uses_medium_models_and_cpu_workaround(self) -> None:
        paddleocr = MagicMock()
        with patch.dict(sys.modules, {"paddleocr": paddleocr}):
            ocrctl.create_engine()
        paddleocr.PaddleOCR.assert_called_once_with(
            text_detection_model_name="PP-OCRv6_medium_det",
            text_recognition_model_name="PP-OCRv6_medium_rec",
            use_doc_orientation_classify=False,
            use_doc_unwarping=False,
            use_textline_orientation=False,
            enable_mkldnn=False,
            device="cpu",
        )


if __name__ == "__main__":
    unittest.main()
