from __future__ import annotations

import importlib.util
import json
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
    def test_safe_link_creates_link(self) -> None:
        with tempfile.TemporaryDirectory() as temporary_directory:
            home = Path(temporary_directory)
            source = home / "repo/config"
            target = home / ".config/app/config"
            source.parent.mkdir(parents=True)
            source.write_text("settings\n")

            self.assertIsNone(workstationctl.safe_link(source, target, home=home))
            self.assertTrue(target.is_symlink())
            self.assertEqual(target.resolve(), source.resolve())

    def test_safe_link_backs_up_existing_directory(self) -> None:
        with tempfile.TemporaryDirectory() as temporary_directory:
            home = Path(temporary_directory)
            source = home / "repo/config"
            source.mkdir(parents=True)
            target = home / ".config/app"
            target.mkdir(parents=True)
            (target / "old.conf").write_text("old\n")

            backup = workstationctl.safe_link(source, target, home=home)

            self.assertIsNotNone(backup)
            assert backup is not None
            self.assertEqual((backup / "old.conf").read_text(), "old\n")
            self.assertEqual(target.resolve(), source.resolve())
            manifest = json.loads((backup.parents[1] / "manifest.json").read_text())
            self.assertEqual(manifest["entries"][0]["target"], str(target))

    def test_safe_link_is_idempotent(self) -> None:
        with tempfile.TemporaryDirectory() as temporary_directory:
            home = Path(temporary_directory)
            source = home / "repo/config"
            source.parent.mkdir(parents=True)
            source.write_text("settings\n")
            target = home / ".config/app/config"
            target.parent.mkdir(parents=True)
            target.symlink_to(source)

            self.assertIsNone(workstationctl.safe_link(source, target, home=home))
            self.assertFalse((home / ".local/state/dotfiles").exists())

    def test_safe_link_dry_run_preserves_target(self) -> None:
        with tempfile.TemporaryDirectory() as temporary_directory:
            home = Path(temporary_directory)
            source = home / "repo/config"
            source.parent.mkdir(parents=True)
            source.write_text("new\n")
            target = home / ".config/app/config"
            target.parent.mkdir(parents=True)
            target.write_text("old\n")

            backup = workstationctl.safe_link(source, target, home=home, dry_run=True)

            self.assertIsNotNone(backup)
            self.assertFalse(target.is_symlink())
            self.assertEqual(target.read_text(), "old\n")

    def test_safe_link_rejects_unsafe_targets(self) -> None:
        with tempfile.TemporaryDirectory() as temporary_directory:
            home = Path(temporary_directory)
            source = home / "source"
            source.write_text("new\n")
            with self.assertRaises(ValueError):
                workstationctl.safe_link(source, home, home=home)
            with self.assertRaises(ValueError):
                workstationctl.safe_link(source, home.parent / "outside", home=home)

    def test_safe_link_rejects_locked_gitcrypt_source(self) -> None:
        with tempfile.TemporaryDirectory() as temporary_directory:
            home = Path(temporary_directory)
            source = home / "secrets.toml"
            source.write_bytes(b"\x00GITCRYPTciphertext")
            with self.assertRaises(ValueError):
                workstationctl.safe_link(
                    source, home / ".config/secrets.toml", home=home
                )

    def test_safe_link_allows_explicit_outside_home_target(self) -> None:
        with tempfile.TemporaryDirectory() as temporary_directory:
            root = Path(temporary_directory)
            home = root / "home"
            home.mkdir()
            source = home / "source"
            source.write_text("new\n")
            target = root / "etc/config"

            workstationctl.safe_link(
                source,
                target,
                home=home,
                backup_directory=home / "backups",
                allow_outside_home=True,
            )

            self.assertEqual(target.resolve(), source.resolve())

    def test_safe_link_restores_target_if_link_creation_fails(self) -> None:
        with tempfile.TemporaryDirectory() as temporary_directory:
            home = Path(temporary_directory)
            source = home / "source"
            source.write_text("new\n")
            target = home / ".config/app/config"
            target.parent.mkdir(parents=True)
            target.write_text("old\n")

            with (
                patch("pathlib.Path.symlink_to", side_effect=OSError("failed")),
                self.assertRaises(OSError),
            ):
                workstationctl.safe_link(source, target, home=home)

            self.assertFalse(target.is_symlink())
            self.assertEqual(target.read_text(), "old\n")

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

    def test_backup_snapshots_and_restore_commands(self) -> None:
        with tempfile.TemporaryDirectory() as temporary_directory:
            root = Path(temporary_directory)
            backups = root / "backups"
            older = backups / "20260101"
            newer = backups / "20260102"
            backup = newer / ".config/app"
            backup.mkdir(parents=True)
            older.mkdir(parents=True)
            target = root / "home/.config/app"
            workstationctl.write_backup_manifest(newer, backup, target)

            self.assertEqual(workstationctl.backup_snapshots(backups), [newer, older])
            self.assertEqual(
                workstationctl.select_backup_snapshot(backups, "latest"), newer
            )
            self.assertEqual(
                workstationctl.restore_commands(newer),
                [f"mv -- {backup} {target}"],
            )

    def test_restore_commands_rejects_legacy_snapshot(self) -> None:
        with tempfile.TemporaryDirectory() as temporary_directory:
            snapshot = Path(temporary_directory) / "20260101"
            snapshot.mkdir()
            with self.assertRaises(ValueError):
                workstationctl.restore_commands(snapshot)

    def test_restore_commands_rejects_path_escape(self) -> None:
        with tempfile.TemporaryDirectory() as temporary_directory:
            snapshot = Path(temporary_directory) / "20260101"
            snapshot.mkdir()
            (snapshot / "manifest.json").write_text(
                json.dumps(
                    {
                        "version": 1,
                        "entries": [{"backup": "../outside", "target": "/tmp/target"}],
                    }
                )
            )
            with self.assertRaises(ValueError):
                workstationctl.restore_commands(snapshot)

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
