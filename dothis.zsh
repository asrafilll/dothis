# dothis shell wrapper — required for the default (shell) mode so your
# terminal actually cds into the worktree. A subprocess can't cd its parent
# shell, so this function captures the path and cds for you.
# Launch modes (--claudecode/--codex/--code/--cursor) are also handled here:
# the wrapper cds into the worktree first, then starts the tool, so when the
# session ends your shell is already sitting in the worktree on its branch.
# Install: echo 'source ~/ai-tools/dothis/dothis.zsh' >> ~/.zshrc
dothis() {
  # Modes that don't produce a worktree path: pass through.
  case " $* " in
    *" --list "*|*" --rm "*|*" -h "*|*" --help "*|*" -V "*|*" --version "*)
      command dothis "$@"
      return $?
      ;;
  esac
  # Split launch mode from the args meant for the binary.
  local launch="" explicit_shell=0 a
  local -a args=()
  for a in "$@"; do
    case "$a" in
      --claude|--claudecode) launch="claudecode" ;;
      --codex|--code|--cursor) launch="${a#--}" ;;
      --shell|--cd) explicit_shell=1 ;;
      *) args+=("$a") ;;
    esac
  done
  if [[ -z "$launch" && $explicit_shell -eq 0 \
     && -n "${DOTHIS_OPEN:-}" && "$DOTHIS_OPEN" != "shell" && "$DOTHIS_OPEN" != "cd" ]]; then
    launch="$DOTHIS_OPEN"
  fi
  local out
  out="$(command dothis "${args[@]}" --shell)" || return $?
  [[ -d "$out" ]] || { echo "dothis: no worktree path returned" >&2; return 1; }
  cd "$out" || return 1
  case "$launch" in
    claudecode) claude ;;
    codex)      codex ;;
    code|cursor) "$launch" . ;;
    "") ;;
    *) echo "dothis: unknown launch mode: $launch" >&2; return 1 ;;
  esac
}
