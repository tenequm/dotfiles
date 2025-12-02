#!/usr/bin/env zsh

# =============================================================================
# Environment Variables
# =============================================================================
export EDITOR=vim
# export EDITOR="cursor --wait"
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export XDG_CONFIG_HOME="${HOME}/.config"
export KEYTIMEOUT=1
export DEFAULT_USER="$(whoami)"

# =============================================================================
# PATH Setup
# =============================================================================
export PATH="/opt/homebrew/bin:$HOME/bin:$HOME/.local/bin:/usr/local/sbin:$PATH"

# =============================================================================
# Completion Setup (MUST be before Sheldon)
# =============================================================================
# NOTE: compinit is now handled by fzf-tab plugin for proper initialization order
# We only set up fpath here - fzf-tab will call compinit at the right time

# Additional completion paths (set BEFORE Sheldon loads)
fpath=(/usr/local/share/zsh-completions $fpath)
fpath=($HOME/.docker/completions $fpath)
fpath=($HOME/.zsh/completions $fpath)  # Cached completions directory

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
# # Modern completion settings
# zstyle ':completion:*' menu no
# zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
# zstyle ':completion:*:descriptions' format '[%d]'
# zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# # FZF-Tab specific settings (if you install fzf-tab plugin)
# zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath 2>/dev/null || ls -1 --color=always $realpath'
# zstyle ':fzf-tab:complete:git-checkout:*' fzf-preview 'git show --color=always $word 2>/dev/null'
# zstyle ':fzf-tab:complete:git-add:*' fzf-preview 'git diff --color=always $word 2>/dev/null'
# zstyle ':fzf-tab:*' switch-group '<' '>'

# # Performance optimizations
# zstyle ':completion:*' use-cache yes
# zstyle ':completion:*' cache-path ~/.zsh/cache

# zsh-autosuggestions configuration
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#ff00ff,bg=cyan,bold,underline"  # Old: Very prominent styling
# ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=8"  # New: Dim gray - subtle and unobtrusive
ZSH_AUTOSUGGEST_STRATEGY=(history match_prev_cmd)  # FIXED: removed 'completion' to avoid lag on every keystroke
# ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20  # Limit buffer size for performance
ZSH_AUTOSUGGEST_USE_ASYNC=1  # Enable async mode for better performance

# Initialize Starship prompt (must NOT be deferred - needed immediately for prompt)
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

# Tab completion for pj (cached for performance)
_pj() {
    # Cache results for 1 hour to avoid running find on every tab press
    local cache_file="$HOME/.cache/pj_projects_cache"
    local cache_max_age=3600  # 1 hour in seconds

    # Create cache directory if it doesn't exist
    mkdir -p "$(dirname "$cache_file")"

    # Regenerate cache if it doesn't exist or is too old
    if [[ ! -f "$cache_file" ]] || [[ $(( $(date +%s) - $(stat -f %m "$cache_file" 2>/dev/null || echo 0) )) -gt $cache_max_age ]]; then
        local projects=()
        for project_path in $PROJECT_PATHS; do
            if [[ -d "$project_path" ]]; then
                projects+=($(find "$project_path" -mindepth 1 -maxdepth 1 -type d -exec basename {} \;))
            fi
        done
        printf "%s\n" "${projects[@]}" > "$cache_file"
    fi

    # Read from cache
    local cached_projects
    cached_projects=(${(f)"$(<$cache_file)"})
    compadd "${cached_projects[@]}"
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
# # SSH agent (deferred to avoid blocking startup)
ssh-add 2>/dev/null

# Load keys from keychain on shell startup (Apple's ssh-add)
# /usr/bin/ssh-add --apple-load-keychain 2>/dev/null

# FZF (file finder Ctrl+T, directory jumper Alt+C)
# Load fzf but unbind Ctrl+R history widget (we use atuin for that)
# if [ -f ~/.fzf.zsh ]; then
#     source ~/.fzf.zsh
#     # Unbind fzf's history widget - atuin handles Ctrl+R
#     bindkey -r '^R'
# fi

# MISE - replaces pyenv, nvm, pnpm, etc. (NOT deferred - needed for PATH immediately)
eval "$(mise activate zsh)"


# Atuin - intelligent shell history (deferred for faster startup)
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

# Regenerate completion cache
# Run this after updating uv, pyenv, or other tools to refresh completions
function regen-completions() {
	echo "Regenerating completion cache..."
	mkdir -p ~/.zsh/completions

	# Generate pyenv completions
	if command -v pyenv &> /dev/null; then
		echo "eval \"\$(pyenv init - zsh)\"" > ~/.zsh/completions/_pyenv
		echo "  ✓ pyenv completions cached"
	fi

	# Generate uv completions
	if command -v uv &> /dev/null; then
		uv generate-shell-completion zsh > ~/.zsh/completions/_uv
		echo "  ✓ uv completions cached"
	fi

	# Generate uvx completions
	if command -v uvx &> /dev/null; then
		uvx --generate-shell-completion zsh > ~/.zsh/completions/_uvx
		echo "  ✓ uvx completions cached"
	fi

	echo "Cache regeneration complete! Restart your shell or run: source ~/.zshrc"
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

# =============================================================================
# Cached Completions (for faster startup)
# =============================================================================
# NOTE: Source cached completion files instead of generating them on every shell start
# To regenerate cache after tool updates, run: regen-completions
[[ -f ~/.zsh/completions/_pyenv ]] && source ~/.zsh/completions/_pyenv
[[ -f ~/.zsh/completions/_uv ]] && source ~/.zsh/completions/_uv
[[ -f ~/.zsh/completions/_uvx ]] && source ~/.zsh/completions/_uvx
export MCP_MAX_MESSAGE_SIZE=10000000
export MAX_MCP_OUTPUT_TOKENS=50000
export PATH="$HOME/.local/share/solana/install/active_release/bin:$PATH"

# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# eval "$(direnv hook zsh)"

# Added by Antigravity
export PATH="/Users/tenequm/.antigravity/antigravity/bin:$PATH"

# Zoxide (better cd) - replaces cd with smart frecency-based navigation
# zsh-defer eval "$(zoxide init zsh --cmd cd)"

eval "$(zoxide init zsh)"
