# Theming

All three tools — Ghostty, tmux, and Neovim — auto-switch between light and dark themes based on **macOS system appearance**. They each own a separate layer of the UI.

## How the layers work

```
┌─────────────────────────────────────────────────┐
│ Ghostty (terminal emulator)                     │
│  Controls: ANSI color palette (colors 0-15),    │
│  background, foreground, cursor, selection       │
│  Affects: all text rendered in the terminal pane │
│                                                  │
│  ┌─────────────────────────────────────────────┐ │
│  │ tmux                                        │ │
│  │  Controls: status bar, pane borders,        │ │
│  │  window tabs, message bar                   │ │
│  │  Does NOT affect: pane content              │ │
│  │                                             │ │
│  │  ┌───────────────────────────────────────┐  │ │
│  │  │ Neovim (inside a tmux pane)           │  │ │
│  │  │  Controls: everything inside the      │  │ │
│  │  │  editor — syntax, statusline, floats  │  │ │
│  │  │  Uses true color (#hex), bypasses     │  │ │
│  │  │  the ANSI palette entirely            │  │ │
│  │  └───────────────────────────────────────┘  │ │
│  └─────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────┘
```

When a CLI tool (e.g. Claude Code) outputs "print this in ANSI color 7", tmux passes it through and **Ghostty** decides what hex color that actually renders as. Neovim sidesteps this entirely by emitting true color escape sequences.

## Theme assignments

| Tool | Light | Dark | Palette |
|------|-------|------|---------|
| Ghostty | Catppuccin Latte Custom | Catppuccin Mocha | Catppuccin |
| tmux | `tmux-themes/light.conf` | `tmux-themes/dark.conf` | Catppuccin |
| Neovim | Kanso Pearl | Kanso Zen | Kanso |

## Switching mechanism

All three detect macOS appearance independently:

- **Ghostty** — native `light:X,dark:Y` theme syntax; switches live, no restart
- **tmux** — the `tmux-dark-notify` plugin watches for appearance changes and sources the matching theme file from `tmux-themes/`; `.tmux.conf` also has inline fallback colors for when the plugin hasn't loaded yet
- **Neovim** — `colorscheme.lua` picks the initial style via `defaults read -g AppleInterfaceStyle`, then `auto-dark-mode.nvim` polls for appearance changes and swaps between `kanso-pearl` and `kanso-zen` live

## File locations

```
ghostty/config                          # points to light:/dark: themes
~/.config/ghostty/themes/               # custom Ghostty themes (not in dotfiles)
  Catppuccin Latte Custom               # modified Latte with better text contrast
tmux-themes/
  light.conf                            # Catppuccin Latte for tmux chrome
  dark.conf                             # Catppuccin Mocha for tmux chrome
nvim/lua/plugins/colorscheme.lua        # Kanso with live appearance detection
```

## Customizing

- **Ghostty ANSI palette**: edit `~/.config/ghostty/themes/Catppuccin Latte Custom`. Changes apply to new tabs/windows.
- **tmux chrome** (status bar, borders): edit `tmux-themes/light.conf` or `dark.conf`. Reload with `prefix + R`.
- **Neovim**: edit `nvim/lua/plugins/colorscheme.lua`. Restart nvim to apply. Appearance changes after startup are handled live by `auto-dark-mode.nvim`.
