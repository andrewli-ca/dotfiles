# Notes workflow

Search, read, and edit personal markdown notes from the terminal using `ripgrep` + `fzf` + `glow` + `nvim`.

Notes are stored in a separate repo ([andrewli-ca/notes](https://github.com/andrewli-ca/notes)) cloned to `~/notes`. The tooling — shell functions in `.zshrc` — lives here in dotfiles.

## Commands

| Command | What it does |
|---|---|
| `notes` | Search notes by content. Enter = read in glow. Ctrl-E = edit in nvim. |
| `notes-edit` | Search and open the match straight in nvim (skip glow). |
| `note <file>` | Create or open a note by filename (tab-completes). |
| `ne` | Re-open the last note from `notes` in nvim at the same line. |

## Typical flow

```bash
notes            # fuzzy-search content, preview with glow
                 # Enter  → read in glow pager (q to quit)
                 # Ctrl-E → edit in nvim at matched line

ne               # after quitting glow, re-open the same note in nvim
```

To create a new note: `note docker.md` → write → `:wq`.

## Keybindings

**Inside fzf (`notes` / `notes-edit`)**

| Key | Action |
|---|---|
| Enter | Open match in glow |
| Ctrl-E | Open match in nvim at matched line |
| Ctrl-U / Ctrl-D | Scroll preview half-page |
| Esc | Cancel |

**Inside glow's pager**

| Key | Action |
|---|---|
| j / k | Scroll line down / up |
| Space / b | Page down / up |
| g / G | Top / bottom |
| / | Search, n / N for next / prev |
| q | Quit |

## Syncing notes across machines

```bash
cd ~/notes && git add -A && git commit -m "update" && git push
```

Pull on another machine: `git -C ~/notes pull`.

## Setup on a new machine

```bash
git clone git@github.com:andrewli-ca/notes.git ~/notes
```

On a machine with multiple GitHub SSH keys, use a host alias from `~/.ssh/config`:

```bash
git clone git@github-personal:andrewli-ca/notes.git ~/notes
```

## Theming

Glow style auto-switches with macOS appearance (`tokyo-night` dark / `light` light). Controlled by the `_glow_style` helper in `.zshrc`.

## Dependencies

All installed via the dotfiles Brewfile:

- `ripgrep` — content search
- `fzf` — fuzzy-finder UI
- `glow` — markdown renderer
- `neovim` — editor
