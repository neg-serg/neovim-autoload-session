let s:autoload_session_dir = $XDG_CONFIG_HOME . "/nvim/sessions"
let s:autoload_session_file = s:autoload_session_dir . "/default.vim"

function! MakeSession()
    if (filewritable(s:autoload_session_dir) != 2)
        execute 'silent !mkdir -p ' s:autoload_session_dir
        redraw!
    endif
    let b:filename = s:autoload_session_dir . '/default.vim'
    execute "mksession! " . b:filename
endfunction

function! LoadSession()
    call s:WipeBuffersWithoutFiles()
    if (filereadable(s:autoload_session_file))
        execute 'source ' s:autoload_session_file
    else
        echomsg "No session loaded."
    endif
endfunction

function s:WipeBuffersWithoutFiles()
    let bufs=filter(range(1, bufnr('$')), 'bufexists(v:val) && '.
        \'empty(getbufvar(v:val, "&buftype")) && '.
        \'!filereadable(bufname(v:val))')
    if !empty(bufs)
        execute 'silent bwipeout' join(bufs)
    endif
endfunction

au VimEnter * nested :call LoadSession()
au VimLeave * :call MakeSession()
