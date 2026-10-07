# dotctl

Small, argument-safe replacements for standalone utility functions that used
to live in `.zshrc`.

Build and deploy it with:

```console
make dotctl
```

Run `dotctl help` for the available commands.

## Markdown to PDF

`md2pdf document.md` uses Pandoc and Typst with Noto Sans CJK JP (11pt).
Install `pandoc`, `typst`, and `noto-fonts-cjk` if missing.

`md2pdf document.md --watch` generates the PDF immediately and regenerates it
when the Markdown file is saved. It requires `watchexec`; stop with Ctrl-C.
The output is `document.pdf` alongside the input (an existing PDF is overwritten).
Images and other dependencies are not monitored by this single-file watcher.

PDF conversion uses Pandoc's Typst engine so Japanese documents do not depend
on a separately configured LaTeX font setup.
