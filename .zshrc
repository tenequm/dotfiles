# Fig pre block. Keep at the top of this file.
[[ -f "$HOME/.fig/shell/zshrc.pre.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.pre.zsh"
#!/usr/bin/env zsh

export PATH="/usr/local/opt/gnu-tar/libexec/gnubin:$HOME/bin:/usr/local/sbin:$PATH:$HOME/go/bin:/usr/local/opt/python@3.10/Frameworks/Python.framework/Versions/3.10/bin:$HOME/.local/bin"
export PATH="/usr/local/Cellar/gnu-getopt/1.1.6/bin":$PATH
export EDITOR=vim
export DEFAULT_USER=tenequm
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export SSH_KEY_PATH="~/.ssh/id_ed25519"
export TERM=screen-256color
export XDG_CONFIG_HOME="${HOME}/.config"

fpath=(/usr/local/share/zsh-completions $fpath)

# Oh-my-zsh configs
export ZSH=~/.oh-my-zsh
ZSH_THEME="agnoster"
plugins=(git colored-man-pages colorize github virtualenv pip python brew macos \
  docker pj nmap pipenv kubectl aws command-time kubetail)
source $ZSH/oh-my-zsh.sh
PROJECT_PATHS=(~/Projects)
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


autoload -U +X bashcompinit && bashcompinit
autoload -U compinit; compinit
source <(helm completion zsh | sed 's/aliashash\["\(\w\+\)"\]/aliashash[\1]/g')

eval "$(nodenv init -)"

# Google Cloud SDK
source /opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc
source "/opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"
export USE_GKE_GCLOUD_AUTH_PLUGIN=True

# Bindings https://stackoverflow.com/a/29403520/16929294
bindkey "^U" backward-kill-line
bindkey "^X\\x7f" backward-kill-line
bindkey "^X^_" redo

# pyenv
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# NEAR configs
export NEAR_ENV=shardnet
source "$HOME/.cargo/env"

export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
# place this after nvm initialization!
autoload -U add-zsh-hook
load-nvmrc() {
  local nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$(nvm version)" ]; then
      nvm use
    fi
  elif [ -n "$(PWD=$OLDPWD nvm_find_nvmrc)" ] && [ "$(nvm version)" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}
add-zsh-hook chpwd load-nvmrc
load-nvmrc

# Exclude some commands
# https://github.com/popstas/zsh-command-time
ZSH_COMMAND_TIME_EXCLUDE=(vim mcedit zshconfig aliases)
export PATH=/Users/tenequm/Projects/zombienet/dist:$PATH
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
export PATH="/opt/homebrew/opt/binutils/bin:$PATH"

# stern
source <(stern --completion=zsh)

# lld linker setup https://stackoverflow.com/questions/66081944/invalid-linker-name-in-argument-fuse-ld-lld
export PATH="/opt/homebrew/opt/llvm/bin:$PATH"
. $(pack completion --shell zsh)
export HELM_DIFF_THREE_WAY_MERGE=false

# Fig post block. Keep at the bottom of this file.
[[ -f "$HOME/.fig/shell/zshrc.post.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.post.zsh"
