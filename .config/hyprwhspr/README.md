# On-demand voice input

Super+R and the Waybar icon run `ondemand.py toggle`. The service starts only
when requested, waits for the recording FIFO reader, and then toggles recording.
Waybar right-click restarts it without recording. Login no longer starts it.

An on-demand idle watcher checks every five seconds and stops hyprwhspr after
two minutes without recording, processing, or another request. It then exits
itself. Recording and processing are never stopped by the idle timeout.
The next request must load the model again, so initial recording is delayed.

Check: `python3 .config/hyprwhspr/test_ondemand.py`
