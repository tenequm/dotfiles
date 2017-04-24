set nocompatible        " Get the latest Vim settings/options

call plug#begin('~/.vim/plugged')
Plug 'altercation/vim-colors-solarized'
Plug 'tpope/vim-vinegar' | Plug 'tpope/vim-commentary'| Plug 'tpope/vim-repeat' 
Plug 'tpope/vim-surround' | Plug 'tpope/vim-fugitive' | Plug 'tpope/vim-unimpaired'
Plug 'yuttie/comfortable-motion.vim' | Plug 'easymotion/vim-easymotion'
Plug 'Shougo/neocomplete' | Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
Plug 'vim-syntastic/syntastic' | Plug 'chase/vim-ansible-yaml'
Plug 'Raimondi/delimitMate'
Plug 'alexdavid/vim-min-git-status' | Plug 'idanarye/vim-merginal'
Plug 'gabrielelana/vim-markdown'
Plug 'Glench/Vim-Jinja2-Syntax'
Plug 'JamshedVesuna/vim-markdown-preview'
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
set guifont=Menlo\ Regular\ for\ Powerline:h14
set hls
set noerrorbells visualbell t_vb=               "No damn bells
set autowriteall
set complete=.,w,b,u
set ignorecase
set smartcase
set gdefault
set clipboard=unnamed
set guioptions-=e       "We don't want GUI tabs
set linespace=10
set softtabstop=4
set shiftwidth=4
set expandtab
set noswapfile
set backup
set backupdir=~/.vim/backup
set backupskip=~/.vim/backup/*
set undodir=~/.vim/backup
"---------Split Management------------"
set splitbelow
set splitright
"statusline
" hi StatusLine ctermfg=bg ctermbg=fg
"Get rid of ugly split borders
" hi vertsplit guifg=bg guibg=bg
" set statusline=%{fugitive#statusline()}\ %f
" set laststatus=2

"---------Mappings------"
nmap <silent> <leader>j :nohlsearch<CR><Esc> 
nmap <Leader>ed :tabedit $MYVIMRC<CR>                 
nmap <Leader>eq :e ~/.vim/UltiSnips/
nmap <Leader>s <Leader><Leader>s
" nmap <leader>pf :!php-cs-fixer fix "%" --level=psr2
nmap <leader>ev :vsp<cr>
nmap <leader>es :sp<cr>
" Turning off <Ctrl-p> combination in insert mode
imap <c-p> <Nop>
imap jj <Esc>
nnoremap j gj
nnoremap k gk
" nnoremap gj j
" nnoremap gk k
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
"/ Git snips
set diffopt=filler,vertical
nmap <leader>gs :Gministatus<cr>
nmap <leader>gp :Git push<cr>
" nmap <leader>gc :Gcommit<cr>
" nmap <leader>gd :Gdiff<cr>
" nmap <leader>ge :Gedit<cr>
" nmap <leader>gr :Gread<cr>
" nmap <leader>gw :Gwrite<cr>
" nmap <leader>gp :diffput<cr>
" nmap <leader>gg :diffget<cr>

"--------Plugins-----------"
"/ Neocomplete configs
let g:acp_enableAtStartup = 0
let g:neocomplete#enable_at_startup = 1
let g:neocomplete#enable_smart_case = 1
let g:neocomplete#sources#syntax#min_keyword_length = 3
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  return (pumvisible() ? "\<C-y>" : "" ) . "\<CR>"
  " For no inserting <CR> key.
  "return pumvisible() ? "\<C-y>" : "\<CR>"
endfunction
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
" Close popup by <Space>.
" inoremap <expr><Space> pumvisible() ? "\<C-y>" : "\<Space>"
" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

"/ Syntastic
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 1
let g:syntastic_auto_jump = 1
let g:syntastic_php_php_quiet_messages={"regex": "^unexpected\ \'\%\'$"}
" let g:syntastic_ignore_files = ['\m\.php\.j2$']
" autocmd BufRead,BufNewFile *.php.j2 set filetype=php.jinja

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

"/ vim-markdown-preview
let vim_markdown_preview_github=1

"/ vim-move
vmap <C-k> <Plug>MoveBlockUp<cr>
vmap <C-j> <Plug>MoveBlockDown<cr>

"/ Snippets configs
function! g:UltiSnips_Complete()
    call UltiSnips#ExpandSnippet()
    if g:ulti_expand_res == 0
        if pumvisible()
            return "\<C-n>"
        else
            call UltiSnips#JumpForwards()
            if g:ulti_jump_forwards_res == 0
               return "\<Tab>"
            endif
        endif
    endif
    return ""
endfunction
au BufEnter * exec "inoremap <silent> " . g:UltiSnipsExpandTrigger . " <C-R>=g:UltiSnips_Complete()<cr>"
let g:UltiSnipsSnippetsDir="~/.vim/UltiSnips"
let g:UltiSnipsEditSplit="vertical"
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
nmap <leader>as :UltiSnipsEdit<cr>

" "/ PHP formatting plugin
" let g:phpfmt_autosave = 1
" nmap <Leader>pf :PhpFmt<cr>
" "/ PHP Documentor for VIM
" let g:pdv_template_dir = $HOME ."/.vim/bundle/pdv/templates_snip"
" nnoremap <Leader>d :call pdv#DocumentWithSnip()<CR>
" "/ CtrlP
" let g:ctrlp_custom_ignore = 'node_modules\DS_Stor\|git'
" "let g:ctrlp_custom_ignore = 'vendor'
" let g:ctrlp_match_window = 'top,order:ttb,min:1,max:30,results:30'
" "Make CtrlP tag toggle
" nmap <D-p> :CtrlP<cr>
" nmap <D-r> :CtrlPBufTag<cr>
" nmap <D-e> :CtrlPMRUFiles<cr>
" nmap <Leader>. :CtrlPTag<cr>
" "/ Greplace.vim
" set grepprg=ag      "We want to use Ag for the search
" let g:grep_cmd_opts = '--line-numbers --noheading'

"---------Auto-Commands-----"
"Automatically source Vimrc file on save
augroup autosourcing
    autocmd!
    autocmd BufWritePost .vimrc source %
augroup END

function! IPhpInsertUse()
    call PhpInsertUse()
    call feedkeys('a',  'n')
endfunction
autocmd FileType php inoremap <Leader>n <Esc>:call IPhpInsertUse()<CR>
autocmd FileType php noremap <Leader>n :call PhpInsertUse()<CR>

function! IPhpExpandClass()
    call PhpExpandClass()
    call feedkeys('a', 'n')
endfunction
autocmd FileType php inoremap <Leader>nf <Esc>:call IPhpExpandClass()<CR>
autocmd FileType php noremap <Leader>nf :call PhpExpandClass()<CR>
"---------PHP syntax override----------"
function! PhpSyntaxOverride()
  hi! def link phpDocTags  phpDefine
  hi! def link phpDocParam phpType
endfunction

augroup phpSyntaxOverride
  autocmd!
  autocmd FileType php call PhpSyntaxOverride()
augroup END

" UseLater Plugins
" Plugin 'beanworks/vim-phpfmt'
" Plugin 'tobyS/pdv'
" Plugin 'tobyS/vmustache'
" Bundle 'captbaritone/better-indent-support-for-php-with-html'
" Plugin 'pearofducks/ansible-vim'
" Plugin 'jreybert/vimagit'
" Plugin 'mattn/emmet-vim'
" Plugin 'ctrlpvim/ctrlp.vim'
" Plugin 'rking/ag.vim'
" Plugin 'skwp/greplace.vim'
" Plugin 'StanAngeloff/php.vim'
" Plugin 'arnaud-lb/vim-php-namespace'
" Plugin 'evidens/vim-twig'
