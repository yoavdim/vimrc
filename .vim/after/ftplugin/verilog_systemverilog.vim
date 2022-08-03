 augroup filetype_verilog
     autocmd!
     autocmd User DoAfterConfigs VerilogErrorFormat vcs 3
 augroup END
 
 function! Lint()
     VerilogErrorFormat spyglass 2
     make lint
     VerilogErrorFormat vcs 3
 endfunction
