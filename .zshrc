#!/usr/bin/env zsh

# Skip interactive config when running inside Claude Code
# Prevents shell snapshot from capturing completions, aliases, prompts
if [[ -n "$CLAUDECODE" ]]; then
  return
fi

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
export LS_COLORS='rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=00:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.7z=01;31:*.ace=01;31:*.alz=01;31:*.apk=01;31:*.arc=01;31:*.arj=01;31:*.bz=01;31:*.bz2=01;31:*.cab=01;31:*.cpio=01;31:*.crate=01;31:*.deb=01;31:*.drpm=01;31:*.dwm=01;31:*.dz=01;31:*.ear=01;31:*.egg=01;31:*.esd=01;31:*.gz=01;31:*.jar=01;31:*.lha=01;31:*.lrz=01;31:*.lz=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.lzo=01;31:*.pyz=01;31:*.rar=01;31:*.rpm=01;31:*.rz=01;31:*.sar=01;31:*.swm=01;31:*.t7z=01;31:*.tar=01;31:*.taz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tgz=01;31:*.tlz=01;31:*.txz=01;31:*.tz=01;31:*.tzo=01;31:*.tzst=01;31:*.udeb=01;31:*.war=01;31:*.whl=01;31:*.wim=01;31:*.xz=01;31:*.z=01;31:*.zip=01;31:*.zoo=01;31:*.zst=01;31:*.avif=01;35:*.jpg=01;35:*.jpeg=01;35:*.jxl=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.webp=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:*~=00;90:*#=00;90:*.bak=00;90:*.crdownload=00;90:*.dpkg-dist=00;90:*.dpkg-new=00;90:*.dpkg-old=00;90:*.dpkg-tmp=00;90:*.old=00;90:*.orig=00;90:*.part=00;90:*.rej=00;90:*.rpmnew=00;90:*.rpmorig=00;90:*.rpmsave=00;90:*.swp=00;90:*.tmp=00;90:*.ucf-dist=00;90:*.ucf-new=00;90:*.ucf-old=00;90:'

# =============================================================================
# PATH Setup
# =============================================================================
# Re-prepend Homebrew after Nix (Nix injects itself into /etc/zshrc, which runs before this file)
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$HOME/bin:$HOME/.local/bin:/usr/local/sbin:$PATH"

# =============================================================================
# Shell Performance Reference
# =============================================================================
# compinit: The completion system is the #1 startup cost (25-450ms).
#   - compinit -C skips compaudit (security check) + dump staleness check = ~5ms vs ~35ms
#   - The "check once per day" pattern in fzf-tab's pre-hook handles this
#   - zcompdump.zwc (byte-compiled) saves ~12ms on sourcing
#   - Ensure compinit is called exactly ONCE (check with zprof call count)
#   - After installing new tools: rm ~/.zcompdump* and restart shell
#
# mise: Runs `mise hook-env` binary on every prompt via _mise_hook_precmd (~17ms).
#   - hook_env.chpwd_only=true: only run on cd, not every prompt (biggest win)
#   - hook_env.cache_ttl="5s": skip filesystem stat checks within TTL
#   - After editing mise.toml without cd: run `cd .` to force refresh
#   - Settings live in ~/.config/mise/config.toml
#
# fzf-tab: Pure zsh LS_COLORS parsing is the main per-completion bottleneck.
#   - build-fzf-tab-module: compiles C module for 5-10x faster completion
#   - Module lives at ~/.local/share/sheldon/repos/.../modules/Src/aloxaf/fzftab.so
#   - Rebuild after zsh or fzf-tab updates: run build-fzf-tab-module in shell
#   - zstyle ':completion:*' menu no  - lets fzf-tab handle all completions
#
# Profile: zmodload zsh/zprof at top of .zshrc, zprof at bottom
# Benchmark: for i in {1..5}; do /usr/bin/time zsh -i -c exit; done

# =============================================================================
# Completion Setup (MUST be before Sheldon)
# =============================================================================
# NOTE: compinit is now handled by fzf-tab plugin for proper initialization order
# We only set up fpath here - fzf-tab will call compinit at the right time

# Additional completion paths (set BEFORE Sheldon loads)
fpath=(/opt/homebrew/share/zsh/site-functions /opt/homebrew/share/zsh-completions $fpath)
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
# Modern completion settings (menu no lets fzf-tab capture the unambiguous prefix)
zstyle ':completion:*' menu no
# matcher-list stays off: adds case-insensitive + partial-word matching (behavior change)
# zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*:descriptions' format '[%d]'
# list-colors is cheap only while the fzf-tab binary module is built (build-fzf-tab-module)
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# FZF-Tab specific settings
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath 2>/dev/null || ls -1 --color=always $realpath'
zstyle ':fzf-tab:complete:git-checkout:*' fzf-preview 'git show --color=always $word 2>/dev/null'
zstyle ':fzf-tab:complete:git-add:*' fzf-preview 'git diff --color=always $word 2>/dev/null'
zstyle ':fzf-tab:*' switch-group '<' '>'

# Performance optimizations
zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path ~/.zsh/cache

# zsh-autosuggestions configuration
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#ff00ff,bg=cyan,bold,underline"  # Old: Very prominent styling
# ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=8"  # New: Dim gray - subtle and unobtrusive
ZSH_AUTOSUGGEST_STRATEGY=(history match_prev_cmd)  # FIXED: removed 'completion' to avoid lag on every keystroke
# ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20  # Limit buffer size for performance
ZSH_AUTOSUGGEST_USE_ASYNC=1  # Enable async mode for better performance

