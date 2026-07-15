# 当前 dotfiles 初始化依赖 macOS 路径、Homebrew 和 fish 主 shell 环境。
ensure_macos() {
  if [ "$(uname)" != "Darwin" ]; then
    log_error "This bootstrap currently supports macOS only."
    exit 1
  fi
}
