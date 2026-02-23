# dotfiles

Personal configuration files for nvim, tmux, zsh, and cheat.

## What's included

| File/Dir | Description |
|---|---|
| `nvim/` | Neovim config (LazyVim) |
| `.tmux.conf` | tmux config with TPM plugins |
| `.zshrc` | Zsh config |
| `cheat-conf.yml` | cheat CLI config |
| `cheatsheets/` | Personal and work cheatsheets |
| `install.sh` | Bootstrap script |

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
- Symlink all configs to their correct locations
- Template the cheat config with your home directory path
- Install TPM (tmux plugin manager) if not present
- Install `cheat` CLI if not present

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
| Pull latest on another machine | `cd ~/.dotfiles && git pull` |
| Add a new config file | `mv <config> ~/.dotfiles/`, symlink it in `install.sh`, commit |

Every config file is a symlink back into `~/.dotfiles`, so any edit — even from inside nvim — is already tracked in git.
