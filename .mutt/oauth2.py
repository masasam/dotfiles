#!/usr/bin/env python3
"""Run NeoMutt's OAuth helper with tokens stored in Secret Service."""

from __future__ import annotations

import os
import shlex
import shutil
import sys
from pathlib import Path

HELPER_CANDIDATES = (
    Path("/usr/share/neomutt/oauth2/mutt_oauth2.py"),
    Path("/usr/lib/neomutt/oauth2/mutt_oauth2.py"),
)
SECRET_ATTRIBUTES = "service neomutt-oauth2 account gmail-default"


def find_helper() -> Path:
    """Return the OAuth helper shipped by the installed NeoMutt package."""
    override = os.environ.get("NEOMUTT_OAUTH2_HELPER")
    candidates = (Path(override),) if override else HELPER_CANDIDATES
    for candidate in candidates:
        if candidate.is_file():
            return candidate
    raise SystemExit(
        "NeoMutt OAuth helper not found; install a NeoMutt package that ships "
        "mutt_oauth2.py"
    )


def find_secret_tool() -> str:
    """Return the Secret Service CLI or fail with an actionable message."""
    secret_tool = shutil.which("secret-tool")
    if secret_tool is None:
        raise SystemExit("secret-tool not found; install the libsecret package")
    return secret_tool


def token_marker(*, create_parent: bool = True) -> Path:
    """Return the non-secret marker file required by mutt_oauth2.py."""
    state_home = Path(
        os.environ.get("XDG_STATE_HOME", Path.home() / ".local" / "state")
    ).expanduser()
    state_dir = state_home / "neomutt"
    if create_parent:
        state_dir.mkdir(mode=0o700, parents=True, exist_ok=True)
    return state_dir / "oauth2-token"


def main() -> None:
    helper = find_helper()
    secret_tool = find_secret_tool()
    quoted_tool = shlex.quote(secret_tool)
    decrypt = f"{quoted_tool} lookup {SECRET_ATTRIBUTES}"
    encrypt = f"{quoted_tool} store --label=NeoMutt-OAuth2 {SECRET_ATTRIBUTES}"

    # Put the enforced storage arguments last so callers cannot accidentally
    # replace Secret Service with a plaintext token file.
    show_help = any(argument in {"-h", "--help"} for argument in sys.argv[1:])
    command = [
        sys.executable,
        str(helper),
        str(token_marker(create_parent=not show_help)),
        *sys.argv[1:],
        "--decryption-pipe",
        decrypt,
        "--encryption-pipe",
        encrypt,
    ]
    os.execv(sys.executable, command)


if __name__ == "__main__":
    main()
