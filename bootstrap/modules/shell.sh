# 把 fish 注册为 macOS 可用登录 shell，并把当前用户默认 shell 切到 fish。
# 这一步涉及 /etc/shells 和用户登录 shell，失败时只提示，不阻断 dotfiles 初始化。
ensure_fish_login_shell() {
  local fish_path="/opt/homebrew/bin/fish"

  if [ ! -x "$fish_path" ]; then
    if command_exists fish; then
      fish_path="$(command -v fish)"
    else
      log_warn "fish is unavailable; skipped login shell switch."
      return 0
    fi
  fi

  if ! grep -Fxq "$fish_path" /etc/shells 2>/dev/null; then
    if confirm "fish is not listed in /etc/shells. Add $fish_path now?"; then
      log_info "Adding fish to /etc/shells..."
      if ! printf "%s\n" "$fish_path" | sudo tee -a /etc/shells >/dev/null; then
        log_warn "Failed to update /etc/shells; skipped login shell switch."
        return 0
      fi
    else
      log_warn "Skipped /etc/shells update; login shell remains unchanged."
      return 0
    fi
  fi

  local current_shell
  local current_user
  current_user="${USER:-$(id -un)}"
  current_shell="$(dscl . -read "/Users/$current_user" UserShell 2>/dev/null | awk '{print $2}' || true)"
  if [ -z "$current_shell" ]; then
    current_shell="${SHELL:-}"
  fi

  if [ "$current_shell" = "$fish_path" ]; then
    log_success "fish is already the login shell."
    return 0
  fi

  if ! confirm "Switch login shell from ${current_shell:-unknown} to $fish_path?"; then
    log_warn "Skipped login shell switch."
    return 0
  fi

  log_info "Switching login shell to fish..."
  if chsh -s "$fish_path"; then
    log_success "Login shell switched to fish. Restart terminal sessions to use it."
  else
    log_warn "Failed to switch login shell; you can retry with: chsh -s $fish_path"
  fi
}
