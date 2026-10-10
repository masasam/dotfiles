# On-demand Piper

Japanese and English Piper services are not started at login. `ttsctl speak`
starts only the languages it needs and waits for their HTTP servers to become
ready. When reading ends or is cancelled, the used services are stopped.
The first request is slower because the model must be loaded each time.

Reader processes share a lock so an old reader's shutdown cannot stop the next
reader's services. Existing keyboard shortcuts and commands are unchanged.

Install with `make tts`. For an existing installation:

```sh
systemctl --user disable --now piper-tts.service piper-tts-en.service
```
