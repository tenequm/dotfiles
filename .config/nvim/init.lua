-- ============================================================================
-- NEOVIM CONFIGURATION
-- Using lazy.nvim plugin manager with native LSP and modern plugins
-- ============================================================================

-- ============================================================================
-- LEADER KEY (must be set before lazy.nvim)
-- ============================================================================
vim.g.mapleader = ','

-- ============================================================================
-- BASIC SETTINGS
-- ============================================================================

-- Visual settings
vim.opt.number = true                   -- Line numbers
vim.opt.relativenumber = false           -- Relative line numbers
vim.opt.background = 'dark'             -- Dark background
vim.opt.hlsearch = true                 -- Highlight search results
vim.opt.termguicolors = true            -- Enable true color support

-- Search settings
vim.opt.ignorecase = true               -- Case-insensitive search
vim.opt.smartcase = true                -- Smart case sensitivity

-- Indentation
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true                -- Use spaces instead of tabs

-- Files and backup
vim.opt.swapfile = false                -- No swap files
vim.opt.backup = true                   -- Keep backups
vim.opt.backupdir = vim.fn.expand('~/.config/nvim/backup')
vim.opt.undodir = vim.fn.expand('~/.config/nvim/backup')
vim.opt.undofile = true                 -- Persistent undo
vim.opt.autowriteall = true             -- Auto-save

-- Clipboard
vim.opt.clipboard = 'unnamedplus'       -- System clipboard integration

-- Splits
vim.opt.splitbelow = true               -- Open splits below
vim.opt.splitright = true               -- Open splits to the right

-- Disable bells
vim.opt.errorbells = false
vim.opt.visualbell = true

-- Git
vim.opt.diffopt = 'filler,vertical'

-- Netrw
vim.g.netrw_sizestyle = 'h'
vim.g.netrw_preview = 1
vim.g.netrw_alto = 0
vim.g.netrw_fastbrowse = 0

