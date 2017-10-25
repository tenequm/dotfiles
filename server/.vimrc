set nocompatible        " Get the latest Vim settings/options

call plug#begin('~/.vim/plugged')
Plug 'altercation/vim-colors-solarized'
Plug 'tpope/vim-vinegar' | Plug 'tpope/vim-commentary'| Plug 'tpope/vim-repeat' 
Plug 'tpope/vim-surround' | Plug 'tpope/vim-unimpaired'
Plug 'easymotion/vim-easymotion'
Plug 'chase/vim-ansible-yaml'
Plug 'Raimondi/delimitMate'
Plug 'gabrielelana/vim-markdown'
Plug 'Glench/Vim-Jinja2-Syntax'
call plug#end()

"---------Basic configs---------"
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set mouse=a             " let mouse work in terminal
set incsearch		" do incremental searching
set backspace=indent,eol,start " normal backspace
syntax enable           " enabling syntax highlighting
set background=dark
colorscheme solarized   " setting colorscheme
set nu                  " set numeration of the rows
set wildmenu            " set zsh-like autocomlete
set pastetoggle=<F2>    " Set pasting-mode toggle to F2
let mapleader = ','
set hls
set noerrorbells visualbell t_vb=               "No damn bells
set autowriteall
set complete=.,w,b,u
set ignorecase
set smartcase
set gdefault
set clipboard=unnamed
set linespace=10
set softtabstop=4
set shiftwidth=4
set expandtab
set noswapfile
set nobackup

"---------Split Management------------"
set splitbelow
set splitright

"---------Mappings------"
nmap <silent> <leader>j :nohlsearch<CR><Esc> 
nmap <Leader>ed :tabedit $MYVIMRC<CR>                 
nmap <Leader>eq :e ~/.vim/UltiSnips/
nmap <Leader>s <Leader><Leader>s
nmap <leader>ev :vsp<cr>
nmap <leader>es :sp<cr>
" Turning off <Ctrl-p> combination in insert mode
imap <c-p> <Nop>
imap jj <Esc>
nnoremap j gj
nnoremap k gk
nnoremap n nzz
nnoremap } }zz
nnoremap J mzJ`z
nnoremap <F1> <nop>
nnoremap Q <nop>
nnoremap K <nop>
nnoremap QQ ZZ
nnoremap QW ZQ
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>
nmap <C-J> <C-W><C-J>
nmap <C-K> <C-W><C-K>
nmap <C-H> <C-W><C-H>
nmap <C-L> <C-W><C-L>
inoremap <C-U> <C-G>u<C-U>

"--------Plugins-----------"
"/ Easymotion
hi link EasyMotionTarget ErrorMsg
hi link EasyMotionShade  Comment

"/ delimitMate
let g:delimitMate_expand_cr = 1
let g:delimitMate_expand_space = 1
let g:delimitMate_jump_expansion = 1
inoremap <expr> <BS>  pumvisible() ? neocomplete#smart_close_popup()."\<BS>" : delimitMate#BS()

"/ vim-markdown
let g:markdown_enable_insert_mode_mappings = 0

autocmd BufRead,BufNewFile *.conf set filetype=config
autocmd BufRead,BufNewFile *.conf set shiftwidth=2
autocmd BufRead,BufNewFile *.conf set softtabstop=2

"---------Auto-Commands-----"
"Automatically source Vimrc file on save
augroup autosourcing
    autocmd!
    autocmd BufWritePost .vimrc source %
augroup END
