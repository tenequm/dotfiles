#!/usr/bin/env zsh

export PATH="/usr/local/opt/gnu-tar/libexec/gnubin:$HOME/bin:/usr/local/sbin:$PATH:$HOME/go/bin"
export MANPATH="/usr/local/opt/gnu-tar/libexec/gnuman:$MANPATH"
export EDITOR=vim
export DEFAULT_USER=tenequm
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export SSH_KEY_PATH="~/.ssh/id_ed25519"
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES
export TERM=screen-256color

export WORKON_HOME=~/.virtualenvs # Virtualenv dependency test
# source /usr/local/bin/virtualenvwrapper.sh

fpath=(/usr/local/share/zsh-completions $fpath)

# Oh-my-zsh configs
export ZSH=~/.oh-my-zsh
ZSH_THEME="agnoster"
plugins=(git colored-man-pages colorize github virtualenv pip python brew osx \
         zsh-syntax-highlighting docker pj nmap pipenv kubectl aws)
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

if which jenv > /dev/null; then eval "$(jenv init -)"; fi

autoload -U +X bashcompinit && bashcompinit
source <(helm completion zsh | sed 's/aliashash\["\(\w\+\)"\]/aliashash[\1]/g')

# Add gnu-getopt ti PATH
export PATH="/usr/local/Cellar/gnu-getopt/1.1.6/bin":$PATH

# Ruby development configs
# https://github.com/monfresh/install-ruby-on-macos
export PATH="$HOME/.bin:$PATH"
export PATH="/usr/local/bin:$PATH"
source /usr/local/share/chruby/chruby.sh
source /usr/local/share/chruby/auto.sh

alias laptop='bash <(curl -s https://raw.githubusercontent.com/monfresh/laptop/master/laptop)'

eval "$(nodenv init -)"

export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && . "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
