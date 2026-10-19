# Claude profiles

Run several Claude Code accounts side by side, each fully isolated: its own login, memory, history, plugins, skills, and MCP servers. All profiles share one base `settings.json` from this repo.

## Why

- **Work and personal on the work machine** — the work account (company subscription, org-managed telemetry) and the personal account must never share memory, instructions, or credentials.
- **Multiple personal subscriptions on the personal machine** — heavy use can burn through one subscription's usage limits. Extra subscriptions as separate profiles let you switch to another when one is rate-limited, without logging out and back in. Not needed yet; the setup is ready for when it is.

## How it works

| Piece | Where | Purpose |
|---|---|---|
| `claude-as <name>` | `.zshrc` | Launch Claude Code as a profile |
| `claude` | `.zshrc` | Shortcut for `claude-as $CLAUDE_MAIN` |
| `claude-personal` | `.zshrc` | Shortcut for `claude-as personal` |
| `CLAUDE_MAIN` | `~/.zshrc.local` (per machine, not synced) | Which profile lives in `~/.claude` |
| `claude/settings.json` | this repo | Base settings, symlinked into every profile |
| `settings.overlay.json` | inside a profile folder (not synced) | Profile-only settings layered on the base |

Each profile is a Claude Code config folder:

- The **main profile** (`CLAUDE_MAIN`) uses `~/.claude`, Claude Code's default. It's the only profile IDE extensions and the desktop app use, since they always read `~/.claude`.
- **Every other profile** uses `~/.claude-<name>`, selected by setting `CLAUDE_CONFIG_DIR`. Claude Code keeps that profile's login in its own keychain entry and its state in `~/.claude-<name>/.claude.json`, so accounts never mix.

Profiles are separate folders, not a symlink you swap. Claude Code stores the default login under a fixed keychain entry and keeps `~/.claude.json` outside `~/.claude`, so repointing `~/.claude` would change settings and memory but leave you logged in as the old account.

### What `claude-as` does on every launch

1. Picks the folder: `~/.claude` for the main profile, otherwise `~/.claude-<name>`.
2. On first use, creates the folder and links `claude/settings.json` into it.
3. Passes `<profile folder>/settings.overlay.json` (if present) via `--settings`, on top of the base.
4. For non-main profiles only:
   - unsets `CLAUDE_CODE_ENABLE_TELEMETRY` and `OTEL_*` so work telemetry never reaches another account
   - adds `claudeMdExcludes: ["~/.claude/**"]`, because Claude Code reads `.claude/CLAUDE.md` from parent folders and `~` is a parent of every project, so the main profile's `CLAUDE.md` would otherwise load everywhere
5. Runs `claude-profile sync` (clears lean-mode leftovers, see below).

## Setup per machine

`install.sh` writes `CLAUDE_MAIN` to `~/.zshrc.local` when it isn't set yet, defaulting to `personal`. It never changes an existing value. Pick a different main profile on first install with `CLAUDE_MAIN=work ./install.sh`.

**Work machine** — `~/.zshrc.local`:

```zsh
CLAUDE_MAIN=work
```

`claude` is the work account; `claude-personal` is the personal one in `~/.claude-personal`.

**Personal machine** — `~/.zshrc.local`:

```zsh
CLAUDE_MAIN=personal
```

`claude` and `claude-personal` both run the personal account in `~/.claude`. Extra subscriptions get their own names (below).

Without `~/.zshrc.local`, `claude` still uses `~/.claude`, under the name `default`.

## Adding a subscription

```zsh
claude-as max2      # creates ~/.claude-max2 and links base settings
/login              # inside the session, sign in with the other subscription
```

After that, `claude-as max2` always opens that account. Names may use lowercase letters, digits, and `-`.

Each profile installs its own plugins, skills, and MCP servers.

## Profile-only settings

Put settings that apply to one profile only in its overlay file, e.g. the work machine's `~/.claude/settings.overlay.json`:

```json
{
  "attribution": {
    "commit": "",
    "pr": ""
  }
}
```

Overlay merge rules: list settings (such as `permissions.allow`) add to the base; single values (such as `model`) replace it. Overlay values also outrank a repo's own `.claude/settings.json`.

Overlays and `~/.zshrc.local` stay off GitHub on purpose — work-specific config doesn't belong in dotfiles.

## Lean / full mode

`claude-profile` switches the active profile's `settings.json` link between `claude/settings.json` (full) and `claude/settings.lean.json` (lean: no skills/plugins, minimal context). It acts on whichever folder is active, so run it with the profile's `CLAUDE_CONFIG_DIR` to switch a non-main profile:

```zsh
claude-profile                                             # status of ~/.claude
CLAUDE_CONFIG_DIR=~/.claude-personal claude-profile lean   # switch personal to lean
```

## Caveats

- `/config` writes to the shared `claude/settings.json`, so a change made there applies to every profile. Put profile-specific changes in the overlay by hand.
- Overlays and the non-main guards only apply when launching through `claude` / `claude-as`. IDE extensions and the desktop app get the main profile with base settings only.
- Instruction files inside a repo (`CLAUDE.md`, `.claude/`) apply to whichever profile opens it, by design.
- Running `claude` inside a non-main session's shell starts the main profile, not the current one.