-- ============================================================================
-- BOOTSTRAP LAZY.NVIM
-- ============================================================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- ============================================================================
-- PLUGIN SETUP
-- ============================================================================
require("lazy").setup({

  -- Colorscheme (load first)
  {
    'maxmx03/solarized.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      require('solarized').setup({
        variant = 'winter',
        transparent = {
          enabled = true,
          normal = true,
          normalfloat = true,
        },
      })
      vim.cmd.colorscheme('solarized')
    end,
  },

  -- LSP Support
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      { 'williamboman/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',
    },
    config = function()
      -- Mason setup
      require('mason-lspconfig').setup({
        ensure_installed = {
          'gopls',
          'pyright',
          'ruff',
          'ts_ls',
          'rust_analyzer',
        },
        automatic_installation = true,
      })

      -- LSP keybindings
      local on_attach = function(client, bufnr)
        local opts = { buffer = bufnr, noremap = true, silent = true }

        -- Navigation
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)

        -- Code actions
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
        vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format({ async = true }) end, opts)

        -- Diagnostics
        vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
        vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
        vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
        vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, opts)
      end

      -- Get completion capabilities for LSP
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      -- Configure LSP servers
      vim.lsp.config('gopls', {
        capabilities = capabilities,
        settings = {
          gopls = {
            analyses = { unusedparams = true },
            staticcheck = true,
            gofumpt = true,
          },
        },
      })

      vim.lsp.config('pyright', { capabilities = capabilities })
      vim.lsp.config('ruff', { capabilities = capabilities })
      vim.lsp.config('ts_ls', { capabilities = capabilities })
      vim.lsp.config('rust_analyzer', {
        capabilities = capabilities,
        settings = {
          ['rust-analyzer'] = {
            checkOnSave = { command = 'clippy' },
          },
        },
      })

      -- Enable LSP servers
      vim.lsp.enable('gopls')
      vim.lsp.enable('pyright')
      vim.lsp.enable('ruff')
      vim.lsp.enable('ts_ls')
      vim.lsp.enable('rust_analyzer')

      -- Setup keybindings when LSP attaches
      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client then
            on_attach(client, args.buf)
          end
        end,
      })
    end,
  },

  -- Completion
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'saadparwaiz1/cmp_luasnip',
    },
    config = function()
      local cmp = require('cmp')
      local luasnip = require('luasnip')

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { 'i', 's' }),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'buffer' },
          { name = 'path' },
        }),
      })
    end,
  },

  -- Snippets
  {
    'L3MON4D3/LuaSnip',
    event = 'InsertEnter',
    dependencies = { 'honza/vim-snippets' },
    config = function()
      require('luasnip.loaders.from_snipmate').lazy_load()
    end,
  },

  -- Treesitter
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    event = { 'BufReadPost', 'BufNewFile' },
    config = function()
      require('nvim-treesitter.configs').setup({
        ensure_installed = { 'go', 'python', 'javascript', 'typescript', 'rust', 'lua', 'vim', 'vimdoc', 'markdown' },
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },

  -- Rainbow brackets
  {
    'HiPhish/rainbow-delimiters.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
  },

  -- Statusline
  {
    'nvim-lualine/lualine.nvim',
    event = 'VeryLazy',
    config = function()
      require('lualine').setup({
        options = {
          theme = 'solarized_dark',
          component_separators = { left = '', right = '' },
          section_separators = { left = '', right = '' },
        },
        sections = {
          lualine_a = {'mode'},
          lualine_b = {'branch', 'diff', 'diagnostics'},
          lualine_c = {'filename'},
          lualine_x = {'encoding', 'fileformat', 'filetype'},
          lualine_y = {'progress'},
          lualine_z = {'location'}
        },
      })
    end,
  },

  -- Editing enhancements
  {
    'kylechui/nvim-surround',
    event = { 'BufReadPost', 'BufNewFile' },
    config = true,
  },

  {
    'numToStr/Comment.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
    config = true,
  },

  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = true,
  },

  -- Git integration
  {
    'lewis6991/gitsigns.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      require('gitsigns').setup({
        signs = {
          add          = { text = '+' },
          change       = { text = '~' },
          delete       = { text = '_' },
          topdelete    = { text = '‾' },
          changedelete = { text = '~' },
        },
      })
    end,
  },

  {
    'tpope/vim-fugitive',
    cmd = { 'Git', 'Gministatus', 'Gdiffsplit', 'Gvdiffsplit', 'Gread', 'Gwrite', 'Ggrep' },
  },

  {
    'jreybert/vimagit',
    cmd = { 'Magit', 'MagitOnly' },
  },

  -- File navigation and utilities
  {
    'tpope/vim-vinegar',
    keys = { '-' },
  },

  {
    'tpope/vim-unimpaired',
    event = { 'BufReadPost', 'BufNewFile' },
  },

  {
    'tpope/vim-repeat',
    event = { 'BufReadPost', 'BufNewFile' },
  },

  {
    'tpope/vim-eunuch',
    cmd = { 'Remove', 'Delete', 'Move', 'Chmod', 'Mkdir', 'Rename', 'SudoWrite', 'SudoEdit' },
  },

  {
    'AndrewRadev/splitjoin.vim',
    keys = { 'gS', 'gJ' },
  },

  -- Markdown
  {
    'iamcco/markdown-preview.nvim',
    ft = 'markdown',
    build = 'cd app && npx --yes yarn install',
  },

  -- Yazi file manager integration
  {
    'mikavilpas/yazi.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    keys = {
      {
        '<leader>-',
        '<cmd>Yazi<cr>',
        desc = 'Open yazi file manager',
      },
    },
    opts = {
      open_for_directories = false,
      keymaps = {
        show_help = '<f1>',
      },
    },
  },

  -- Smart splits (seamless navigation between nvim and wezterm panes)
  { 'mrjones2014/smart-splits.nvim' },

})

-- ============================================================================
-- MAPPINGS
-- ============================================================================

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Clear search highlighting
keymap('n', '<leader>j', ':nohlsearch<CR>', opts)

-- Edit config
keymap('n', '<leader>ed', ':tabedit ~/.config/nvim/init.lua<CR>', opts)

-- Splits
keymap('n', '<leader>ev', ':vsp<CR>', opts)
keymap('n', '<leader>es', ':sp<CR>', opts)

-- Quick escape
keymap('i', 'jj', '<Esc>', opts)

-- Move by visual lines
keymap('n', 'j', 'gj', opts)
keymap('n', 'k', 'gk', opts)
keymap('n', 'gj', 'j', opts)
keymap('n', 'gk', 'k', opts)

