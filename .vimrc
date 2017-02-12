set nocompatible        " Get the latest Vim settings/options

so ~/.vim/plugins.vim

"---------Basic configs---------"
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching
set backspace=indent,eol,start " normal backspace
set nocompatible        " using Vim settings instead of Vi
syntax enable           " enabling syntax highlighting
set background=dark
colorscheme solarized   " setting colorscheme
set nu                  " set numeration of the rows
set wildmenu            " set zsh-like autocomlete
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>
set pastetoggle=<F2>    " Set pasting-mode toggle to F2
let mapleader = ','
set guifont=Menlo\ Regular\ for\ Powerline:h14
set hls
set noerrorbells visualbell t_vb=               "No damn bells
set autowriteall
set complete=.,w,b,u

"---------Mappings------"
nmap <silent> <leader>j :nohlsearch<CR><Esc> 
nmap <Leader>ed :tabedit $MYVIMRC<CR>                 
nmap <Leader>eq :e ~/.vim/UltiSnips/
nmap <Leader>s <Leader><Leader>s
nmap <Leader>gh :cd /Applications/MAMP/htdocs<cr>   
nmap <leader>pf :!php-cs-fixer fix "%" --level=psr2
nmap <leader>ev :vsp<cr>
nmap <leader>es :sp<cr>
" Turning off <Ctrl-p> combination in insert mode
imap <c-p> <Nop>
imap jj <Esc>

"---------Comfortable opening of new files--------"
cnoremap %% <C-R>=fnameescape(expand('%:h')).'/'<cr>

"--------Plugins-----------"

"/
"/ CtrlP
"/
let g:ctrlp_custom_ignore = 'node_modules\DS_Stor\|git'
"let g:ctrlp_custom_ignore = 'vendor'
let g:ctrlp_match_window = 'top,order:ttb,min:1,max:30,results:30'
"Make CtrlP tag toggle
nmap <D-p> :CtrlP<cr>
nmap <D-r> :CtrlPBufTag<cr>
nmap <D-e> :CtrlPMRUFiles<cr>
nmap <Leader>. :CtrlPTag<cr>

"/
"/ NERDTree
"/
let NERDTreeHijackNetrw = 0
"Make NERTDTree easier to toggle
nmap <D-1> :NERDTreeToggle<cr>

"/
"/ Greplace.vim
"/
set grepprg=ag      "We want to use Ag for the search
let g:grep_cmd_opts = '--line-numbers --noheading'

"/
"/ PHP formatting plugin
"/
let g:phpfmt_autosave = 1
nmap <Leader>pf :PhpFmt<cr>

"/
"/ PHP Documentor for VIM
"/
let g:pdv_template_dir = $HOME ."/.vim/bundle/pdv/templates_snip"
nnoremap <Leader>d :call pdv#DocumentWithSnip()<CR>

"/
"/ UltiSnips
"/
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

"/
"/ Syntastic
"/
" set statusline+=%#warningmsg#
" set statusline+=%{SyntasticStatuslineFlag()}
" set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

"/
"/ Easymotion
"/
hi link EasyMotionTarget ErrorMsg
hi link EasyMotionShade  Comment

"/
"/ delimitMate
"/
let g:delimitMate_expand_cr = 1
let g:delimitMate_expand_space = 1
let g:delimitMate_jump_expansion = 1

"/
"/ Tabularize
"/
if exists(":Tabularize")
    nmap <leader>a= :Tabularize /=<cr>
    vmap <leader>a= :Tabularize /=<cr>
    nmap <leader>a: :Tabularize /:\zs<cr>
    vmap <leader>a: :Tabularize /:\zs<cr>
endif

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

"Sort PHP use statements
"http://stackoverflow.com/questions/11531073/how-do-you-sort-a-range-of-lines-by-length
vmap <Leader>su ! awk '{ print length(), $0 \| "sort -n \| cut -d\\  -f2-" }'<cr>

"---------Tab management-------"
set softtabstop=4
set shiftwidth=4
set expandtab

"---------Adding plugins load-------"
filetype plugin on
runtime macros/matchit.vim

"---------Managing backupfiles into ~/tmp--------"
set swapfile
set backup
set backupdir=~/tmp
set backupskip=~/tmp/*
set directory=~/tmp
set writebackup
set undodir=~/tmp

"---------Split Management------------"
set splitbelow
set splitright

nmap <C-J> <C-W><C-J>
nmap <C-K> <C-W><C-K>
nmap <C-H> <C-W><C-H>
nmap <C-L> <C-W><C-L>

"---------Visuals-----------"
set guioptions-=e       "We don't want GUI tabs
set linespace=10

"Get rid of ugly split borders
hi vertsplit guifg=bg guibg=bg


"---------PHP syntax override----------"
function! PhpSyntaxOverride()
  hi! def link phpDocTags  phpDefine
  hi! def link phpDocParam phpType
endfunction

augroup phpSyntaxOverride
  autocmd!
  autocmd FileType php call PhpSyntaxOverride()
augroup END
