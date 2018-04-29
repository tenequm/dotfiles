#!/usr/bin/env zsh

export PATH="$HOME/bin:/usr/local/sbin:$PATH:$HOME/go/bin"
export EDITOR=vim
export DEFAULT_USER=tenequm
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export SSH_KEY_PATH="~/.ssh/id_rsa"

export WORKON_HOME=~/.virtualenvs # Virtualenv dependency
# source /usr/local/bin/virtualenvwrapper.sh
[[ -s ~/.profile ]] && source ~/.profile

fpath=(/usr/local/share/zsh-completions $fpath)

# Oh-my-zsh configs
export ZSH=~/.oh-my-zsh
ZSH_THEME="agnoster"
plugins=(git colored-man-pages colorize github virtualenv pip python brew osx \
         zsh-syntax-highlighting docker pj nmap fzf-zsh zsh-completions pipenv)
source $ZSH/oh-my-zsh.sh
PROJECT_PATHS=(~/Local ~/Projects)
export POWERLINE_CONFIG_COMMAND="/usr/local/bin/powerline-config"

# Source aliases
export ALIASFILE=~/.aliasesrc
source $ALIASFILE

# Bindkeys
export KEYTIMEOUT=1
bindkey '^U' kill-whole-line
bindkey '^O' vi-cmd-mode
bindkey '^B' fuck-command-line

ssh-add 2>/dev/null

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
