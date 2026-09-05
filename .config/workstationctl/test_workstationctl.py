from __future__ import annotations

import importlib.util
import os
import tarfile
import tempfile
import unittest
from pathlib import Path
from unittest.mock import patch

MODULE_PATH = Path(__file__).with_name("workstationctl.py")
SPEC = importlib.util.spec_from_file_location("workstationctl", MODULE_PATH)
assert SPEC is not None and SPEC.loader is not None
workstationctl = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(workstationctl)


class WorkstationctlTest(unittest.TestCase):
    def test_remove_oldest_deletes_only_one_entry(self) -> None:
        with tempfile.TemporaryDirectory() as temporary_directory:
            directory = Path(temporary_directory)
            oldest = directory / "old.tar.gz"
            newest = directory / "new.tar.gz"
            oldest.touch()
            newest.touch()
            os.utime(oldest, ns=(1, 1))
            os.utime(newest, ns=(2, 2))

            self.assertEqual(workstationctl.remove_oldest(directory), oldest)
            self.assertTrue(directory.is_dir())
            self.assertFalse(oldest.exists())
            self.assertTrue(newest.exists())

    def test_remove_oldest_preserves_empty_directory(self) -> None:
        with tempfile.TemporaryDirectory() as temporary_directory:
            directory = Path(temporary_directory)
            self.assertIsNone(workstationctl.remove_oldest(directory))
            self.assertTrue(directory.is_dir())

    def test_archive_path_has_expected_archive_name(self) -> None:
        with tempfile.TemporaryDirectory() as temporary_directory:
            root = Path(temporary_directory)
            source = root / "history"
            source.write_text("command\n")
            output = workstationctl.archive_path(
                source, root / "backups", ".zsh_history"
            )
            with tarfile.open(output, "r:gz") as archive:
                self.assertEqual(archive.getnames(), [".zsh_history"])

    def test_docker_cleanup_preserves_command_order(self) -> None:
        with patch.object(workstationctl, "run") as run:
            workstationctl.docker_cleanup()
        self.assertEqual(
            [call.args[0] for call in run.call_args_list],
            [
                ["docker", "system", "df"],
                ["docker", "container", "prune"],
                ["docker", "volume", "prune"],
                ["docker", "image", "prune"],
                ["docker", "network", "prune"],
                ["docker", "system", "prune", "-a"],
                ["docker", "system", "df"],
            ],
        )

    def test_dired_escapes_path_for_elisp(self) -> None:
        with patch.object(workstationctl, "run") as run:
            workstationctl.emacs_dired('/tmp/a "quoted" directory')
        expression = run.call_args_list[0].args[0][2]
        self.assertEqual(expression, '(dired "/tmp/a \\"quoted\\" directory")')


if __name__ == "__main__":
    unittest.main()
