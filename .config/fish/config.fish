# dotfiles 主 shell 配置。这里保持和原 zsh 配置等价的工具链与环境变量。

# 关闭 fish 默认欢迎语。
set -g fish_greeting

# Homebrew 先进入当前会话，后续工具初始化才能稳定找到可执行文件。
if test -x /opt/homebrew/bin/brew
    /opt/homebrew/bin/brew shellenv | source
else if type -q brew
    brew shellenv | source
end

set -gx EDITOR nvim
set -gx LANG zh_CN.UTF-8
set -gx CONSUL_HTTP_HOST 10.37.106.5
set -gx CURRENT_DCAR_USER_NAME zhangben.fe

# Python、Go、pnpm 的主目录和私有仓库配置。
set -gx PYENV_ROOT "$HOME/.pyenv"
set -gx GOPATH "$HOME/go"
set -gx GOBIN "$GOPATH/bin"
set -gx GOPRIVATE code.byted.org
set -gx GONOSUMDB code.byted.org
set -gx GONOPROXY code.byted.org
set -gx PNPM_HOME "$HOME/Library/pnpm"

# 统一维护 PATH，fish_add_path 会自动跳过不存在的目录并避免重复项。
fish_add_path --global --move \
    "$HOME/bin" \
    /opt/homebrew/sbin \
    /opt/homebrew/bin \
    "$HOME/.local/bin" \
    /usr/local/mysql/bin \
    /opt/homebrew/opt/pnpm@8/bin \
    "$PYENV_ROOT/bin" \
    "$GOBIN" \
    "$PNPM_HOME"

# 交互体验初始化。
if status is-interactive
    if type -q starship
        starship init fish | source
    end

    if type -q zoxide
        zoxide init fish | source
    end
end

# 版本管理器初始化保持 shell-neutral，Node 统一走 fnm。
if type -q fnm
    fnm env --use-on-cd --shell fish | source
end

if type -q pyenv
    pyenv init - fish | source
end

# 常用命令别名。
alias v="nvim"
alias cat="bat"
alias ls="lsd"

# 用 yazi 选择目录后同步回当前 shell。
function y
    set -l tmp (mktemp -t "yazi-cwd.XXXXXX")
    yazi $argv --cwd-file="$tmp"

    set -l cwd (command cat -- "$tmp")
    if test -n "$cwd"; and test "$cwd" != "$PWD"
        builtin cd -- "$cwd"
    end

    command rm -f -- "$tmp"
end

# 常用 git abbreviations，覆盖 Oh My Zsh git 插件里的日常肌肉记忆。
function __dotfiles_abbr_add
    set -l name $argv[1]
    set -e argv[1]

    if not abbr --query "$name"
        abbr --add --global "$name" $argv
    end
end

__dotfiles_abbr_add gst git status
__dotfiles_abbr_add ga git add
__dotfiles_abbr_add gaa git add --all
__dotfiles_abbr_add gc git commit
__dotfiles_abbr_add gcmsg git commit -m
__dotfiles_abbr_add gco git checkout
__dotfiles_abbr_add gcb git checkout -b
__dotfiles_abbr_add gb git branch
__dotfiles_abbr_add gl git pull
__dotfiles_abbr_add gp git push
__dotfiles_abbr_add gpf git push --force-with-lease
__dotfiles_abbr_add gpl git pull --rebase
__dotfiles_abbr_add gd git diff
__dotfiles_abbr_add gds git diff --staged
__dotfiles_abbr_add glgg git log --graph
__dotfiles_abbr_add glog git log --oneline --decorate --graph
__dotfiles_abbr_add gsta git stash push
__dotfiles_abbr_add gstp git stash pop

functions --erase __dotfiles_abbr_add
