# Changelog

## 2026-03-23

### Tmux

- **Main pane sizing** — `main-pane-width` and `main-pane-height` set to 60%, so the primary pane gets more space in main-horizontal/main-vertical layouts.
- **`Prefix Alt-3`** — Swap current pane to the main position and apply main-horizontal layout (main pane on top, others side-by-side below).
- **`Prefix Alt-4`** — Swap current pane to the main position and apply main-vertical layout (main pane on left, others stacked right).
- **`Prefix V`** — Pull the marked pane into the current window, stacked vertically (below).
- **`Prefix H`** — Pull the marked pane into the current window, side by side (right).

### Neovim

- **`<leader>yp`** — Copy the file's relative path to the system clipboard.
- **`<leader>yd`** — Copy the file's directory path to the system clipboard.
- **`<leader>yf`** — Copy the filename (without extension) to the system clipboard.

### Zsh

- Removed `command-not-found` plugin.
- Added OpenClaw shell completions.