-- Center search results
keymap('n', 'n', 'nzz', opts)
keymap('n', '}', '}zz', opts)

-- Join lines without moving cursor
keymap('n', 'J', 'mzJ`z', opts)

-- Disable annoying keys
keymap('n', '<F1>', '<nop>', opts)
keymap('n', 'Q', '<nop>', opts)
keymap('n', 'K', '<nop>', opts)

-- Quick save/quit
keymap('n', 'QQ', 'ZZ', opts)
keymap('n', 'QW', 'ZQ', opts)

-- Command line navigation
keymap('c', '<C-p>', '<Up>', { noremap = true })
keymap('c', '<C-n>', '<Down>', { noremap = true })

-- Window navigation (smart-splits for seamless nvim/wezterm pane nav)
vim.keymap.set('n', '<C-h>', require('smart-splits').move_cursor_left)
vim.keymap.set('n', '<C-j>', require('smart-splits').move_cursor_down)
vim.keymap.set('n', '<C-k>', require('smart-splits').move_cursor_up)
vim.keymap.set('n', '<C-l>', require('smart-splits').move_cursor_right)
-- Swap buffers between windows
vim.keymap.set('n', '<leader><leader>h', require('smart-splits').swap_buf_left)
vim.keymap.set('n', '<leader><leader>j', require('smart-splits').swap_buf_down)
vim.keymap.set('n', '<leader><leader>k', require('smart-splits').swap_buf_up)
vim.keymap.set('n', '<leader><leader>l', require('smart-splits').swap_buf_right)

-- Better undo breakpoints
keymap('i', '<C-U>', '<C-G>u<C-U>', opts)

-- Git shortcuts
keymap('n', '<leader>gs', ':Gministatus<CR>', opts)
keymap('n', '<leader>gp', ':Git push<CR>', opts)

-- Quickfix navigation
keymap('n', '<C-n>', ':cnext<CR>', opts)
keymap('n', '<C-p>', ':cprevious<CR>', opts)
keymap('n', '<leader>c', ':cclose<CR>', opts)

-- Close preview window
keymap('n', '<C-p>', ':pclose<CR>', opts)

-- ============================================================================
-- FILETYPE-SPECIFIC SETTINGS
-- ============================================================================

local filetype_group = vim.api.nvim_create_augroup('FileTypeSettings', { clear = true })

-- Go settings
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'go',
  group = filetype_group,
  callback = function()
    vim.opt_local.tabstop = 4
  end,
})

-- Python settings
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'python',
  group = filetype_group,
  callback = function()
    vim.opt_local.shiftwidth = 4
    vim.opt_local.softtabstop = 4
  end,
})

-- Make settings
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'make',
  group = filetype_group,
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
  end,
})

-- Terraform
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'terraform',
  group = filetype_group,
  callback = function()
    vim.opt_local.commentstring = '#%s'
  end,
})

-- Ansible provisioning files
vim.api.nvim_create_autocmd({'BufNewFile', 'BufRead'}, {
  pattern = 'provision*.yml',
  group = filetype_group,
  callback = function()
    vim.bo.filetype = 'ansible'
  end,
})

-- Nginx config files
vim.api.nvim_create_autocmd({'BufRead', 'BufNewFile'}, {
  pattern = '*/nginx/config/*',
  group = filetype_group,
  callback = function()
    vim.bo.filetype = 'nginx'
  end,
})

-- Jsonnet files
vim.api.nvim_create_autocmd({'BufRead', 'BufNewFile'}, {
  pattern = '*.libjsonnet',
  group = filetype_group,
  callback = function()
    vim.bo.filetype = 'jsonnet'
  end,
})

-- Helm templates
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'helm',
  group = filetype_group,
  callback = function()
    vim.opt_local.commentstring = '# %s'
  end,
})

-- ============================================================================
-- AUTO-COMMANDS
-- ============================================================================

-- Auto-source init.lua on save
local config_group = vim.api.nvim_create_augroup('ConfigReload', { clear = true })
vim.api.nvim_create_autocmd('BufWritePost', {
  pattern = 'init.lua',
  group = config_group,
  callback = function()
    vim.cmd('source ~/.config/nvim/init.lua')
    print('Config reloaded!')
  end,
})
