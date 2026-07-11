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
dothis <branch> --claudecode    # launch claude code inside worktree
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
  New → created from current HEAD.
- Re-running is idempotent: existing worktree just gets opened.
- Branch already checked out in another worktree → opens that one instead.
- Default shell mode needs the `dothis.zsh` wrapper sourced; without it the
  worktree is still created and its path printed, but your shell stays put.
