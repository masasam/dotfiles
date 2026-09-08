#!/usr/bin/env python3
"""Personal workstation commands that do not need to run inside zsh."""

from __future__ import annotations

import argparse
import json
import os
import shlex
import shutil
import subprocess
import sys
import tarfile
import time
from collections.abc import Callable, Sequence
from datetime import datetime
from pathlib import Path

MANIFEST_NAME = "manifest.json"
GITCRYPT_HEADER = b"\x00GITCRYPT"


def is_gitcrypt_locked(path: Path) -> bool:
    if not path.is_file():
        return False
    with path.open("rb") as stream:
        return stream.read(len(GITCRYPT_HEADER)) == GITCRYPT_HEADER


def default_backup_directory(home: Path) -> Path:
    state_home = Path(
        os.environ.get("XDG_STATE_HOME", home / ".local/state")
    ).expanduser()
    return state_home / "dotfiles/backups"


def write_backup_manifest(snapshot: Path, backup: Path, target: Path) -> None:
    manifest = {
        "version": 1,
        "entries": [
            {
                "backup": str(backup.relative_to(snapshot)),
                "target": str(target),
            }
        ],
    }
    manifest_path = snapshot / MANIFEST_NAME
    temporary_path = snapshot / f".{MANIFEST_NAME}.tmp"
    temporary_path.write_text(json.dumps(manifest, indent=2) + "\n")
    temporary_path.replace(manifest_path)


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
    if is_gitcrypt_locked(source):
        raise ValueError(f"source is still encrypted by git-crypt: {source}")
    if target == Path("/") or target == home:
        raise ValueError(f"refusing to replace protected path: {target}")
    if not allow_outside_home and not target.is_relative_to(home):
        raise ValueError(f"target is outside home directory: {target}")

    if target.is_symlink() and target.resolve(strict=False) == source.resolve():
        print(f"unchanged: {target} -> {source}")
        return None

    backup_root = Path(
        os.path.abspath(backup_directory or default_backup_directory(home))
    )
    if backup_root == target or backup_root.is_relative_to(target):
        raise ValueError(f"backup directory must not be inside target: {target}")

    backup_target: Path | None = None
    backup_snapshot: Path | None = None
    if os.path.lexists(target):
        stamp = datetime.now().astimezone().strftime("%Y%m%dT%H%M%S.%f%z")
        relative_target = (
            target.relative_to(home)
            if target.is_relative_to(home)
            else Path("outside-home") / target.relative_to("/")
        )
        backup_snapshot = backup_root / stamp
        backup_target = backup_snapshot / relative_target

    if dry_run:
        if backup_target is not None:
            print(f"would back up: {target} -> {backup_target}")
        print(f"would link: {target} -> {source}")
        return backup_target

    if backup_target is not None:
        backup_target.parent.mkdir(parents=True, exist_ok=True)
        shutil.move(str(target), str(backup_target))
        try:
            assert backup_snapshot is not None
            write_backup_manifest(backup_snapshot, backup_target, target)
        except OSError:
            shutil.move(str(backup_target), str(target))
            raise
        print(f"backed up: {target} -> {backup_target}")

    target.parent.mkdir(parents=True, exist_ok=True)
    try:
        target.symlink_to(source, target_is_directory=source.is_dir())
    except OSError:
        if backup_target is not None and not os.path.lexists(target):
            shutil.move(str(backup_target), str(target))
            assert backup_snapshot is not None
            (backup_snapshot / MANIFEST_NAME).unlink(missing_ok=True)
        raise
    print(f"linked: {target} -> {source}")
    return backup_target


def backup_snapshots(backup_directory: Path) -> list[Path]:
    if not backup_directory.is_dir():
        return []
    return sorted(
        (path for path in backup_directory.iterdir() if path.is_dir()),
        key=lambda path: path.name,
        reverse=True,
    )


def path_size(path: Path) -> int:
    if path.is_symlink() or path.is_file():
        return path.lstat().st_size
    return sum(path_size(child) for child in path.iterdir())


def show_backups(backup_directory: Path) -> None:
    snapshots = backup_snapshots(backup_directory)
    print(f"Backup directory: {backup_directory}")
    if not snapshots:
        print("No backup snapshots found.")
        return
    for snapshot in snapshots:
        print(f"{snapshot.name}\t{path_size(snapshot)} bytes")


def select_backup_snapshot(backup_directory: Path, name: str | None) -> Path:
    snapshots = backup_snapshots(backup_directory)
    if not snapshots:
        raise FileNotFoundError(f"no backup snapshots in {backup_directory}")
    if name is None or name == "latest":
        return snapshots[0]
    if Path(name).name != name:
        raise ValueError("snapshot must be a name, not a path")
    snapshot = backup_directory / name
    if snapshot not in snapshots:
        raise FileNotFoundError(snapshot)
    return snapshot


