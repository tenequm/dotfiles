#!/usr/bin/env zsh

export PATH="/usr/local/opt/gnu-tar/libexec/gnubin:$HOME/bin:/usr/local/sbin:$PATH:$HOME/go/bin:/usr/local/opt/python@3.10/Frameworks/Python.framework/Versions/3.10/bin"
export MANPATH="/usr/local/opt/gnu-tar/libexec/gnuman:$MANPATH"
export EDITOR=vim
export DEFAULT_USER=tenequm
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export SSH_KEY_PATH="~/.ssh/id_ed25519"
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES
export TERM=screen-256color
export XDG_CONFIG_HOME="${HOME}/.config"

export WORKON_HOME=~/.virtualenvs # Virtualenv dependency test
# source /usr/local/bin/virtualenvwrapper.sh

fpath=(/usr/local/share/zsh-completions $fpath)

# Oh-my-zsh configs
export ZSH=~/.oh-my-zsh
ZSH_THEME="agnoster"
plugins=(git colored-man-pages colorize github virtualenv pip python brew macos \
         docker pj nmap pipenv kubectl aws)
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
# bindkey '^B' fuck-command-line

ssh-add 2>/dev/null

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

if which jenv > /dev/null; then eval "$(jenv init -)"; fi

autoload -U +X bashcompinit && bashcompinit
source <(helm completion zsh | sed 's/aliashash\["\(\w\+\)"\]/aliashash[\1]/g')

# Add gnu-getopt ti PATH
export PATH="/usr/local/Cellar/gnu-getopt/1.1.6/bin":$PATH

alias laptop='bash <(curl -s https://raw.githubusercontent.com/monfresh/laptop/master/laptop)'

eval "$(nodenv init -)"

# Google Cloud SDK
source /opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc
source /opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc

# Bindings https://stackoverflow.com/a/29403520/16929294
bindkey "^U" backward-kill-line
bindkey "^X\\x7f" backward-kill-line
bindkey "^X^_" redo

# Unset strange aws-cli output behaviour
unset LESS

# `cheat` util config
export CHEAT_USE_FZF=true

# pyenv
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
export GOOGLE_APPLICATION_CREDENTIALS='/Users/tenequm/Projects/forseti-tf/terraform-service-account.json'
export NVS_HOME="$HOME/.nvs"
[ -s "$NVS_HOME/nvs.sh" ] && . "$NVS_HOME/nvs.sh"

source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# >>> mamba initialize >>>
# !! Contents within this block are managed by 'mamba init' !!
export MAMBA_EXE="/Users/tenequm/.micromamba/bin/micromamba";
export MAMBA_ROOT_PREFIX="/Users/tenequm/micromamba";
__mamba_setup="$('/Users/tenequm/.micromamba/bin/micromamba' shell hook --shell zsh --prefix '/Users/tenequm/micromamba' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__mamba_setup"
else
    if [ -f "/Users/tenequm/micromamba/etc/profile.d/micromamba.sh" ]; then
        . "/Users/tenequm/micromamba/etc/profile.d/micromamba.sh"
    else
        export  PATH="/Users/tenequm/micromamba/bin:$PATH"  # extra space after export prevents interference from conda init
    fi
fi
unset __mamba_setup
# <<< mamba initialize <<<

# # >>> conda initialize >>>
# # !! Contents within this block are managed by 'conda init' !!
# __conda_setup="$('/Users/tenequm/micromamba/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
# if [ $? -eq 0 ]; then
#     eval "$__conda_setup"
# else
#     if [ -f "/Users/tenequm/micromamba/etc/profile.d/conda.sh" ]; then
#         . "/Users/tenequm/micromamba/etc/profile.d/conda.sh"
#     else
#         export PATH="/Users/tenequm/micromamba/bin:$PATH"
#     fi
# fi
# unset __conda_setup
# # <<< conda initialize <<<
