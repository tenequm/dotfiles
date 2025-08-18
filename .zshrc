#!/usr/bin/env zsh

# =============================================================================
# Environment Variables
# =============================================================================
export EDITOR=vim
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export XDG_CONFIG_HOME="${HOME}/.config"
export KEYTIMEOUT=1
export DEFAULT_USER="$(whoami)"

# =============================================================================
# PATH Setup
# =============================================================================
export PATH="/opt/homebrew/bin:$HOME/bin:/usr/local/sbin:$PATH"

# =============================================================================
# Completion Setup (MUST be before Sheldon)
# =============================================================================
# # Initialize completions early
# autoload -U compinit; compinit

# Fast compinit with daily cache check
autoload -Uz compinit
if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

# Additional completion paths
fpath=(/usr/local/share/zsh-completions $fpath)
fpath=($HOME/.docker/completions $fpath)

# ZSH Options (before Sheldon)
# setopt AUTO_CD
# setopt AUTO_PUSHD
# setopt PUSHD_IGNORE_DUPS

# =============================================================================
# Sheldon Plugin Manager
# =============================================================================
eval "$(sheldon source)"

# =============================================================================
# Modern Completion Configuration (AFTER Sheldon)
# =============================================================================
# Modern completion settings
zstyle ':completion:*' menu no
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# FZF-Tab specific settings (if you install fzf-tab plugin)
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath 2>/dev/null || ls -1 --color=always $realpath'
zstyle ':fzf-tab:complete:git-checkout:*' fzf-preview 'git show --color=always $word 2>/dev/null'
zstyle ':fzf-tab:complete:git-add:*' fzf-preview 'git diff --color=always $word 2>/dev/null'
zstyle ':fzf-tab:*' switch-group '<' '>'

# Performance optimizations
zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path ~/.zsh/cache

# zsh-autosuggestions configuration
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#ff00ff,bg=cyan,bold,underline"  # Customize appearance
ZSH_AUTOSUGGEST_STRATEGY=(history completion)  # Use both history and completion
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20  # Limit buffer size for performance
ZSH_AUTOSUGGEST_USE_ASYNC=1  # Enable async mode for better performance

# Initialize Starship prompt
eval "$(starship init zsh)"

# ZSH Options (after Sheldon to avoid conflicts)
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS

# =============================================================================
# Project Jump Functionality (replaces pj plugin)
# =============================================================================
# Project paths
PROJECT_PATHS=("$HOME/Projects")

# pj function - jump to projects
pj() {
    if [[ $# -eq 0 ]]; then
        # List projects
        for project_path in $PROJECT_PATHS; do
            if [[ -d "$project_path" ]]; then
                find "$project_path" -mindepth 1 -maxdepth 1 -type d -exec basename {} \;
            fi
        done
    else
        # Jump to project
        local project_name="$1"
        for project_path in $PROJECT_PATHS; do
            local full_path="$project_path/$project_name"
            if [[ -d "$full_path" ]]; then
                cd "$full_path"
                return
            fi
        done
        echo "Project '$project_name' not found"
    fi
}

# Tab completion for pj
_pj() {
    local projects=()
    for project_path in $PROJECT_PATHS; do
        if [[ -d "$project_path" ]]; then
            projects+=($(find "$project_path" -mindepth 1 -maxdepth 1 -type d -exec basename {} \;))
        fi
    done
    compadd "${projects[@]}"
}
compdef _pj pj

# =============================================================================
# Key Bindings
# =============================================================================
# restore the old behavior (emacs keymap
bindkey -e

bindkey '^U' backward-kill-line
bindkey '^O' vi-cmd-mode
bindkey "^X\\x7f" backward-kill-line
bindkey "^X^_" redo

# Native vim-like navigation
bindkey '^P' up-line-or-history
bindkey '^N' down-line-or-history
# bindkey '^P' up-line-or-search
# bindkey '^N' down-line-or-search

# =============================================================================
# Tool Initialization
# =============================================================================
# # SSH agent
ssh-add 2>/dev/null

# Load keys from keychain on shell startup (Apple's ssh-add)
# /usr/bin/ssh-add --apple-load-keychain 2>/dev/null

# FZF
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# MISE - replaces pyenv, nvm, pnpm, etc.
eval "$(mise activate zsh)"

# Zoxide (better cd)
eval "$(zoxide init zsh)"

# Atuin - intelligent shell history
eval "$(atuin init zsh --disable-up-arrow)"

# =============================================================================
# Custom Functions
# =============================================================================
# Yazi file manager with cd integration
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# =============================================================================
# Aliases
# =============================================================================
# Safe dircolors alias
command -v gdircolors >/dev/null && alias dircolors='gdircolors'

# Source external aliases
export ALIASFILE="$HOME/.aliasesrc" && source $ALIASFILE

# =============================================================================
# Final Setup
# =============================================================================
# Local environment (if exists)
[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"


# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
export COMPOSE_BAKE=true

alias claude="~/.claude/local/claude"

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - zsh)"
eval "$(uv generate-shell-completion zsh)"
eval "$(uvx --generate-shell-completion zsh)"
source ~/.zshenv
