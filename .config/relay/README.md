# CLI relay (clipboard only)

Install: `make relay` (Python 3 and `wl-clipboard` required).

```sh
relay list codex
relay codex SESSION_ID --to claude-review --preview
relay codex SESSION_ID --to claude-review --note 'Review the proposed fix'
# Read the preview, enter y, then paste into Claude yourself.

relay list claude
relay claude SESSION_ID --to codex-review
```

A session can be a JSONL file path or a unique filename/ID fragment. Source
directories respect CODEX_HOME and CLAUDE_CONFIG_DIR. No latest-session guess,
automatic sending, network requests, API keys, or background service is used.
This is not an in-agent `/relay` slash command: run it from another terminal.

The first copy includes the selected session's user/assistant text. Later copies
include only new messages for the same source file and destination label.
Use a distinct --to label for each destination conversation. Successful copy
advances the cursor even if you subsequently decide not to paste the clipboard.
--preview, cancellation, and clipboard failure do not advance it. A changed or
truncated historical prefix causes an error rather than silently skipping text.

Only counts and hashes are stored under ~/.local/state/relay (XDG_STATE_HOME
supported), with private file permissions. The clipboard contains the full quote
and may be retained by clipboard managers. No automatic secret redaction is
performed: inspect the preview before confirming. Do not paste untrusted content
as instructions without review. No attachment bytes, tool outputs, system
messages, or internal reasoning are exported. References already written in
message text remain; attachment path extraction is not implemented.

Codex parsing uses observed event_msg user_message/agent_message records; only
final assistant answers are included when a phase is present. Claude parsing
uses user/assistant message.content text blocks and ignores meta/tool blocks.
These are version-dependent local log formats, not guaranteed public APIs.
Claude support has fixture tests but could not be verified against a local
Claude installation on this machine. Compacted or forked histories may not
contain the complete original conversation.

Tests: `python3 .config/relay/test_relay.py`
