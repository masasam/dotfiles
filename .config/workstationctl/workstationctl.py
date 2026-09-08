#!/usr/bin/env python3
"""Personal workstation commands that do not need to run inside zsh."""

from __future__ import annotations

import argparse
import json
import os
import shutil
import subprocess
import sys
import tarfile
import time
from collections.abc import Callable, Sequence
from datetime import datetime
from pathlib import Path


def run(
    argv: Sequence[str],
    *,
    cwd: Path | None = None,
    env: dict[str, str] | None = None,
) -> None:
    subprocess.run(argv, cwd=cwd, env=env, check=True)


def timed(label: str, action: Callable[[], None]) -> None:
    started = time.monotonic()
    action()
    elapsed = time.monotonic() - started
    print(f"{label}: {elapsed:.1f}s", file=sys.stderr)


def remove_path(path: Path) -> None:
    if path.is_dir() and not path.is_symlink():
        shutil.rmtree(path)
    else:
        path.unlink()


def safe_link(
    source: Path,
    target: Path,
    *,
    home: Path,
    backup_directory: Path | None = None,
    dry_run: bool = False,
    allow_outside_home: bool = False,
) -> Path | None:
    """Link SOURCE to TARGET, preserving any existing target in a backup."""
    source = Path(os.path.abspath(source.expanduser()))
    target = Path(os.path.abspath(target.expanduser()))
    home = Path(os.path.abspath(home.expanduser()))

    if not source.exists():
        raise FileNotFoundError(source)
    if target == Path("/") or target == home:
        raise ValueError(f"refusing to replace protected path: {target}")
    if not allow_outside_home and not target.is_relative_to(home):
        raise ValueError(f"target is outside home directory: {target}")

    if target.is_symlink() and target.resolve(strict=False) == source.resolve():
        print(f"unchanged: {target} -> {source}")
        return None

    state_home = Path(
        os.environ.get("XDG_STATE_HOME", home / ".local/state")
    ).expanduser()
    backup_root = Path(
        os.path.abspath(backup_directory or state_home / "dotfiles/backups")
    )
    if backup_root == target or backup_root.is_relative_to(target):
        raise ValueError(f"backup directory must not be inside target: {target}")

    backup_target: Path | None = None
    if os.path.lexists(target):
        stamp = datetime.now().astimezone().strftime("%Y%m%dT%H%M%S.%f%z")
        relative_target = (
            target.relative_to(home)
            if target.is_relative_to(home)
            else Path("outside-home") / target.relative_to("/")
        )
        backup_target = backup_root / stamp / relative_target

    if dry_run:
        if backup_target is not None:
            print(f"would back up: {target} -> {backup_target}")
        print(f"would link: {target} -> {source}")
        return backup_target

    if backup_target is not None:
        backup_target.parent.mkdir(parents=True, exist_ok=True)
        shutil.move(str(target), str(backup_target))
        print(f"backed up: {target} -> {backup_target}")

    target.parent.mkdir(parents=True, exist_ok=True)
    try:
        target.symlink_to(source, target_is_directory=source.is_dir())
    except OSError:
        if backup_target is not None and not os.path.lexists(target):
            shutil.move(str(backup_target), str(target))
        raise
    print(f"linked: {target} -> {source}")
    return backup_target


def remove_oldest(directory: Path) -> Path | None:
    """Remove one oldest backup entry, without ever deleting DIRECTORY."""
    entries = list(directory.iterdir()) if directory.is_dir() else []
    if not entries:
        return None
    oldest = min(entries, key=lambda path: (path.stat().st_mtime_ns, path.name))
    remove_path(oldest)
    return oldest


def archive_path(source: Path, backup_directory: Path, arcname: str) -> Path:
    if not source.exists():
        raise FileNotFoundError(source)
    backup_directory.mkdir(parents=True, exist_ok=True)
    remove_oldest(backup_directory)
    stamp = datetime.now().astimezone().strftime("%Y%m%d%H%M%S")
    output = backup_directory / f"{stamp}.tar.gz"
    with tarfile.open(output, "w:gz") as archive:
        archive.add(source, arcname=arcname)
    return output


def zsh_backup(home: Path) -> None:
    archive_path(
        home / "backup/zsh/.zsh_history",
        home / "backup/zsh/backup",
        ".zsh_history",
    )


