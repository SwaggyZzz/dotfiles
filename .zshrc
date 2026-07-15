# If you come from bash you might have to change your $PATH.
export PATH="$HOME/bin:/opt/homebrew/sbin:/opt/homebrew/bin:$PATH"

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Starship is initialized after Oh My Zsh, so keep the Oh My Zsh theme empty.
ZSH_THEME=""

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# HIST_STAMPS="mm/dd/yyyy"

# Which plugins would you like to load?
plugins=(F-Sy-H zsh-autosuggestions git zoxide)

# This speeds up pasting with zsh-autosuggestions.
# https://github.com/zsh-users/zsh-autosuggestions/issues/238
pasteinit() {
  OLD_SELF_INSERT=${${(s.:.)widgets[self-insert]}[2,3]}
  zle -N self-insert url-quote-magic
}

pastefinish() {
  zle -N self-insert $OLD_SELF_INSERT
}
zstyle :bracketed-paste-magic paste-init pasteinit
zstyle :bracketed-paste-magic paste-finish pastefinish

source "$ZSH/oh-my-zsh.sh"

if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi

# User configuration
export EDITOR="nvim"
export LANG=zh_CN.UTF-8
export CONSUL_HTTP_HOST="10.37.106.5"
export CURRENT_DCAR_USER_NAME="zhangben.fe"

# Homebrew pnpm@8 and local user bin.
export PATH="$HOME/.local/bin:/usr/local/mysql/bin:/opt/homebrew/opt/pnpm@8/bin:$PATH"

# Pyenv 配置
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv >/dev/null 2>&1; then
  eval "$(SHELL=/bin/zsh PYENV_SHELL=zsh pyenv init --path --no-rehash)"
  eval "$(SHELL=/bin/zsh PYENV_SHELL=zsh pyenv init - --no-rehash)"
fi

# Go environment variables
export GOPATH="$HOME/go"
export GOBIN="$GOPATH/bin"
export PATH="$GOBIN:$PATH"

# Go private module configuration
export GOPRIVATE=code.byted.org
export GONOSUMDB=code.byted.org
export GONOPROXY=code.byted.org

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# 解决 kitty 在 tmux 内 nvim 光标不闪烁问题
# https://github.com/kovidgoyal/kitty/issues/3906
# https://www.reddit.com/r/neovim/comments/1ayq2tn/blinking_cursor_using_kitty_tmux_in_neovim/
alias v="nvim"
# alias nvim='TERM=xterm-kitty nvim'

alias cat="bat"
alias ls="lsd"

function y() {
  local tmp
  tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}
