
function! P4Edit()
    call system("p4 edit " . expand("%"))
    " Chmod just refresh the buffer without losing the changes, do not actually chmod
    Chmod u+r
endfunction

command! -nargs=0 P4Edit call P4Edit()
