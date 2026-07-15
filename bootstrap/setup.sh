#!/usr/bin/env bash

# 遇到错误、未定义变量或管道中任一步失败时立即退出，避免前面初始化失败
# 却被后续步骤掩盖。
set -Eeuo pipefail

# 根据脚本所在位置计算路径，因此可以从任意工作目录执行。
BOOTSTRAP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(cd "$BOOTSTRAP_DIR/.." && pwd)"

bootstrap_log_info() {
  printf '\033[0;36m[INFO]\033[0m %s\n' "$1"
}

bootstrap_log_success() {
  printf '\033[0;32m[OK]\033[0m %s\n' "$1"
}

bootstrap_log_warn() {
  printf '\033[1;33m[WARN]\033[0m %s\n' "$1"
}

bootstrap_log_error() {
  printf '\033[0;31m[ERR]\033[0m %s\n' "$1" >&2
}

bootstrap_confirm() {
  local message="$1"

  printf "%s [y/N] " "$message"
  read -r reply
  case "$reply" in
  y | Y | yes | YES) return 0 ;;
  *) return 1 ;;
  esac
}

bootstrap_has_full_repo() {
  [ -f "$BOOTSTRAP_DIR/config.sh" ] &&
    [ -f "$BOOTSTRAP_DIR/lib/log.sh" ] &&
    [ -f "$BOOTSTRAP_DIR/lib/command.sh" ] &&
    [ -f "$BOOTSTRAP_DIR/lib/prompt.sh" ] &&
    [ -f "$BOOTSTRAP_DIR/lib/platform.sh" ] &&
    [ -f "$BOOTSTRAP_DIR/modules/homebrew.sh" ] &&
    [ -f "$BOOTSTRAP_DIR/modules/packages.sh" ] &&
    [ -f "$BOOTSTRAP_DIR/modules/fonts.sh" ] &&
    [ -f "$BOOTSTRAP_DIR/modules/node.sh" ] &&
    [ -f "$BOOTSTRAP_DIR/modules/dotfiles.sh" ] &&
    [ -f "$BOOTSTRAP_DIR/modules/shell.sh" ]
}

bootstrap_load_config_defaults() {
  if [ -f "$BOOTSTRAP_DIR/config.sh" ]; then
    # shellcheck source=/dev/null
    source "$BOOTSTRAP_DIR/config.sh"
  else
    : "${DOTFILES_REPO_SSH:=git@github.com:SwaggyZzz/dotfiles.git}"
    : "${DOTFILES_REPO_BRANCH:=main}"
    : "${DOTFILES_TARGET_DIR:=$HOME/.dotfiles}"
    : "${GITHUB_SSH_KEY:=$HOME/.ssh/id_ed25519_github}"
  fi
}

bootstrap_require_command() {
  local command_name="$1"

  if command -v "$command_name" >/dev/null 2>&1; then
    return 0
  fi

  bootstrap_log_error "$command_name is required before cloning dotfiles."
  return 1
}

bootstrap_ensure_macos() {
  if [ "$(uname)" != "Darwin" ]; then
    bootstrap_log_error "This bootstrap currently supports macOS only."
    exit 1
  fi
}

