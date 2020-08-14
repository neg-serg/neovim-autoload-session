let g:autoload_session_dir = $XDG_CONFIG_HOME . "/nvim/sessions"
let g:autoload_session_file = g:autoload_session_dir . "/default.vim"

function! MakeSession()
    if (filewritable(g:autoload_session_dir) != 2)
        exe 'silent !mkdir -p ' g:autoload_session_dir
        redraw!
    endif
    let b:filename = g:autoload_session_dir . '/default.vim'
    exe "mksession! " . b:filename
endfunction

function! LoadSession()
    call s:WipeBuffersWithoutFiles()
    if (filereadable(g:autoload_session_file))
        exe 'source ' g:autoload_session_file
    else
        echo "No session loaded."
    endif
endfunction

function s:WipeBuffersWithoutFiles()
    let bufs=filter(range(1, bufnr('$')), 'bufexists(v:val) && '.
        \'empty(getbufvar(v:val, "&buftype")) && '.
        \'!filereadable(bufname(v:val))')
    if !empty(bufs)
        execute 'bwipeout' join(bufs)
    endif
endfunction

au VimEnter * nested :call LoadSession()
au VimLeave * :call MakeSession()

