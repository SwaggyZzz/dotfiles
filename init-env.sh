#!/usr/bin/env bash

# 遇到错误、未定义变量或管道中任一步失败时立即退出，避免前面初始化失败
# 却被后续步骤掩盖。
set -Eeuo pipefail

# 根据脚本所在位置计算 dotfiles 仓库根目录，因此可以从任意工作目录执行。
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 运行时开关，由命令行参数解析得到。
ASSUME_YES=0
SKIP_BREW=0
SKIP_FONTS=0
SKIP_LINK=0
WITH_BYTED_SETUP=0
BYTED_MODE=""

# 可选的公司环境初始化脚本。它会下载并执行远程内容，且远程内容可能随时间变化，
# 所以这里设计为显式开启。
BYTED_BOOTSTRAP_URL="https://tosv.byted.org/obj/motor-trade-skynet/mac_bootstrap.sh"

# 简单的 ANSI 颜色定义，让终端输出更容易扫读。
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

log_info() {
  printf "${CYAN}[INFO]${NC} %s\n" "$1"
}

log_success() {
  printf "${GREEN}[OK]${NC} %s\n" "$1"
}

log_warn() {
  printf "${YELLOW}[WARN]${NC} %s\n" "$1"
}

log_error() {
  printf "${RED}[ERR]${NC} %s\n" "$1" >&2
}

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# 打印命令帮助，不执行任何初始化动作。
usage() {
  cat <<'EOF'
Usage: ./init-env.sh [options]

Initialize this dotfiles environment on macOS.

Options:
  -y, --yes             Answer yes to prompts.
  --skip-brew           Do not install or update Homebrew packages.
  --skip-fonts          Do not install terminal and status bar fonts.
  --skip-link           Do not symlink dotfiles into $HOME.
  --with-byted-setup    Also run the remote Byted setup bootstrap.
  --ai                  Pass AI mode to the remote Byted bootstrap.
  --rd                  Pass RD mode to the remote Byted bootstrap.
  -h, --help            Show this help.

Examples:
  ./init-env.sh
  ./init-env.sh -y
  ./init-env.sh -y --with-byted-setup --ai
EOF
}

# 在安装软件或执行远程代码前进行确认。传入 --yes 时自动确认，方便无人值守初始化。
confirm() {
  local message="$1"

  if [ "$ASSUME_YES" = "1" ]; then
    return 0
  fi

  printf "%s [y/N] " "$message"
  read -r reply
  case "$reply" in
    y|Y|yes|YES) return 0 ;;
    *) return 1 ;;
  esac
}

# 只解析当前脚本支持的参数。遇到未知参数时直接报错，避免拼写错误触发意外流程。
parse_args() {
  while [ "$#" -gt 0 ]; do
    case "$1" in
      -y|--yes)
        ASSUME_YES=1
        ;;
      --skip-brew)
        SKIP_BREW=1
        ;;
      --skip-fonts)
        SKIP_FONTS=1
        ;;
      --skip-link)
        SKIP_LINK=1
        ;;
      --with-byted-setup)
        WITH_BYTED_SETUP=1
        ;;
      --ai)
        BYTED_MODE="-ai"
        ;;
      --rd)
        BYTED_MODE="-rd"
        ;;
      -h|--help)
        usage
        exit 0
        ;;
      *)
        log_error "Unknown option: $1"
        usage
        exit 2
        ;;
    esac
    shift
  done
}

# 当前 dotfiles 初始化依赖 macOS 路径、Homebrew 和 zsh 默认环境。
ensure_macos() {
  if [ "$(uname)" != "Darwin" ]; then
    log_error "This bootstrap currently supports macOS only."
    exit 1
  fi
}

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

# 仅追加一次 shell 配置行。marker 可以比完整行更宽泛，用来避免重复写入配置。
append_once() {
  local file="$1"
  local marker="$2"
  local line="$3"

  touch "$file"
  if ! grep -Fq "$marker" "$file" 2>/dev/null; then
    printf "%s\n" "$line" >> "$file"
  fi
}

# 缺少 Homebrew 时安装它，并把 shellenv 写入 zsh 配置，保证后续终端可用。
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

  local brew_bin
  brew_bin="$(command -v brew)"
  local shellenv_line
  shellenv_line="eval \"\$(${brew_bin} shellenv)\""
  append_once "$HOME/.zprofile" "${brew_bin} shellenv" "$shellenv_line"
  append_once "$HOME/.zshrc" "${brew_bin} shellenv" "$shellenv_line"

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

