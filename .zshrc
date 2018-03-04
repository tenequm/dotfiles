#!/usr/bin/env zsh

export PATH="$HOME/bin:/usr/local/sbin:$PATH:$HOME/go/bin"
export EDITOR=vim
export DEFAULT_USER=mykhaylokolesnik
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export SSH_KEY_PATH="~/.ssh/id_rsa"
export WORKON_HOME=~/Envs # Virtualenv dependency

# Oh-my-zsh configs
export ZSH=/Users/mykhaylokolesnik/.oh-my-zsh
ZSH_THEME="agnoster"
plugins=(git colored-man-pages colorize github virtualenv pip python brew osx zsh-syntax-highlighting docker pj nmap fzf-zsh zsh-completions)
source $ZSH/oh-my-zsh.sh
PROJECT_PATHS=(~/Local ~/Projects)
export POWERLINE_CONFIG_COMMAND="/Users/mykhaylokolesnik/Library/Python/2.7/bin/powerline-config"

# Source aliases
export ALIASFILE=~/.aliasesrc
source $ALIASFILE

# Bindkeys
export KEYTIMEOUT=1
bindkey '^U' kill-whole-line
bindkey '^O' vi-cmd-mode
bindkey '^B' fuck-command-line

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
