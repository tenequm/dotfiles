#!/usr/bin/env zsh

export PATH="/usr/local/opt/gnu-tar/libexec/gnubin:$HOME/bin:/usr/local/sbin:$PATH:$HOME/go/bin"
export MANPATH="/usr/local/opt/gnu-tar/libexec/gnuman:$MANPATH"
export EDITOR=vim
export DEFAULT_USER=tenequm
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export SSH_KEY_PATH="~/.ssh/id_rsa"
export JIRA_URL="https://cartfresh.atlassian.net"
export JIRA_PREFIX="ITS"
export JIRA_NAME="tenequm"
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES
export TERM=screen-256color

export WORKON_HOME=~/.virtualenvs # Virtualenv dependency
# source /usr/local/bin/virtualenvwrapper.sh
[[ -s ~/.profile ]] && source ~/.profile

fpath=(/usr/local/share/zsh-completions $fpath)

# Oh-my-zsh configs
export ZSH=~/.oh-my-zsh
ZSH_THEME="agnoster"
plugins=(git colored-man-pages colorize github virtualenv pip python brew osx \
         zsh-syntax-highlighting docker pj nmap fzf-zsh zsh-completions pipenv kubectl jira)
source $ZSH/oh-my-zsh.sh
PROJECT_PATHS=(~/Projects ~/Local)
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

source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc'
source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc'

if which jenv > /dev/null; then eval "$(jenv init -)"; fi

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/local/bin/vault vault
export PATH="/usr/local/opt/mysql-client/bin:$PATH"
#source <(helm completion zsh)
source <(helm completion zsh | sed 's/aliashash\["\(\w\+\)"\]/aliashash[\1]/g')
export PATH="/usr/local/opt/redis@4.0/bin:$PATH"
