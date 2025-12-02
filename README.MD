# Modern CLI Environment Setup

A minimal, powerful command-line setup for macOS with Zsh, WezTerm, and Neovim.

## Prerequisites

```bash
# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"
```

## Required Tools

Install these tools via Homebrew:

```bash
brew install zsh sheldon starship mise fzf zoxide atuin yazi ripgrep eza bat fd dust procs gh pnpm wezterm neovim
```

### Tool Links
- **[zsh](https://www.zsh.org/)** - Modern shell
- **[sheldon](https://github.com/rossmacarthur/sheldon)** - Plugin manager for Zsh
- **[starship](https://github.com/starship/starship)** - Cross-shell prompt
- **[mise](https://github.com/jdx/mise)** - Polyglot runtime manager
- **[fzf](https://github.com/junegunn/fzf)** - Command-line fuzzy finder
- **[zoxide](https://github.com/ajeetdsouza/zoxide)** - Smarter cd command
- **[atuin](https://github.com/atuinsh/atuin)** - Magical shell history
- **[yazi](https://github.com/sxyazi/yazi)** - Terminal file manager
- **[ripgrep](https://github.com/BurntSushi/ripgrep)** - Blazingly fast grep
- **[eza](https://github.com/eza-community/eza)** - Modern ls replacement
- **[bat](https://github.com/sharkdp/bat)** - Cat with syntax highlighting
- **[fd](https://github.com/sharkdp/fd)** - Fast alternative to find
- **[dust](https://github.com/bootandy/dust)** - Intuitive du replacement
- **[procs](https://github.com/dalance/procs)** - Modern ps replacement
- **[gh](https://github.com/cli/cli)** - GitHub CLI
- **[pnpm](https://github.com/pnpm/pnpm)** - Fast package manager
- **[wezterm](https://wezfurlong.org/wezterm/)** - GPU-accelerated terminal
- **[neovim](https://neovim.io/)** - Hyperextensible text editor

## Installation

```bash
# Clone dotfiles
git clone https://github.com/tenequm/dotfiles.git ~/Projects/dotfiles

# Create config directories
mkdir -p ~/.config/{sheldon,mise,nvim}

# Link configuration files
ln -sf ~/Projects/dotfiles/.zshrc ~/.zshrc
ln -sf ~/Projects/dotfiles/.aliasesrc ~/.aliasesrc
ln -sf ~/Projects/dotfiles/.wezterm.lua ~/.wezterm.lua
ln -sf ~/Projects/dotfiles/.config/sheldon/plugins.toml ~/.config/sheldon/plugins.toml
ln -sf ~/Projects/dotfiles/.config/starship.toml ~/.config/starship.toml
ln -sf ~/Projects/dotfiles/.config/mise/config.toml ~/.config/mise/config.toml
ln -sf ~/Projects/dotfiles/.config/nvim/init.lua ~/.config/nvim/init.lua

# Create environment variables file (untracked)
touch ~/.zshenv
# Edit ~/.zshenv to add your tokens

# Install language environments
mise install

# Set up FZF
$(brew --prefix)/opt/fzf/install --all --no-bash --no-fish

# Restart your terminal
```

## Neovim

The Neovim config uses [lazy.nvim](https://github.com/folke/lazy.nvim) with:

- **LSP** - Go, Python, TypeScript, Rust via Mason
- **Treesitter** - Syntax highlighting and code navigation
- **Completion** - nvim-cmp with LSP, snippets, buffer sources
- **Git** - gitsigns, fugitive, vimagit
- **Navigation** - smart-splits (seamless nvim/wezterm pane navigation)
- **Theme** - Solarized dark with transparency

Leader key: `,`

## WezTerm

GPU-accelerated terminal with tmux-like features:

- **Leader key**: `Ctrl+f`
- **Splits**: `Cmd+\` (horizontal), `Cmd+|` (vertical)
- **Pane navigation**: `Ctrl+h/j/k/l` (works seamlessly with Neovim)
- **Copy mode**: `Leader+[`
- **Search**: `Leader+/`

## Key Shortcuts

- `z <dir>` - Jump to directory (zoxide)
- `pj <project>` - Jump to ~/Projects
- `y` - Yazi file manager
- `Ctrl+R` - Search history (atuin)
- `Ctrl+T` - Fuzzy find files (fzf)
- `gcheck <name>` - Check domain/GitHub availability