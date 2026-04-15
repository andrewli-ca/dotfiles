# dotfiles

Personal configuration files for nvim, tmux, zsh, and cheat.

## What's included

| File/Dir | Description |
|---|---|
| `nvim/` | Neovim config (LazyVim) |
| `.tmux.conf` | tmux config with TPM plugins, cross-platform clipboard |
| `.zshrc` | Zsh config with Oh My Zsh, Powerlevel10k, and plugins |
| `.p10k.zsh` | Powerlevel10k prompt config |
| `ghostty/` | Ghostty terminal config |
| `cheat-conf.yml` | cheat CLI config |
| `cheatsheets/personal/` | Personal cheatsheets (synced) |
| `Brewfile` | All Homebrew dependencies |
| `install.sh` | Bootstrap script |

> `cheatsheets/work/` is local to each machine and not synced.
> `cheatsheets/community/` is cloned from [cheat/cheatsheets](https://github.com/cheat/cheatsheets) on install.

## Setup on a new machine

### Prerequisites

- git
- [Homebrew](https://brew.sh) (macOS) or your Linux package manager
- SSH key added to GitHub (for cloning via SSH)

### 1. Clone the repo

```bash
git clone git@github.com:andrewli-ca/dotfiles.git ~/.dotfiles
```

### 2. Run the install script

```bash
cd ~/.dotfiles
./install.sh
```

This will:
- Back up any existing configs to `~/.dotfiles-backup-<timestamp>`
- Install Oh My Zsh (if not present)
- Symlink all configs to their correct locations (nvim, tmux, zsh, ghostty, cheat)
- Clone community cheatsheets
- Template the cheat config with your home directory path
- Install TPM (tmux plugin manager) if not present
- Install all Homebrew dependencies from `Brewfile`: `neovim`, `tmux`, `lazygit`, `ripgrep`, `fd`, `fzf`, `cheat`, `sqlite-rsync`, `powerlevel10k`, `zsh-autosuggestions`, `zsh-syntax-highlighting`
- Symlink brew-installed zsh plugins into oh-my-zsh custom directory
- Set up fzf shell bindings (`~/.fzf.zsh`)
- Reload tmux config if tmux is running

### 3. Finish plugin setup

**tmux** — open tmux and press `prefix + I` to install plugins via TPM

**nvim** — open nvim and `lazy.nvim` will auto-install all plugins on first launch

### 4. Verify cheat

```bash
cheat ls
```

## Theming

All three tools — Ghostty, tmux, and Neovim — auto-switch between light and dark themes based on **macOS system appearance**. They each own a separate layer of the UI.

### How the layers work

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

### Theme assignments

| Tool | Light | Dark | Palette |
|------|-------|------|---------|
| Ghostty | Catppuccin Latte Custom | Catppuccin Mocha | Catppuccin |
| tmux | `tmux-themes/light.conf` | `tmux-themes/dark.conf` | Catppuccin |
| Neovim | Kanso Pearl | Kanso Zen | Kanso |

### Switching mechanism

All three detect macOS appearance independently:

- **Ghostty** — native `light:X,dark:Y` theme syntax; switches live, no restart
- **tmux** — the `tmux-dark-notify` plugin watches for appearance changes and sources the matching theme file from `tmux-themes/`; `.tmux.conf` also has inline fallback colors for when the plugin hasn't loaded yet
- **Neovim** — `colorscheme.lua` picks the initial style via `defaults read -g AppleInterfaceStyle`, then `auto-dark-mode.nvim` polls for appearance changes and swaps between `kanso-pearl` and `kanso-zen` live

### File locations

```
ghostty/config                          # points to light:/dark: themes
~/.config/ghostty/themes/               # custom Ghostty themes (not in dotfiles)
  Catppuccin Latte Custom               # modified Latte with better text contrast
tmux-themes/
  light.conf                            # Catppuccin Latte for tmux chrome
  dark.conf                             # Catppuccin Mocha for tmux chrome
nvim/lua/plugins/colorscheme.lua        # Kanso with live appearance detection
```

### Customizing

- **Ghostty ANSI palette**: edit `~/.config/ghostty/themes/Catppuccin Latte Custom`. Changes apply to new tabs/windows.
- **tmux chrome** (status bar, borders): edit `tmux-themes/light.conf` or `dark.conf`. Reload with `prefix + R`.
- **Neovim**: edit `nvim/lua/plugins/colorscheme.lua`. Restart nvim to apply.  Appearance changes after startup are handled live by `auto-dark-mode.nvim`.

## Ongoing workflow

| Action | Command |
|---|---|
| Save a config change | `cd ~/.dotfiles && git add . && git commit -m "update" && git push` |
| Pull latest on another machine | `cd ~/.dotfiles && git pull && ./install.sh` |
| Sync nvim plugins after `lazy-lock.json` changes | Open nvim and run `:Lazy update` |
| Add a new config file | `mv <config> ~/.dotfiles/`, symlink it in `install.sh`, commit |

Every config file is a symlink back into `~/.dotfiles`, so any edit — even from inside nvim — is already tracked in git.
