# dotfiles

Personal configuration files for nvim, tmux, zsh, and cheat.

## What's included

| File/Dir | Description |
|---|---|
| `nvim/` | Neovim config (LazyVim) |
| `.tmux.conf` | tmux config with TPM plugins, cross-platform clipboard |
| `.zshrc` | Zsh config with Oh My Zsh, Powerlevel10k, and plugins |
| `.p10k.zsh` | Powerlevel10k prompt config |
| `cheat-conf.yml` | cheat CLI config |
| `cheatsheets/personal/` | Personal cheatsheets (synced) |
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
- Install Powerlevel10k theme (if not present)
- Install `zsh-autosuggestions` and `zsh-syntax-highlighting` plugins
- Symlink all configs to their correct locations
- Clone community cheatsheets
- Template the cheat config with your home directory path
- Install TPM (tmux plugin manager) if not present
- Install `cheat` CLI if not present
- Reload tmux config if tmux is running

### 3. Finish plugin setup

**tmux** — open tmux and press `prefix + I` to install plugins via TPM

**nvim** — open nvim and `lazy.nvim` will auto-install all plugins on first launch

### 4. Verify cheat

```bash
cheat ls
```

## Ongoing workflow

| Action | Command |
|---|---|
| Save a config change | `cd ~/.dotfiles && git add . && git commit -m "update" && git push` |
| Pull latest on another machine | `cd ~/.dotfiles && git pull && ./install.sh` |
| Add a new config file | `mv <config> ~/.dotfiles/`, symlink it in `install.sh`, commit |

Every config file is a symlink back into `~/.dotfiles`, so any edit — even from inside nvim — is already tracked in git.
