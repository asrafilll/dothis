# dothis

Git worktree workspace launcher. One command: worktree + branch + open workspace.

```bash
dothis page-order        # creates worktree with branch `page-order`, shell lands inside
dothis page-sales        # same, branch `page-sales`
```

## Install

```bash
chmod +x ~/ai-tools/dothis/dothis
ln -sf ~/ai-tools/dothis/dothis ~/.local/bin/dothis
echo 'source ~/ai-tools/dothis/dothis.zsh' >> ~/.zshrc   # enables default cd-into-worktree
```

## Usage

```bash
dothis <branch>                  # create/reuse worktree, cd into it (default)
dothis <branch> --claude        # launch claude code inside worktree (alias: --claudecode)
dothis <branch> --codex         # launch codex inside worktree
dothis <branch> --code          # open in VS Code
dothis <branch> --cursor        # open in Cursor
dothis --list                    # list worktrees of current repo
dothis --rm <branch> [--force]  # remove worktree (branch kept)
```

Default open action: shell (cd). Override via env:

```bash
export DOTHIS_OPEN=claudecode   # shell | claudecode | codex | code | cursor
```

## Behavior

- Run from inside any git repo (works from a worktree too).
- Worktrees live next to the repo: `<parent>/<repo>-worktrees/<branch>`.
- Branch name is used verbatim; slashes only sanitized in the folder name
  (`feature/x` → folder `feature-x`, branch stays `feature/x`).
- Branch exists locally → checked out into worktree. Exists on origin → tracked.
  New → cut from a fresh `origin/main` (fetched first), then pushed with
  `-u origin <branch>` so upstream is set from the start — plain `git push`
  works immediately. No origin → falls back to current HEAD, no push.
- Re-running is idempotent: existing worktree just gets opened.
- Branch already checked out in another worktree → opens that one instead.
- Launch modes (`--claude`, `--codex`, `--code`, `--cursor`) cd your shell into
  the worktree first, then start the tool — when the session ends you're still
  in the worktree on the right branch.
- The `dothis.zsh` wrapper must be sourced for cd and launch modes; without it
  the worktree is still created and its path printed, but your shell stays put.
