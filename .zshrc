export PATH="$HOME/bin:/usr/local/sbin:$PATH:$HOME/go/bin"
export EDITOR=vim
export DEFAULT_USER=mykhaylokolesnik
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export SSH_KEY_PATH="~/.ssh/id_rsa"
export DO_API_TOKEN=876e9d7c33cd46ce4e6d2332bf250896937f823003016bc38e9e823849f0a8f2

# Virtualenv dependencies
export WORKON_HOME=~/Envs
source /usr/local/bin/virtualenvwrapper.sh

# Oh-my-zsh configs
export ZSH=/Users/mykhaylokolesnik/.oh-my-zsh
ZSH_THEME="agnoster"
plugins=(git colored-man-pages colorize github vagrant virtualenv pip python brew osx zsh-syntax-highlighting docker yii2 composer pj vi-mode httpie nmap thefuck fzf-zsh zsh-completions kubectl)
source $ZSH/oh-my-zsh.sh
PROJECT_PATHS=(~/Local ~/Projects)
export POWERLINE_CONFIG_COMMAND="/Users/mykhaylokolesnik/Library/Python/2.7/bin/powerline-config"
eval $(thefuck --alias)

# Source tmuxinator completion
autoload -Uz compinit && compinit
source ~/.bin/tmuxinator.zsh

# Source aliases
source ~/.aliasesrc

# Bindkeys
export KEYTIMEOUT=1
bindkey '^U' kill-whole-line
bindkey '^O' vi-cmd-mode
bindkey '^B' fuck-command-line

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
