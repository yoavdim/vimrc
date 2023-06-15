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
 au! BufRead,BufNewFile *.tex   set filetype=tex
:set history=20
:set wildchar=<TAB>
:set showmatch
:set hlsearch
:set incsearch
set autoindent
augroup sv_indent
    au!
    autocmd FileType * if &filetype != "verilog_systemverilog" | setlocal smartindent
    autocmd FileType * if &filetype == "verilog_systemverilog" | setlocal autoindent
augroup END
:ab arch architecture
set laststatus =2
set statusline=%<%f%=\ [%1*%M%*%n%R%H]\ %-19(%3l,%02c%03V%)%O'%02b'
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
vmap ? y?<C-R>"<CR>
vmap N y?<C-R>"<CR>
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
" Copy File
nnoremap <leader>ya :%y+<CR>:echo "Yanked File"<CR>
nnoremap <leader>sa ggVG
" Save
nmap <M-s> <Esc>:w
imap <M-s> <Esc>:wi

" Right Click Menu TODO
set mousemodel=popup

"let g:rightclick_default_mapping = 0
"nnoremap <silent> <RightMouse> <LeftMouse>:call Rightclick_normal()<CR>
"inoremap <silent> <RightMouse> <Esc>:call Rightclick_normal()<CR>
"vnoremap <silent> <RightMouse> <LeftMouse>:call Rightclick_visual()<CR>

" vimrc edit
nnoremap <leader>ev :e ~/.vimrc<CR>
nnoremap <leader>lv :source $MYVIMRC<CR>
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

function! Search_trunk(module_name)
    let b:file_name=system("base_find " . a:module_name)
    execute 'edit' b:file_name
endfunction

function! Search_trunk_range() range 
   " Get the line and column of the visual selection marks
    let [lnum1, col1] = getpos("'<")[1:2]
    let [lnum2, col2] = getpos("'>")[1:2]

    " Get all the lines represented by this range
    let lines = getline(lnum1, lnum2)         

    " The last line might need to be cut if the visual selection didn't end on the last column
    let lines[-1] = lines[-1][: col2 - (&selection == 'inclusive' ? 1 : 2)]
    " The first line might need to be trimmed if the visual selection didn't start on the first column
    let lines[0] = lines[0][col1 - 1:]

    " Get the desired text
    let selectedText = join(lines, "\n")         

    " Do the call
    call Search_trunk(selectedText) 
endfunction

nnoremap <leader>gf viw:call Search_trunk_range()<cr>
vnoremap <leader>gf :call Search_trunk_range()<cr>

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
" typos "
command W w
command Q q
command X x
" use f instead of ; in find
nnoremap ; :
" auto-generated tab is also of normal size "
set shiftwidth=4
set textwidth=0

" jump to the last location from previews session
if has("nvim")
    autocmd BufReadPost *
      \ if line("'\"") >= 1 && line("'\"") <= line("$") |
      \   exe "normal! g`\"" |
      \ endif
endif

" -- plugins --
let data_dir =  '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
call plug#begin('~/.vim/plugged')

source ~/.vim/after/plugins/telescope.vim
source ~/.vim/after/plugins/p4.vim
if has("nvim")
" language server
    Plug 'neovim/nvim-lspconfig'
    Plug 'ray-x/lsp_signature.nvim'
    Plug 'j-hui/fidget.nvim'
    Plug 'hrsh7th/cmp-nvim-lsp'
    Plug 'hrsh7th/cmp-buffer'
    Plug 'hrsh7th/cmp-path'
    Plug 'hrsh7th/cmp-cmdline'
    Plug 'hrsh7th/nvim-cmp'
endif

" more plugins
Plug 'vhda/verilog_systemverilog.vim'
Plug 'justinmk/vim-syntax-extra'
Plug 'ervandew/supertab'
Plug 'rhysd/clever-f.vim'
Plug 'tpope/vim-eunuch'
Plug 'yoavdim/ScrollColors'
"Plug 'yoavdim/rightclick-macros'  -- TODO remove leftmouse mapping

"color schemes:
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'morhetz/gruvbox'
Plug 'NLKNguyen/papercolor-theme'
Plug 'nanotech/jellybeans.vim'
Plug 'sakibmoon/vim-colors-notepad-plus-plus'

"Plug 'mg979/vim-visual-multi', {'branch': 'master'} - take toturial first
" already preincluded? Plug 'https://github.com/adelarsq/vim-matchit'

call plug#end()

source ~/.vim/after/plugins/lsp_setup.vim  " verilog language server: verible/veridian, keep after config
source ~/.vim/after/plugins/cmp.vim
doautocmd User DoAfterConfigs

colorscheme gruvbox

" 3=only errors 2=warnings 1=all(linting)
" VerilogErrorFormat vcs 3
