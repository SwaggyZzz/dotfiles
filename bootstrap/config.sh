# 远端自举配置。用户只下载 bootstrap/setup.sh 时，脚本会配置 GitHub SSH key，
# 再 clone 完整 dotfiles 仓库后继续执行初始化。
: "${DOTFILES_REPO_SSH:=git@github.com:SwaggyZzz/dotfiles.git}"
: "${DOTFILES_REPO_BRANCH:=main}"
: "${DOTFILES_TARGET_DIR:=$HOME/.dotfiles}"
: "${GITHUB_SSH_KEY:=$HOME/.ssh/id_ed25519_github}"