bootstrap_usage() {
  cat <<'EOF'
Usage: bootstrap/setup.sh

Initialize this dotfiles environment on macOS.

When this file is downloaded alone, it creates a GitHub SSH key, waits for you
to add the public key to GitHub, clones the full dotfiles repo, then continues
with the normal setup flow.

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

bootstrap_backup_path() {
  local path="$1"
  local backup="${path}.$(date +%Y-%m-%d-%H-%M-%S).bak"
  local index=1

  while [ -e "$backup" ]; do
    backup="${path}.$(date +%Y-%m-%d-%H-%M-%S).bak.$index"
    index=$((index + 1))
  done

  printf '%s\n' "$backup"
}

bootstrap_git_email() {
  git config --global user.email 2>/dev/null || true
}

bootstrap_ensure_ssh_key() {
  bootstrap_require_command ssh-keygen

  local ssh_dir="$HOME/.ssh"
  local key_comment
  key_comment="$(bootstrap_git_email)"
  if [ -z "$key_comment" ]; then
    key_comment="github-dotfiles"
  fi

  mkdir -p "$ssh_dir"
  chmod 700 "$ssh_dir"

  if [ -f "$GITHUB_SSH_KEY" ]; then
    bootstrap_log_success "GitHub SSH key exists: $GITHUB_SSH_KEY"
  else
    bootstrap_log_info "Generating GitHub SSH key: $GITHUB_SSH_KEY"
    ssh-keygen -t ed25519 -C "$key_comment" -f "$GITHUB_SSH_KEY" -N ""
  fi

  if [ ! -f "${GITHUB_SSH_KEY}.pub" ]; then
    bootstrap_log_info "Rebuilding missing public key: ${GITHUB_SSH_KEY}.pub"
    ssh-keygen -y -f "$GITHUB_SSH_KEY" >"${GITHUB_SSH_KEY}.pub"
  fi

  chmod 600 "$GITHUB_SSH_KEY"
  chmod 644 "${GITHUB_SSH_KEY}.pub"
}

bootstrap_ensure_ssh_config() {
  local ssh_config="$HOME/.ssh/config"
  local managed_start="# >>> dotfiles github bootstrap >>>"
  local managed_end="# <<< dotfiles github bootstrap <<<"
  local temp_config
  temp_config="$(mktemp)"

  mkdir -p "$HOME/.ssh"
  if [ -f "$ssh_config" ]; then
    awk -v start="$managed_start" -v end="$managed_end" '
      $0 == start { skip = 1; next }
      $0 == end { skip = 0; next }
      skip != 1 { print }
    ' "$ssh_config" >"$temp_config"
  fi

  {
    printf '%s\n' "$managed_start"
    printf 'Host github.com\n'
    printf '  HostName github.com\n'
    printf '  User git\n'
    printf '  IdentityFile %s\n' "$GITHUB_SSH_KEY"
    printf '  IdentitiesOnly yes\n'
    printf '%s\n' "$managed_end"
    if [ -s "$temp_config" ]; then
      printf '\n'
      cat "$temp_config"
    fi
  } >"${temp_config}.next"

  if [ -f "$ssh_config" ] && cmp -s "$ssh_config" "${temp_config}.next"; then
    rm -f "$temp_config" "${temp_config}.next"
    bootstrap_log_success "SSH config is up to date."
    return 0
  fi

  if [ -f "$ssh_config" ]; then
    local backup
    backup="$(bootstrap_backup_path "$ssh_config")"
    cp "$ssh_config" "$backup"
    bootstrap_log_warn "Backed up existing SSH config to $backup"
  fi

  mv "${temp_config}.next" "$ssh_config"
  rm -f "$temp_config"
  chmod 600 "$ssh_config"
  bootstrap_log_success "Updated SSH config for GitHub."
}

bootstrap_wait_for_github_key() {
  printf '\n'
  bootstrap_log_info "Add this public key to GitHub: https://github.com/settings/keys"
  printf '\n'
  cat "${GITHUB_SSH_KEY}.pub"
  printf '\n\n'
  printf 'Press Enter after the key is configured in GitHub... '
  read -r _

  bootstrap_log_info "Verifying GitHub SSH authentication..."
  local verify_output
  if verify_output="$(ssh -T git@github.com 2>&1)"; then
    printf '%s\n' "$verify_output"
    bootstrap_log_success "GitHub SSH authentication verified."
    return 0
  fi

  printf '%s\n' "$verify_output"
  case "$verify_output" in
  *"successfully authenticated"*)
    bootstrap_log_success "GitHub SSH authentication verified."
    return 0
    ;;
  esac

  bootstrap_log_warn "GitHub SSH verification failed."
  bootstrap_confirm "Continue to clone dotfiles anyway?"
}

bootstrap_clone_or_update_dotfiles() {
  bootstrap_require_command git

  if [ -d "$DOTFILES_TARGET_DIR/.git" ]; then
    bootstrap_log_info "Updating existing dotfiles repo: $DOTFILES_TARGET_DIR"
    git -C "$DOTFILES_TARGET_DIR" pull --ff-only
    return 0
  fi

  if [ -e "$DOTFILES_TARGET_DIR" ]; then
    bootstrap_log_error "Target path already exists and is not a git repo: $DOTFILES_TARGET_DIR"
    return 1
  fi

  bootstrap_log_info "Cloning dotfiles into $DOTFILES_TARGET_DIR"
  git clone --branch "$DOTFILES_REPO_BRANCH" "$DOTFILES_REPO_SSH" "$DOTFILES_TARGET_DIR"
}

bootstrap_remote_mode() {
  bootstrap_load_config_defaults
  bootstrap_validate_args "$@"
  bootstrap_ensure_macos

  bootstrap_log_info "Running remote bootstrap mode."
  bootstrap_ensure_ssh_key
  bootstrap_ensure_ssh_config
  bootstrap_wait_for_github_key
  bootstrap_clone_or_update_dotfiles

  local next_setup="$DOTFILES_TARGET_DIR/bootstrap/setup.sh"
  if [ ! -f "$next_setup" ]; then
    bootstrap_log_error "Cloned repo does not contain bootstrap/setup.sh: $next_setup"
    return 1
  fi
  if [ ! -x "$next_setup" ]; then
    chmod +x "$next_setup" 2>/dev/null || true
  fi

  bootstrap_log_info "Continuing with full dotfiles setup..."
  exec bash "$next_setup" "$@"
}

if ! bootstrap_has_full_repo; then
  bootstrap_remote_mode "$@"
fi

source "$BOOTSTRAP_DIR/config.sh"
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
