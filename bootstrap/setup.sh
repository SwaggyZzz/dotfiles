#!/usr/bin/env bash

# 遇到错误、未定义变量或管道中任一步失败时立即退出，避免前面初始化失败
# 却被后续步骤掩盖。
set -Eeuo pipefail

# 根据脚本所在位置计算路径，因此可以从任意工作目录执行。
BOOTSTRAP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(cd "$BOOTSTRAP_DIR/.." && pwd)"

bootstrap_log_error() {
  printf '\033[0;31m[ERR]\033[0m %s\n' "$1" >&2
}

bootstrap_usage() {
  cat <<'EOF'
Usage: bootstrap/setup.sh

Initialize this dotfiles environment on macOS.

Clone this dotfiles repository first, then run this script from the repository.

Options:
  -h, --help            Show this help.
EOF
}

bootstrap_validate_args() {
  if [ "$#" -eq 0 ]; then
    return 0
  fi

  if [ "$#" -eq 1 ] && { [ "$1" = "-h" ] || [ "$1" = "--help" ]; }; then
    bootstrap_usage
    exit 0
  fi

  bootstrap_log_error "Unknown option: $1"
  bootstrap_usage
  exit 2
}

source "$BOOTSTRAP_DIR/lib/log.sh"
source "$BOOTSTRAP_DIR/lib/command.sh"
source "$BOOTSTRAP_DIR/lib/prompt.sh"
source "$BOOTSTRAP_DIR/lib/platform.sh"
source "$BOOTSTRAP_DIR/modules/homebrew.sh"
source "$BOOTSTRAP_DIR/modules/packages.sh"
source "$BOOTSTRAP_DIR/modules/fonts.sh"
source "$BOOTSTRAP_DIR/modules/node.sh"
source "$BOOTSTRAP_DIR/modules/dotfiles.sh"
source "$BOOTSTRAP_DIR/modules/shell.sh"

# 主流程：校验系统、安装依赖、链接 dotfiles，并配置默认 shell。
main() {
  bootstrap_validate_args "$@"
  ensure_macos

  log_info "Dotfiles dir: $DOTFILES_DIR"

  install_cli_tools
  install_fonts
  setup_node_with_fnm
  link_dotfiles
  ensure_fish_login_shell

  log_success "环境初始化完成"
}

main "$@"
