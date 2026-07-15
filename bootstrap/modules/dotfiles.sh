# 使用 GNU stow 把当前 dotfiles 链接到 $HOME。先执行 dry run，提前暴露冲突，
# 再真正写入链接。
link_dotfiles() {
  if ! command_exists stow; then
    log_warn "stow is unavailable; skipped dotfile linking."
    return 0
  fi

  log_info "Checking stow links for $DOTFILES_DIR..."
  if ! stow --simulate --verbose --dir="$DOTFILES_DIR" --target="$HOME" .; then
    log_error "stow reported conflicts. Move or back up existing files, then rerun this script."
    return 1
  fi

  log_info "Linking dotfiles into $HOME..."
  stow --restow --verbose --dir="$DOTFILES_DIR" --target="$HOME" .
}