# 安装当前终端和 sketchybar 配置依赖的字体：
# - JetBrainsMono Nerd Font：Alacritty、kitty 以及图标字符回退使用。
# - Maple Mono NF CN：kitty 用它映射中文字符。
# - SF Symbols 和 sketchybar-app-font：sketchybar 图标使用。
# - SF Pro：sketchybar 文本标签使用，很多 macOS 已内置；新机器缺少时用 cask 补齐。
install_fonts() {
  if [ "$SKIP_FONTS" = "1" ]; then
    log_warn "Skipped font setup."
    return 0
  fi

  load_homebrew_shellenv
  if ! command_exists brew; then
    log_warn "Homebrew is unavailable; skipped font setup."
    return 0
  fi

  install_cask_with_candidates "JetBrainsMono Nerd Font" \
    font-jetbrains-mono-nerd-font
  install_cask_with_candidates "Maple Mono NF CN" \
    font-maple-mono-nf-cn \
    font-maple-mono-nf
  install_cask_with_candidates "SF Pro" \
    font-sf-pro
  install_cask_with_candidates "SF Symbols" \
    sf-symbols
  install_cask_with_candidates "sketchybar app font" \
    font-sketchybar-app-font
}

# 安装 AeroSpace。它是窗口管理器应用，Homebrew 官方源里通常不可用，
# 因此优先使用官方维护的 tap/cask。
install_aerospace() {
  load_homebrew_shellenv
  if ! command_exists brew; then
    log_warn "Homebrew is unavailable; skipped AeroSpace setup."
    return 0
  fi

  install_cask_with_candidates "AeroSpace" \
    nikitabobko/tap/aerospace \
    aerospace
}

# 根据当前仓库配置安装常用工具：shell prompt、终端辅助工具、Neovim、tmux、zellij、
# AeroSpace、Node/Python 版本管理器，以及搜索和导航工具。
install_cli_tools() {
  install_homebrew || return 1

  brew_install_if_missing git git
  brew_install_if_missing stow stow
  brew_install_if_missing tmux tmux
  brew_install_if_missing reattach-to-user-namespace reattach-to-user-namespace
  brew_install_if_missing zellij zellij
  brew_install_if_missing neovim nvim
  brew_install_if_missing fnm fnm
  brew_install_if_missing pyenv pyenv
  brew_install_if_missing starship starship
  brew_install_if_missing zoxide zoxide
  brew_install_if_missing bat bat
  brew_install_if_missing lsd lsd
  brew_install_if_missing yazi yazi
  brew_install_if_missing ripgrep rg
  brew_install_if_missing fd fd
  brew_install_if_missing fzf fzf
  brew_install_if_missing lazygit lazygit
  brew_install_if_missing stylua stylua
  brew_install_if_missing pnpm@8 pnpm
  install_aerospace
}

# 安装 tmux 插件管理器 TPM，并尝试安装 .tmux.conf 中声明的插件。
# .tmux.conf 里也有自动安装逻辑，这里提前做一遍可以让新机器首次打开 tmux 更完整。
install_tmux_plugins() {
  if ! command_exists git; then
    log_warn "git is unavailable; skipped tmux plugin setup."
    return 0
  fi

  if ! command_exists tmux; then
    log_warn "tmux is unavailable; skipped tmux plugin setup."
    return 0
  fi

  local tpm_dir="$HOME/.tmux/plugins/tpm"
  if [ -d "$tpm_dir/.git" ]; then
    log_success "tmux TPM is installed."
  else
    log_info "Installing tmux TPM..."
    mkdir -p "$(dirname "$tpm_dir")"
    git clone https://github.com/tmux-plugins/tpm "$tpm_dir"
  fi

  if [ -x "$tpm_dir/bin/install_plugins" ]; then
    log_info "Installing tmux plugins..."
    "$tpm_dir/bin/install_plugins" || log_warn "tmux plugin installation failed; continuing."
  fi
}

# 安装 oh-my-zsh 以及 .zshrc 中引用的自定义插件。KEEP_ZSHRC 用来防止上游安装器
# 覆盖仓库中维护的 .zshrc。
install_oh_my_zsh() {
  if [ -d "$HOME/.oh-my-zsh" ]; then
    log_success "oh-my-zsh is installed."
  else
    if ! confirm "oh-my-zsh is missing. Install it now?"; then
      log_warn "Skipped oh-my-zsh install."
      return 0
    fi

    log_info "Installing oh-my-zsh..."
    RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  fi

  local custom_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
  mkdir -p "$custom_dir/plugins"

  install_zsh_plugin "zsh-autosuggestions" "https://github.com/zsh-users/zsh-autosuggestions" "$custom_dir/plugins/zsh-autosuggestions"
  install_zsh_plugin "F-Sy-H" "https://github.com/z-shell/F-Sy-H" "$custom_dir/plugins/F-Sy-H"
}

