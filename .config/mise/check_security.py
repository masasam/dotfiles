#!/usr/bin/env python3
"""Validate that public mise config stays public and secrets stay encrypted."""

from __future__ import annotations

import shlex
import subprocess
import sys
from pathlib import Path

import tomllib

GITCRYPT_HEADER = b"\x00GITCRYPT"
CONFIG = Path(".config/mise/config.toml")
SECRETS = Path(".config/mise/secrets.toml")
EXAMPLE = Path(".config/mise/secrets.example.toml")


def git(root: Path, *arguments: str) -> bytes:
    return subprocess.check_output(["git", *arguments], cwd=root)


def load_toml(data: bytes, label: str) -> dict[str, object]:
    try:
        parsed = tomllib.loads(data.decode())
    except (UnicodeDecodeError, tomllib.TOMLDecodeError) as error:
        raise ValueError(f"{label} is not valid public TOML: {error}") from error
    if not isinstance(parsed, dict):
        raise TypeError(f"{label} must contain a TOML table")
    return parsed


def index_blob(root: Path, path: Path) -> bytes:
    try:
        return git(root, "show", f":{path}")
    except subprocess.CalledProcessError as error:
        raise ValueError(f"{path} is not tracked in the Git index") from error


def attributes(root: Path, path: Path, *, cached: bool) -> dict[str, str]:
    arguments = ["check-attr"]
    if cached:
        arguments.append("--cached")
    output = git(root, *arguments, "filter", "diff", "--", str(path))
    attributes: dict[str, str] = {}
    for line in output.decode().splitlines():
        _, attribute, value = line.rsplit(": ", 2)
        attributes[attribute] = value
    return attributes


def check_public_config(data: bytes, label: str) -> list[str]:
    errors: list[str] = []
    try:
        config = load_toml(data, label)
    except (TypeError, ValueError) as error:
        return [str(error)]

    tools = config.get("tools")
    if not isinstance(tools, dict) or not tools:
        errors.append(f"{label} has no [tools] table")
    elif any(
        value == "latest"
        or (isinstance(value, dict) and value.get("version") == "latest")
        for value in tools.values()
    ):
        errors.append(f"{label} contains an unpinned latest tool")

    environment = config.get("env")
    if not isinstance(environment, dict) or set(environment) != {"_"}:
        errors.append(f"{label} must not contain literal environment variables")
    else:
        directive = environment.get("_")
        file_config = directive.get("file") if isinstance(directive, dict) else None
        if (
            not isinstance(file_config, dict)
            or file_config.get("path") != "~/.config/mise/secrets.toml"
            or not file_config.get("redact")
        ):
            errors.append(f"{label} must load the secrets file with redaction")
    return errors


def main() -> int:
    root = Path(__file__).resolve().parents[2]
    errors: list[str] = []

    public_worktree = (root / CONFIG).read_bytes()
    example_worktree = (root / EXAMPLE).read_bytes()
    errors.extend(check_public_config(public_worktree, str(CONFIG)))
    errors.extend(check_public_config(index_blob(root, CONFIG), f"staged {CONFIG}"))

    try:
        example = load_toml(example_worktree, str(EXAMPLE))
        staged_example = load_toml(index_blob(root, EXAMPLE), f"staged {EXAMPLE}")
    except (TypeError, ValueError) as error:
        errors.append(str(error))
        example = {}
        staged_example = {}
    if not example or any(value != "replace-me" for value in example.values()):
        errors.append(f"{EXAMPLE} must contain placeholders only")
    if not staged_example or any(
        value != "replace-me" for value in staged_example.values()
    ):
        errors.append(f"staged {EXAMPLE} must contain placeholders only")

    secret_worktree = (root / SECRETS).read_bytes()
    locked = secret_worktree.startswith(GITCRYPT_HEADER)
    if not locked:
        try:
            secrets = load_toml(secret_worktree, str(SECRETS))
        except (TypeError, ValueError) as error:
            errors.append(str(error))
            secrets = {}
        if set(secrets) != set(example):
            errors.append(f"{SECRETS} keys must match {EXAMPLE}")
        if any(
            not isinstance(value, str) or not value or value == "replace-me"
            for value in secrets.values()
        ):
            errors.append(f"{SECRETS} contains an empty or placeholder value")
        for value in secrets.values():
            if isinstance(value, str) and value.encode() in public_worktree:
                errors.append(f"a {SECRETS} value appears in public {CONFIG}")
            if isinstance(value, str) and value.encode() in example_worktree:
                errors.append(f"a {SECRETS} value appears in public {EXAMPLE}")
        mode = (root / SECRETS).stat().st_mode & 0o777
        if mode & 0o077:
            errors.append(f"{SECRETS} permissions must be 600, got {mode:o}")

    staged_secret = index_blob(root, SECRETS)
    if not staged_secret.startswith(GITCRYPT_HEADER):
        errors.append(f"staged {SECRETS} is not encrypted")

    if not locked:
        smudge_command = git(
            root, "config", "--get", "filter.git-crypt.smudge"
        ).decode()
        decrypted_staged_secret = subprocess.run(
            shlex.split(smudge_command),
            cwd=root,
            input=staged_secret,
            capture_output=True,
            check=False,
        )
        if decrypted_staged_secret.returncode != 0:
            errors.append(f"cannot decrypt staged {SECRETS} for validation")
        else:
            try:
                staged_secrets = load_toml(
                    decrypted_staged_secret.stdout, f"staged {SECRETS}"
                )
            except (TypeError, ValueError) as error:
                errors.append(str(error))
                staged_secrets = {}
            if set(staged_secrets) != set(staged_example):
                errors.append(f"staged {SECRETS} keys must match staged {EXAMPLE}")
            staged_public = index_blob(root, CONFIG)
            for value in staged_secrets.values():
                if isinstance(value, str) and value.encode() in staged_public:
                    errors.append(
                        f"a staged {SECRETS} value appears in staged {CONFIG}"
                    )
                if isinstance(value, str) and value.encode() in index_blob(
                    root, EXAMPLE
                ):
                    errors.append(
                        f"a staged {SECRETS} value appears in staged {EXAMPLE}"
                    )

    clean_command = git(root, "config", "--get", "filter.git-crypt.clean").decode()
    filtered_secret = subprocess.run(
        shlex.split(clean_command),
        cwd=root,
        input=secret_worktree,
        capture_output=True,
        check=False,
    )
    if filtered_secret.returncode != 0 or not filtered_secret.stdout.startswith(
        GITCRYPT_HEADER
    ):
        errors.append(f"git-crypt clean filter did not encrypt {SECRETS}")

    expected_attributes = {
        CONFIG: {"filter": "unspecified", "diff": "unspecified"},
        EXAMPLE: {"filter": "unspecified", "diff": "unspecified"},
        SECRETS: {"filter": "git-crypt", "diff": "git-crypt"},
    }
    for path, expected in expected_attributes.items():
        for cached in (False, True):
            actual = attributes(root, path, cached=cached)
            if actual != expected:
                source = "staged" if cached else "worktree"
                errors.append(
                    f"{source} attributes for {path}: expected {expected}, got {actual}"
                )

    if errors:
        for error in errors:
            print(f"mise-security: FAIL: {error}", file=sys.stderr)
        return 1

    state = "locked" if locked else "unlocked with mode 600"
    print(f"mise-security: OK (public config, encrypted index, secrets {state})")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
