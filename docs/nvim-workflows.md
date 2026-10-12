# Neovim Workflow Keys

`Space` = leader · `prefix` = tmux prefix · `Option` = Alt on macOS
Forgot a key? Press `Space` and wait — which-key shows the menu.

## Learn these first

| Key | Action |
|---|---|
| `Space ff` | Find a file by name |
| `Space /` | Search text across the project |
| `Space ,` | Switch between open files |
| `` Space ` `` | Jump back to the previous file |
| `Space \|` | Open a split to the right |
| `Ctrl-h/j/k/l` | Move between splits and tmux panes |

## Open a file

| I want to… | Key |
|---|---|
| Find a file by name (project root) | `Space ff` or `Space Space` |
| …in the current file's folder | `Space f.` |
| …in cwd (where I launched nvim) | `Space fF` |
| …including hidden + git-ignored | `Space fa` |
| Find a git-tracked file (incl. dotfiles) | `Space fg` |
| Reopen a recent file | `Space fr` |
| Browse the file tree | `Space e` |

## Search for text

| I want to… | Key |
|---|---|
| Search in this file | `Space sb` |
| Search the project | `Space /` or `Space sg` |
| …in the current file's folder | `Space s.` |
| …in cwd | `Space sG` |
| …including hidden + git-ignored | `Space sA` |
| Search the word under the cursor | `Space sw` |
| Send results to the quickfix list | `Ctrl-q` (inside picker) |

## Inside a picker

| I want to… | Key |
|---|---|
| Move up / down the results | `Ctrl-j` / `Ctrl-k` |
| Toggle git-ignored files | `Option-i` |
| Close | `Esc` |

## Switch between open files

| I want to… | Key |
|---|---|
| Pick from open files | `Space ,` |
| Jump back to the previous file | `` Space ` `` |
| Previous / next file | `Shift-h` / `Shift-l` |
| Close this file | `Space bd` |
| Close all other files | `Space bo` |

## Work with splits

| I want to… | Key |
|---|---|
| Split right / below | `Space \|` / `Space -` |
| Move between splits | `Ctrl-h/j/k/l` |
| Zoom split to full screen and back | `Space wm` |
| Resize | `Ctrl-Up/Down/Left/Right` |
| Make all splits equal | `Ctrl-w =` |
| Close split (file stays open) | `Space wd` |

## File explorer (`Space e`)

| I want to… | Key |
|---|---|
| Toggle hidden / git-ignored files | `H` / `I` |
| Create a file or folder | `a` (end with `/` for a folder) |
| Filter the tree | `/` |

## Code navigation

| I want to… | Key |
|---|---|
| Go to definition | `gd` |
| Find references | `gr` |
| Show docs | `K` |
| Code actions | `Space ca` |
| Rename symbol | `Space cr` |
| Next / previous diagnostic | `]d` / `[d` |

## tmux (terminals, servers, Claude)

| I want to… | Key |
|---|---|
| Split pane right / below | `prefix \|` / `prefix -` |
| Move between panes | `Ctrl-h/j/k/l` |
| Zoom pane | `prefix z` |
| Resize pane | `Option-h/j/k/l` |

## Which one do I use?

- **Know the file name** → `Space ff`
- **Know text inside it** → `Space /`
- **Had it open recently** → `Space ,` or `Space fr`
- **Know roughly where it is** → `Space e` or `Space f.`
- **Can't find it anywhere** → `Space fa` / `Space sA`
- **Need two files side by side** → `Space |`, then `Space wm` to focus one
