nnoremap <leader>u :VerilogGotoInstanceStart<CR>
nnoremap <leader>i :VerilogFollowInstance<CR>
nnoremap <leader>r :VerilogReturnInstance<CR>
nnoremap <leader>I :VerilogFollowPort<CR>

silent VerilogErrorFormat vcs 3
 
 function! Lint()
     silent VerilogErrorFormat spyglass 2
     make lint
     silent VerilogErrorFormat vcs 3
 endfunction
 command! -nargs=0 Lint call Lint()

 if !has('nvim-0.5.0')
    finish
endif

lua << EOF
require'lspconfig'.verible.setup{}
EOF