# Byte-compile zcompdump in background (saves ~12ms on next startup)
{
    zcompdump="${ZDOTDIR:-$HOME}/.zcompdump"
    if [[ -s "$zcompdump" && (! -s "${zcompdump}.zwc" || "$zcompdump" -nt "${zcompdump}.zwc") ]]; then
        zcompile "$zcompdump"
    fi
} &!

# Initialize Starship prompt (must NOT be deferred - needed immediately for prompt)
eval "$(starship init zsh)"

# ZSH Options (after Sheldon to avoid conflicts)
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt NO_BEEP
setopt NO_LIST_BEEP

# =============================================================================
# Project Jump Functionality
# =============================================================================
# root:depth per command (depth 2 = owner/repo layout)
typeset -A _PJUMP_ROOTS=(pj "$HOME/Projects:1" pjv "$HOME/pjv:2" pjd "$HOME/pjd:1")

_pjump() {
    local root depth
    IFS=: read -r root depth <<<"${_PJUMP_ROOTS[$1]}"; shift
    if [[ $# -eq 0 ]]; then
        [[ -d "$root" ]] && find "$root" -mindepth $depth -maxdepth $depth -type d | sed "s|^$root/||"
    elif [[ -d "$root/$1" ]]; then
        cd "$root/$1"
    else
        echo "'$1' not found in $root"
    fi
}
pj()  { _pjump pj  "$@" }
pjv() { _pjump pjv "$@" }
pjd() { _pjump pjd "$@" }

_pjump_complete() {
    local root depth
    IFS=: read -r root depth <<<"${_PJUMP_ROOTS[$service]}"
    [[ -d "$root" ]] && compadd $(find "$root" -mindepth $depth -maxdepth $depth -type d | sed "s|^$root/||")
}
compdef _pjump_complete pj pjv pjd

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

# MISE - activated in ~/.zshenv (runs for both interactive and Claude Code shells)

# Atuin - intelligent shell history (deferred; -c so the atuin binary also runs deferred)
zsh-defer -c 'eval "$(atuin init zsh --disable-up-arrow)"'

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


# pnpm - PNPM_HOME / PATH set in ~/.zshenv
export COMPOSE_BAKE=true

# Wrapper to restore terminal state after Claude Code exit
# Fixes: kitty protocol leak (5u sequences), broken Ctrl-C/U/D, bracketed paste
# See: anthropics/claude-code#38625, manaflow-ai/cmux#1526
# claude() {
#     command claude "$@"
#     printf '\033[?2004l\033[>4;0m\033[<u'
#     stty sane 2>/dev/null
# }

# pyenv disabled - using mise instead
# export PYENV_ROOT="$HOME/.pyenv"
# [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"

# =============================================================================
# Cached Completions (for faster startup)
# =============================================================================
# NOTE: Source cached completion files instead of generating them on every shell start
# To regenerate cache after tool updates, run: regen-completions
# _uv/_uvx live in ~/.zsh/completions (in fpath before compinit) - autoloaded lazily, no sourcing needed
# export MCP_MAX_MESSAGE_SIZE=10000000
# export MAX_MCP_OUTPUT_TOKENS=50000
export PATH="$HOME/.local/share/solana/install/active_release/bin:$PATH"

# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# eval "$(direnv hook zsh)"

# Added by Antigravity
export PATH="/Users/tenequm/.antigravity/antigravity/bin:$PATH"

# Zoxide (better cd) - replaces cd with smart frecency-based navigation
# zsh-defer eval "$(zoxide init zsh --cmd cd)"

eval "$(zoxide init zsh)"


# # >>> forge initialize >>>
# # !! Contents within this block are managed by 'forge zsh setup' !!
# # !! Do not edit manually - changes will be overwritten !!

# # Add required zsh plugins if not already present
# if [[ ! " ${plugins[@]} " =~ " zsh-autosuggestions " ]]; then
#     plugins+=(zsh-autosuggestions)
# fi
# if [[ ! " ${plugins[@]} " =~ " zsh-syntax-highlighting " ]]; then
#     plugins+=(zsh-syntax-highlighting)
# fi

# # Load forge shell plugin (commands, completions, keybindings) if not already loaded
# if [[ -z "$_FORGE_PLUGIN_LOADED" ]]; then
#     eval "$(forge zsh plugin)"
# fi

# # Load forge shell theme (prompt with AI context) if not already loaded
# if [[ -z "$_FORGE_THEME_LOADED" ]]; then
#     eval "$(forge zsh theme)"
# fi

# # Editor for editing prompts (set during setup)
# # To change: update FORGE_EDITOR or remove to use $EDITOR
# export FORGE_EDITOR="nvim"
# # <<< forge initialize <<<

# pnpm
export PNPM_HOME="/Users/tenequm/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME/bin:"*) ;;
  *) export PATH="$PNPM_HOME/bin:$PATH" ;;
esac
# pnpm end

# Added by Antigravity IDE
export PATH="/Users/tenequm/.antigravity-ide/antigravity-ide/bin:$PATH"


# Added by Antigravity CLI installer
export PATH="/Users/tenequm/.local/bin:$PATH"
