# 当 Homebrew 已安装但尚未进入当前 PATH 时，主动加载它的 shellenv。
load_homebrew_shellenv() {
  if command_exists brew; then
    return 0
  fi

  if [ -x /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [ -x /usr/local/bin/brew ]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
}

# 缺少 Homebrew 时安装它。fish 主路径会在 config.fish 中直接加载 brew shellenv。
# brew update 只做尽力更新，临时网络失败不会中断整个初始化。
install_homebrew() {
  load_homebrew_shellenv

  if command_exists brew; then
    log_success "Homebrew is installed."
  else
    if ! confirm "Homebrew is missing. Install it now?"; then
      log_warn "Skipped Homebrew install."
      return 1
    fi

    log_info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    load_homebrew_shellenv
  fi

  if ! command_exists brew; then
    log_error "Homebrew is still unavailable after installation."
    return 1
  fi

  log_info "Updating Homebrew..."
  brew update || log_warn "brew update failed; continuing."
}

# 仅在预期命令不存在时安装 Homebrew 包。部分包名和可执行命令不同，所以 command_name
# 可以单独指定。
brew_install_if_missing() {
  local package="$1"
  local command_name="${2:-$1}"

  if command_exists "$command_name"; then
    log_success "$package is installed."
    return 0
  fi

  log_info "Installing $package..."
  brew install "$package"
}

# 仅在当前 Homebrew 元数据中能找到 cask 时安装。字体 cask 可能迁移或改名，
# 找不到时只给 warning，不让整个初始化失败。
brew_install_cask_if_available() {
  local cask="$1"
  local label="${2:-$1}"

  if brew list --cask "$cask" >/dev/null 2>&1; then
    log_success "$label is installed."
    return 0
  fi

  if ! brew info --cask "$cask" >/dev/null 2>&1; then
    log_warn "Homebrew cask not found for $label: $cask"
    return 1
  fi

  log_info "Installing $label..."
  brew install --cask "$cask"
}

# 对同一个 cask 尝试多个可能名称，降低 Homebrew 后续迁移或改名带来的影响。
install_cask_with_candidates() {
  local label="$1"
  shift
  local cask

  for cask in "$@"; do
    if brew list --cask "$cask" >/dev/null 2>&1; then
      log_success "$label is installed via $cask."
      return 0
    fi
  done

  for cask in "$@"; do
    if brew_install_cask_if_available "$cask" "$label"; then
      return 0
    fi
  done

  log_warn "Skipped $label; none of the configured casks were available."
}