# 当 oh-my-zsh 自定义插件不存在时 clone 一份。
install_zsh_plugin() {
  local name="$1"
  local repo="$2"
  local target="$3"

  if [ -d "$target/.git" ]; then
    log_success "$name plugin is installed."
    return 0
  fi

  if ! command_exists git; then
    log_warn "git is unavailable; cannot install $name."
    return 0
  fi

  log_info "Installing zsh plugin: $name..."
  git clone --depth=1 "$repo" "$target"
}

# 通过 fnm 安装 Node.js LTS，和当前仓库 .zshrc 中的 fnm 初始化方式保持一致。
setup_node_with_fnm() {
  if ! command_exists fnm; then
    log_warn "fnm is unavailable; skipped Node.js setup."
    return 0
  fi

  eval "$(fnm env --shell bash)"

  if command_exists node; then
    log_success "Node.js is installed ($(node --version))."
    return 0
  fi

  log_info "Installing latest Node.js LTS with fnm..."
  fnm install --lts
  fnm default lts-latest || true
}

# 使用 GNU stow 把当前 dotfiles 链接到 $HOME。先执行 dry run，提前暴露冲突，
# 再真正写入链接。
link_dotfiles() {
  if [ "$SKIP_LINK" = "1" ]; then
    log_warn "Skipped dotfile linking."
    return 0
  fi

  if ! command_exists stow; then
    log_warn "stow is unavailable; skipped dotfile linking."
    return 0
  fi

  local parent_dir
  local package_name
  parent_dir="$(dirname "$DOTFILES_DIR")"
  package_name="$(basename "$DOTFILES_DIR")"

  log_info "Checking stow links for $DOTFILES_DIR..."
  if ! (cd "$parent_dir" && stow --simulate --verbose --target="$HOME" "$package_name"); then
    log_error "stow reported conflicts. Move or back up existing files, then rerun this script."
    return 1
  fi

  log_info "Linking dotfiles into $HOME..."
  (cd "$parent_dir" && stow --restow --verbose --target="$HOME" "$package_name")
}

# AeroSpace 兼容路径。当前仓库配置放在 ~/.config/aerospace/aerospace.toml，
# 这里再补一个 ~/.aerospace.toml 链接，兼容读取旧默认路径的版本。
ensure_aerospace_config_link() {
  local xdg_config="$HOME/.config/aerospace/aerospace.toml"
  local legacy_config="$HOME/.aerospace.toml"

  if [ ! -e "$xdg_config" ]; then
    log_warn "AeroSpace config is not linked yet: $xdg_config"
    return 0
  fi

  if [ -L "$legacy_config" ]; then
    log_success "AeroSpace legacy config link exists."
    return 0
  fi

  if [ -e "$legacy_config" ]; then
    log_warn "AeroSpace legacy config already exists, leaving it untouched: $legacy_config"
    return 0
  fi

  log_info "Linking AeroSpace legacy config path..."
  ln -s "$xdg_config" "$legacy_config"
}

# 用户提供的远程 Byted 初始化入口，作为可选兼容路径。即使不执行它，本地 dotfiles
# 初始化也能独立工作。
run_byted_setup() {
  if [ "$WITH_BYTED_SETUP" != "1" ]; then
    return 0
  fi

  local args=()
  if [ -n "$BYTED_MODE" ]; then
    args+=("$BYTED_MODE")
  fi
  if [ "$ASSUME_YES" = "1" ]; then
    args+=("-y")
  fi

  log_warn "About to download and run remote bootstrap: $BYTED_BOOTSTRAP_URL"
  if ! confirm "Continue with remote Byted setup?"; then
    log_warn "Skipped remote Byted setup."
    return 0
  fi

  curl -fsSL "$BYTED_BOOTSTRAP_URL" | sh -s -- "${args[@]}"
}

# 主流程：解析参数、校验系统、安装依赖、链接 dotfiles，最后按需执行远程公司初始化。
main() {
  parse_args "$@"
  ensure_macos

  log_info "Dotfiles dir: $DOTFILES_DIR"

  if [ "$SKIP_BREW" = "1" ]; then
    log_warn "Skipped Homebrew package setup."
  else
    install_cli_tools
  fi

  install_fonts
  install_tmux_plugins
  install_oh_my_zsh
  setup_node_with_fnm
  link_dotfiles
  ensure_aerospace_config_link
  run_byted_setup

  log_success "Environment initialization finished."
}

main "$@"
