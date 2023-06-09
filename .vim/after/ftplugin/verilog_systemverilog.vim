nnoremap <leader>u :VerilogGotoInstanceStart<CR>
nnoremap <leader>i :VerilogFollowInstance<CR>
nnoremap <leader>r :VerilogReturnInstance<CR>
nnoremap <leader>I :VerilogFollowPort<CR>

silent VerilogErrorFormat vcs 3
 
 function! VLint()
     silent VerilogErrorFormat spyglass 2
     make lint
     silent VerilogErrorFormat vcs 3
 endfunction
 command! -nargs=0 VLint call VLint()

" for lsp see the plugin verible/veridian
