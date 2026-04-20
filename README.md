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
| `docs/` | Detailed documentation (theming, etc.) |

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
- Install all Homebrew dependencies from `Brewfile`: `neovim`, `tmux`, `lazygit`, `ripgrep`, `fd`, `fzf`, `cheat`, `glow`, `sqlite-rsync`, `powerlevel10k`, `zsh-autosuggestions`, `zsh-syntax-highlighting`
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

Ghostty, tmux, and Neovim auto-switch between light/dark based on macOS appearance — each owning a separate UI layer (terminal colors / tmux chrome / editor internals).

See [docs/theming.md](docs/theming.md) for the full breakdown: layers, theme assignments, switching mechanism, and customization.

## Notes

Personal knowledge notes (markdown) live in a separate repo: [andrewli-ca/notes](https://github.com/andrewli-ca/notes), cloned to `~/notes`.

Searched and viewed with `fzf` + `ripgrep` + `glow` via three shell functions defined in `.zshrc`:

| Command | What it does |
|---|---|
| `notes` | Fuzzy-search all notes by content; preview with glow; Enter to read, Ctrl-E to edit |
| `notes-edit` | Same search; skips glow and opens the match in nvim at the exact line |
| `note <filename>` | Create or open a note by filename (tab-completes) |
| `ne` | Re-open the last note from `notes` in nvim (at the same line) |

Full workflow documentation: [docs/notes.md](docs/notes.md)

### Setup on a new machine

```bash
git clone git@github.com:andrewli-ca/notes.git ~/notes
```

The `.zshrc` functions expect notes at `~/notes/`. On machines with multiple GitHub SSH keys (e.g. work machine), use the appropriate host alias from `~/.ssh/config` instead — e.g. `git@github-personal:andrewli-ca/notes.git`.

## Ongoing workflow

| Action | Command |
|---|---|
| Save a config change | `cd ~/.dotfiles && git add . && git commit -m "update" && git push` |
| Pull latest on another machine | `cd ~/.dotfiles && git pull && ./install.sh` |
| Sync nvim plugins after `lazy-lock.json` changes | Open nvim and run `:Lazy update` |
| Add a new config file | `mv <config> ~/.dotfiles/`, symlink it in `install.sh`, commit |

Every config file is a symlink back into `~/.dotfiles`, so any edit — even from inside nvim — is already tracked in git.
