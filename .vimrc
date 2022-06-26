set expandtab
set nowrap
:set title
:set ruler
set ignorecase
:syntax on
:au! BufRead,BufNewFile *.fs    set filetype=vhdl
:au! BufRead,BufNewFile *.ifc	set filetype=vhdl
:au! BufRead,BufNewFile *.map	set filetype=vhdl
:au! BufRead,BufNewFile *.hpp	set filetype=vhdl
:au! BufRead,BufNewFile *.debug	set filetype=debug
:au! BufRead,BufNewFile *.pro   set filetype=vhdl
:au! BufRead,BufNewFile *.w     set filetype=perl
:au! BufRead,BufNewFile csim_pli.elog  set filetype=csimpli
:au! BufRead,BufNewFile *.rpt   set filetype=csimpli
:set history=20
:set wildchar=<TAB>
:set showmatch
:set hlsearch
:set incsearch
set autoindent
augroup sv_indent
    au!
    autocmd FileType * if &filetype != "verilog_systemverilog" | set smartindent
augroup END
:ab arch architecture
set laststatus =2
set statusline=%<%f%=\ [%1*%M%*%n%R%H]\ %-19(%3l,%02c%03V%)%O'%02b'
set runtimepath^=~/.vim runtimepath+=~/.vim/after
"let &packpath = &runtimepath

" gui staff 
:set guifont=Courier10Pitch\ 16
:set ts=4
:set titlestring=%t
:set undolevels=500
:set nocp
:set guioptions=agimrLtTbt
:set bs=2 "backspace allowed always
:syn match cm ".*::.*"
:hi cm guibg='Cyan'
:hi Visual guibg='Yellow' guifg='Darkred'
:hi normal guifg=blue guibg=gray 
"hi normal guifg=blue guibg=gray
set nu
color desert


"Shift-RIGHT complete when inc search what's under the cursor
"Shift-Down complete whole word - under cursor
cnoremap <S-Down> <CR>yiw<BS>/<C-R>"
cnoremap <S-Right> <CR>y/<Up>/e+1<CR><BS>/<C-R>=escape(@",'.*\/?')<CR>

"press / or n when visual mode - will search the selected string
vmap / y/<C-R>"<CR>
vmap n y/<C-R>"<CR>
vnoremap < <gv
vnoremap > >gv

"shift-right in insert mode - to visual (as in windows - mark)
imap <S-Right> <Esc><Right>v
vmap <S-Right> <Right>
vmap <CR> <Esc>
nmap <S-Right> v<Right>

" Open line
nnoremap <leader>o o<Esc>
inoremap <C-Enter> <Esc>o

" Paste
nmap <leader>p <Esc>"+p
nmap <S-Insert> <Esc>"+p
imap <S-Insert> <Esc>"+pi<Right>
cmap <S-Insert> <MiddleMouse>

" Copy
vnoremap <M-y> "+y
vnoremap Y "+y
nnoremap Y "+y
nnoremap <leader>y "+y
vnoremap <leader>y "+y

" Save
nmap <M-s> <Esc>:w
imap <M-s> <Esc>:wi


nnoremap <leader>ev :e $MYVIMRC<CR>
" % highlight {..}
:nmap % v%

" tags
set tags=./tags
set tags+=~/.vim/tags
if !empty($trunk_cfg)
    set tags+=${trunk_cfg}/tags
endif
if !empty($TRUNK)
    set tags+=${TRUNK}/../.tags  
elseif !empty($trunk)
    set tags+=${trunk}/../.tags  
endif

" make
nnoremap <leader>n :cnext
" see VerilogErrorFormat, still need a .PHONY makefile

" relative number "
set relativenumber
set mouse=a
" common keybinding "
imap jk <Esc>
imap kj <Esc>
vmap jk <Esc>
vmap kj <Esc>
" auto-generated tab is also of normal size "
set shiftwidth=4
set textwidth=0

" -- plugins --
let data_dir =  '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
call plug#begin('~/.vim/plugged')
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'vhda/verilog_systemverilog.vim'
Plug 'ervandew/supertab'
Plug 'rhysd/clever-f.vim'
Plug 'morhetz/gruvbox'
Plug 'tpope/vim-eunuch'
" already preincluded? Plug 'https://github.com/adelarsq/vim-matchit'

call plug#end()

colorscheme gruvbox

" 3=only errors 2=warnings 1=all(linting)
" VerilogErrorFormat vcs 3
