# 安装当前终端和 sketchybar 配置依赖的字体：
# - JetBrainsMono Nerd Font：Alacritty、kitty 以及图标字符回退使用。
# - Maple Mono NF CN：kitty 用它映射中文字符。
# - SF Symbols 和 sketchybar-app-font：sketchybar 图标使用。
# - SF Pro：sketchybar 文本标签使用，很多 macOS 已内置；新机器缺少时用 cask 补齐。
install_fonts() {
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
