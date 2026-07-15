# 通过 fnm 安装 Node.js LTS。运行时初始化由各 shell 配置负责，fish 主路径使用
# `fnm env --use-on-cd --shell fish`。
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
