nnoremap <leader>u :VerilogGotoInstanceStart<CR>
nnoremap <leader>i :VerilogFollowInstance<CR>
nnoremap <leader>r :VerilogReturnInstance<CR>
nnoremap <leader>I :VerilogFollowPort<CR>

 VerilogErrorFormat vcs 3
 
 function! Lint()
     VerilogErrorFormat spyglass 2
     make lint
     VerilogErrorFormat vcs 3
 endfunction
 command! -nargs=0 Lint call Lint()
