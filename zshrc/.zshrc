# 若没有下载zinit，那么就下载他
[[ ! -f ~/.zinit/bin/zinit.zsh ]] && {
    command mkdir -p ~/.zinit
    command git clone https://github.com/zdharma-continuum/zinit ~/.zinit/bin
}
source "$HOME/.zinit/bin/zinit.zsh"

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
# 用于优化下载的zinit插件
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

# Load starship theme
# line 1: `starship` binary as command, from github release
# line 2: starship setup at clone(create init.zsh, completion)
# line 3: pull behavior same as clone, source init.zsh
zinit ice as"command" from"gh-r" \
          atclone"./starship init zsh > init.zsh; ./starship completions zsh > _starship" \
          atpull"%atclone" src"init.zsh"
zinit light starship/starship

# 补全等待时显示一些点
COMPLETION_WAITING_DOTS="true"
# 开启错误自动提示
ENABLE_CORRECTION="true"

# oh-my-zsh中常用的插件
# key binding是通用的基础，不适合延迟加载
zinit lucid for OMZ::lib/key-bindings.zsh
zinit ice wait="0" lucid atload="zshz >/dev/null"
zinit light agkozak/zsh-z

# plugins
zinit ice lucid wait='0' atload='_zsh_autosuggest_start'
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-syntax-highlighting
# zinit light mrjohannchang/zsh-interactive-cd # need to install fzf
zinit light "dominik-schwabe/zsh-fnm"
zinit snippet OMZ::plugins/git/git.plugin.zsh
zinit snippet OMZ::lib/directories.zsh
# zinit snippet OMZ::plugins/safe-paste/safe-paste.plugin.zsh
# zinit snippet OMZ::plugins/command-not-found/command-not-found.plugin.zsh

autoload -Uz compinit
compinit
zinit cdreplay -q

# zi for \
#     atload"zicompinit; zicdreplay" \
#     blockf \
#     lucid \
#     wait \
#   zsh-users/zsh-completions

#历史纪录条目数量
export HISTSIZE=1000000
#注销后保存的历史纪录条目数量
export SAVEHIST=500000
#以附加的方式写入历史纪录
setopt INC_APPEND_HISTORY
#如果连续输入的命令相同，历史纪录中只保留一个
setopt HIST_IGNORE_DUPS
#为历史纪录中的命令添加时间戳
setopt EXTENDED_HISTORY
#启用 cd 命令的历史纪录，cd -[TAB]进入历史路径
setopt AUTO_PUSHD
#相同的历史路径只保留一个
setopt PUSHD_IGNORE_DUPS
#在命令前添加空格，不将此命令添加到纪录文件中
setopt HIST_IGNORE_SPACE


# export RUSTUP_DIST_SERVER="https://rsproxy.cn"
# export RUSTUP_UPDATE_ROOT="https://rsproxy.cn/rustup"

alias v="nvim"
alias cat="bat"
alias ls="lsd"
