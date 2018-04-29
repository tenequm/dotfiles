set nocompatible        " Get the latest Vim settings/options

call plug#begin('~/.vim/plugged')
Plug 'altercation/vim-colors-solarized'
Plug 'tpope/vim-surround' | Plug 'tpope/vim-fugitive' | Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-vinegar' | Plug 'tpope/vim-commentary'| Plug 'tpope/vim-repeat' 
Plug 'easymotion/vim-easymotion' | Plug 'matze/vim-move'
Plug 'Shougo/neocomplete' | Plug 'honza/vim-snippets' | Plug 'SirVer/ultisnips'
Plug 'vim-syntastic/syntastic'
Plug 'Raimondi/delimitMate'
Plug 'alexdavid/vim-min-git-status' | Plug 'idanarye/vim-merginal'
Plug 'jreybert/vimagit' | Plug 'airblade/vim-gitgutter'
Plug 'gabrielelana/vim-markdown'
Plug 'Glench/Vim-Jinja2-Syntax'
Plug 'JamshedVesuna/vim-markdown-preview'
Plug 'fatih/vim-go'
Plug 'tpope/vim-dispatch'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'benmills/vimux'
Plug 'hashivim/vim-terraform'
Plug 'chase/vim-ansible-yaml'
Plug 'chr4/nginx.vim'
Plug 'saltstack/salt-vim'
call plug#end()

"---------Basic configs---------"
syntax enable           " enabling syntax highlighting
colorscheme solarized   " setting colorscheme
let mapleader = ','
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set mouse=a             " let mouse work in terminal
set incsearch		" do incremental searching
set backspace=indent,eol,start " normal backspace
set background=dark
set nu                  " set numeration of the rows
set wildmenu            " set zsh-like autocomlete
set pastetoggle=<F2>    " Set pasting-mode toggle to F2
set guifont=Menlo\ Regular\ for\ Powerline:h14
set hls
set noerrorbells visualbell t_vb=               "No damn bells
set autowriteall
set autowrite
set complete=.,w,b,u
set ignorecase
set smartcase
set gdefault
set clipboard=unnamed
set guioptions-=e       "We don't want GUI tabs
set linespace=10
set softtabstop=2
set shiftwidth=2
set expandtab
set noswapfile
set backup
set backupdir=~/.vim/backup
set backupskip=~/.vim/backup/*
set undodir=~/.vim/backup
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
nnoremap gj j
nnoremap gk k
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
nmap <leader>gp :Gpush<cr>
map <C-n> :cnext<cr>
map <C-p> :cprevious<cr>
nnoremap <leader>c :cclose<cr>

"--------Plugins-----------"
"/ Neocomplete configs
let g:acp_enableAtStartup = 0
let g:neocomplete#enable_at_startup = 1
let g:neocomplete#enable_smart_case = 1
let g:neocomplete#sources#syntax#min_keyword_length = 3
let g:neocomplete#enable_auto_close_preview = 1
" <CR>: close popup and save indent.
imap <expr> <CR> pumvisible() ? "\<C-y>" : '<Plug>delimitMateCR'
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
" inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<cr>
" function! s:my_cr_function()
"   return (pumvisible() ? "\<C-y>" : "" ) . "\<CR>"
" "   " For no inserting <CR> key.
" "   "return pumvisible() ? "\<C-y>" : "\<CR>"
" endfunction
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
let g:syntastic_ignore_files = ['\m\.yml$', '\m.\.sh$']

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
let g:move_key_modifier = 'A'

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

"/ vim-go
let g:go_fmt_command = "goimports"
let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_operators = 1
autocmd FileType go map <leader>gr :w<cr> :call VimuxRunCommand("clear; go run " . bufname("%"))<cr>
autocmd FileType go nmap <leader>gb <Plug>(go-build)
autocmd FileType go nmap <leader>gi <Plug>(go-install)
autocmd FileType go nmap <leader>gi :GoSameIdsToggle<cr>
map <leader>gti :let g:VimuxRunnerIndex = 
map <leader>gc :VimuxCloseRunner<cr>
let g:VimuxUseNearest = 0
autocmd FileType go set tabstop=4
autocmd FileType python set shiftwidth=2
autocmd FileType terraform setlocal commentstring=#%s
autocmd BufNewFile,BufRead provision*.yml set ft=ansible
au BufRead,BufNewFile */nginx/config/* set ft=nginx


"---------Auto-Commands-----"
"Automatically source Vimrc file on save
augroup autosourcing
    autocmd!
    autocmd BufWritePost .vimrc source %
augroup END

hi! link Conceal Normal
if has("termguicolors")
    hi! Normal ctermbg=NONE guibg=NONE
    hi! NonText ctermbg=NONE guibg=NONE
endif