def restore_commands(snapshot: Path) -> list[str]:
    manifest_path = snapshot / MANIFEST_NAME
    if not manifest_path.is_file():
        raise ValueError(
            f"{snapshot.name} predates restore manifests; inspect it manually"
        )
    manifest = json.loads(manifest_path.read_text())
    if (
        not isinstance(manifest, dict)
        or manifest.get("version") != 1
        or not isinstance(manifest.get("entries"), list)
    ):
        raise ValueError(f"invalid backup manifest: {manifest_path}")

    commands = []
    for entry in manifest["entries"]:
        if (
            not isinstance(entry, dict)
            or not isinstance(entry.get("backup"), str)
            or not isinstance(entry.get("target"), str)
        ):
            raise TypeError(f"invalid backup entry: {manifest_path}")
        relative_backup = Path(entry["backup"])
        target = Path(entry["target"])
        if relative_backup.is_absolute() or ".." in relative_backup.parts:
            raise ValueError(f"backup path escapes snapshot: {relative_backup}")
        backup = snapshot / relative_backup
        if not os.path.lexists(backup):
            raise FileNotFoundError(backup)
        if not target.is_absolute():
            raise ValueError(f"restore target is not absolute: {target}")
        commands.append(f"mv -- {shlex.quote(str(backup))} {shlex.quote(str(target))}")
    return commands


def show_restore_plan(backup_directory: Path, name: str | None) -> None:
    snapshot = select_backup_snapshot(backup_directory, name)
    print(f"Snapshot: {snapshot}")
    print("Review and move any current target aside before running:")
    for command in restore_commands(snapshot):
        print(f"  {command}")
    print("No files were changed.")


def doctor(repository: Path, home: Path) -> bool:
    repository = repository.resolve()
    failures = 0

    def report(status: str, message: str) -> None:
        nonlocal failures
        print(f"[{status}] {message}")
        if status == "FAIL":
            failures += 1

    required_commands = (
        "cargo",
        "emacs",
        "foot",
        "git",
        "git-crypt",
        "gitleaks",
        "lua",
        "luac",
        "python3",
        "ruff",
        "zsh",
        "zig",
    )
    for command in required_commands:
        location = shutil.which(command)
        report(
            "OK" if location else "FAIL", f"command {command}: {location or 'missing'}"
        )

    encrypted_config = repository / ".config/mise/secrets.toml"
    if encrypted_config.is_file():
        locked = is_gitcrypt_locked(encrypted_config)
        report(
            "WARN" if locked else "OK",
            "optional git-crypt secrets are locked"
            if locked
            else "git-crypt secrets are unlocked",
        )

    if shutil.which("git"):
        hooks_path = subprocess.run(
            ["git", "config", "--local", "--get", "core.hooksPath"],
            cwd=repository,
            check=False,
            capture_output=True,
            text=True,
        ).stdout.strip()
        report(
            "OK" if hooks_path == ".githooks" else "WARN",
            f"Git hooks path: {hooks_path or 'not configured'}",
        )

    links = (
        (repository / ".emacs.d", home / ".emacs.d"),
        (repository / ".config/hypr", home / ".config/hypr"),
        (repository / ".config/foot/foot.ini", home / ".config/foot/foot.ini"),
        (repository / ".config/mako", home / ".config/mako"),
        (
            repository / ".config/workstationctl/workstationctl.py",
            home / ".local/bin/workstationctl",
        ),
    )
    for source, target in links:
        if not os.path.lexists(target):
            report("WARN", f"not deployed: {target}")
        elif target.is_symlink() and target.resolve(strict=False) == source.resolve():
            report("OK", f"link: {target}")
        else:
            report("FAIL", f"link drift: {target} (expected {source})")

    if shutil.which("systemctl"):
        for service in ("pipewire.service", "wireplumber.service"):
            result = subprocess.run(
                ["systemctl", "--user", "is-active", "--quiet", service],
                check=False,
                stdout=subprocess.DEVNULL,
                stderr=subprocess.DEVNULL,
            )
            state = "active" if result.returncode == 0 else "inactive or unavailable"
            report(
                "OK" if result.returncode == 0 else "WARN",
                f"user service {service}: {state}",
            )

    print(f"Doctor completed with {failures} failure(s).")
    return failures == 0


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
    doctor_parser = subparsers.add_parser("doctor")
    doctor_parser.add_argument("--repository", type=Path, required=True)
    backups_parser = subparsers.add_parser("backups")
    backups_parser.add_argument("--backup-directory", type=Path)
    restore_parser = subparsers.add_parser("restore-plan")
    restore_parser.add_argument("snapshot", nargs="?")
    restore_parser.add_argument("--backup-directory", type=Path)
    return parser


def main(argv: Sequence[str] | None = None) -> int:
    args = build_parser().parse_args(argv)
    home = Path.home()
    if args.command == "doctor":
        return 0 if doctor(args.repository, home) else 1
    backup_directory = getattr(args, "backup_directory", None)
    if args.command == "backups":
        show_backups(backup_directory or default_backup_directory(home))
        return 0
    if args.command == "restore-plan":
        try:
            show_restore_plan(
                backup_directory or default_backup_directory(home), args.snapshot
            )
        except (
            FileNotFoundError,
            OSError,
            TypeError,
            ValueError,
            json.JSONDecodeError,
        ) as error:
            print(f"workstationctl: {error}", file=sys.stderr)
            return 1
        return 0
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
    except (
        FileNotFoundError,
        OSError,
        ValueError,
        subprocess.CalledProcessError,
    ) as error:
        print(f"workstationctl: {error}", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
