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

# 根据当前仓库配置安装常用工具：fish、shell prompt、终端辅助工具、Neovim、tmux、zellij、
# AeroSpace、Node/Python 版本管理器，以及搜索和导航工具。
install_cli_tools() {
  install_homebrew || return 1

  brew_install_if_missing git git
  brew_install_if_missing stow stow
  brew_install_if_missing fish fish
  brew_install_if_missing tmux tmux
  brew_install_if_missing neovim nvim
  brew_install_if_missing tree-sitter-cli tree-sitter
  brew_install_if_missing go go
  brew_install_if_missing fnm fnm
  brew_install_if_missing pyenv pyenv
  brew_install_if_missing starship starship
  brew_install_if_missing zoxide zoxide
  brew_install_if_missing bat bat
  brew_install_if_missing lsd lsd
  brew_install_if_missing ripgrep rg
  brew_install_if_missing fd fd
  brew_install_if_missing fzf fzf
  brew_install_if_missing lazygit lazygit
  install_aerospace
}
