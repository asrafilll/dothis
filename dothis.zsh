# dothis shell wrapper — required for the default (shell) mode so your
# terminal actually cds into the worktree. A subprocess can't cd its parent
# shell, so this function captures the path and cds for you.
# Install: echo 'source ~/ai-tools/dothis/dothis.zsh' >> ~/.zshrc
dothis() {
  # Modes that take over the terminal or don't produce a path: pass through.
  case " $* " in
    *" --claudecode "*|*" --codex "*|*" --code "*|*" --cursor "*|\
    *" --list "*|*" --rm "*|*" -h "*|*" --help "*|*" -V "*|*" --version "*)
      command dothis "$@"
      return $?
      ;;
  esac
  # DOTHIS_OPEN set to a non-shell mode and no explicit flag: pass through too.
  if [[ -n "${DOTHIS_OPEN:-}" && "$DOTHIS_OPEN" != "shell" && "$DOTHIS_OPEN" != "cd" ]]; then
    command dothis "$@"
    return $?
  fi
  local out
  out="$(command dothis "$@")" || return $?
  [[ -d "$out" ]] && cd "$out"
}
