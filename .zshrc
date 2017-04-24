# Exports
# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH="$HOME/Library/Python/2.7/bin:/usr/local/sbin:$PATH"
export EDITOR=vim
export DEFAULT_USER=mykhaylokolesnik
# You may need to manually set your language environment
export LANG=en_US.UTF-8
export SSH_KEY_PATH="~/.ssh/id_rsa"
export ANSIBLE_VAULT_PASSWORD_FILE=~/.vault_pass.txt

# Open argument in Dash
function dash() {
  open "dash://$*"
  }
function dman() {
  open "dash://manpages:$*"
}

# source aliases
ALIASFILE=~/.aliasesrc
source $ALIASFILE
function add_alias() {
    if [[ -z $1 || -z $2 || $# -gt 2 ]]; then
        echo usage:
        echo "\t\$$0 ll 'ls -l'"
    else
        echo "alias $1='$2'" >> $ALIASFILE
        echo "alias ADDED to $ALIASFILE"
    fi
}

# Oh-my-zsh configs
export ZSH=/Users/mykhaylokolesnik/.oh-my-zsh
ZSH_THEME="agnoster"
# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
plugins=(git colored-man-pages colorize github vagrant virtualenv pip python brew osx zsh-syntax-highlighting docker yii2 composer pj vi-mode httpie)
source $ZSH/oh-my-zsh.sh
PROJECT_PATHS=(~/Projects)
export POWERLINE_CONFIG_COMMAND="/Users/mykhaylokolesnik/Library/Python/2.7/bin/powerline-config"