def melpa_backup(home: Path) -> None:
    archive_path(
        home / ".emacs.d/elpa",
        home / "backup/emacs/elpa",
        "elpa",
    )


def backup_cloud(home: Path) -> None:
    source = str(home / "backup")
    run(["rclone", "sync", source, "dropbox:backup"])
    run(["rclone", "sync", source, "qnap:backup"])


def docker_cleanup() -> None:
    run(["docker", "system", "df"])
    run(["docker", "container", "prune"])
    run(["docker", "volume", "prune"])
    run(["docker", "image", "prune"])
    run(["docker", "network", "prune"])
    run(["docker", "system", "prune", "-a"])
    run(["docker", "system", "df"])


def mirror_update() -> None:
    mirrorlist = Path("/etc/pacman.d/mirrorlist")
    run(
        [
            "sudo",
            "reflector",
            "--latest",
            "20",
            "--age",
            "12",
            "--country",
            "JP",
            "--sort",
            "rate",
            "--save",
            str(mirrorlist),
        ]
    )
    sys.stdout.write(mirrorlist.read_text())


def arch_update() -> None:
    run(["yay", "-Syu"])
    run(["paccache", "-r"])
    run(["paccache", "-ruk0"])


def arch_backup(home: Path) -> None:
    run(["make", "backup"], cwd=home / "src/github.com/masasam/dotfiles")


def uefi_update() -> None:
    run(["fwupdmgr", "refresh", "--force"])
    run(["fwupdmgr", "get-updates"])
    run(["fwupdmgr", "update"])


def all_update(home: Path) -> None:
    actions: list[tuple[str, Callable[[], None]]] = [
        ("archupdate", arch_update),
        ("melpabackup", lambda: melpa_backup(home)),
        ("zshbackup", lambda: zsh_backup(home)),
        ("archbackup", lambda: arch_backup(home)),
        ("backupcloud", lambda: backup_cloud(home)),
    ]
    for label, action in actions:
        timed(label, action)


def emacs_dired(path: str | None) -> None:
    directory = str(Path(path).expanduser().resolve()) if path else os.getcwd()
    expression = f"(dired {json.dumps(directory, ensure_ascii=False)})"
    run(["emacsclient", "-e", expression])
    run(["wmctrl", "-a", "emacs"])


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(prog="workstationctl")
    subparsers = parser.add_subparsers(dest="command", required=True)
    subparsers.add_parser("backupcloud")
    subparsers.add_parser("zshbackup")
    subparsers.add_parser("melpabackup")
    subparsers.add_parser("dockercleanup")
    subparsers.add_parser("mirrorupdate")
    subparsers.add_parser("archupdate")
    subparsers.add_parser("archbackup")
    subparsers.add_parser("uefiupdate")
    subparsers.add_parser("allupdate")
    dired_parser = subparsers.add_parser("dired")
    dired_parser.add_argument("path", nargs="?")
    link_parser = subparsers.add_parser("link")
    link_parser.add_argument("source", type=Path)
    link_parser.add_argument("target", type=Path)
    link_parser.add_argument("--backup-directory", type=Path)
    link_parser.add_argument("--dry-run", action="store_true")
    link_parser.add_argument("--allow-outside-home", action="store_true")
    return parser


def main(argv: Sequence[str] | None = None) -> int:
    args = build_parser().parse_args(argv)
    home = Path.home()
    commands: dict[str, Callable[[], None]] = {
        "backupcloud": lambda: backup_cloud(home),
        "zshbackup": lambda: zsh_backup(home),
        "melpabackup": lambda: melpa_backup(home),
        "dockercleanup": docker_cleanup,
        "mirrorupdate": mirror_update,
        "archupdate": arch_update,
        "archbackup": lambda: arch_backup(home),
        "uefiupdate": uefi_update,
        "allupdate": lambda: all_update(home),
        "dired": lambda: emacs_dired(args.path),
        "link": lambda: safe_link(
            args.source,
            args.target,
            home=home,
            backup_directory=args.backup_directory,
            dry_run=args.dry_run,
            allow_outside_home=args.allow_outside_home,
        ),
    }
    try:
        commands[args.command]()
    except (FileNotFoundError, OSError, ValueError, subprocess.CalledProcessError) as error:
        print(f"workstationctl: {error}", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
