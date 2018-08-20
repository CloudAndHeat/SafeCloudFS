set nocompatible
behave xterm

let s:my_tw=79
let s:my_xterm="xterm-256color"

:au!

set nohls
set noshowmatch
set modeline
set modelines=5
set autoindent
set expandtab
set shiftwidth=4
set tabstop=4
set encoding=utf-8
set splitright
set ruler
set laststatus=2
set nojoinspaces
set nostartofline
set smartcase
if &term == s:my_xterm
    set ttyfast
endif    
set iskeyword+=-,_
set formatoptions+=r2
set comments+=fb:*
set comments-=s1:/*,mb:*,ex:*/
set backspace=indent,eol,start

function! AutoSaveWinView()
    if !exists("w:SavedBufView")
        let w:SavedBufView = {}
    endif
    let w:SavedBufView[bufnr("%")] = winsaveview()
endfunction

function! AutoRestoreWinView()
    let buf = bufnr("%")
    if exists("w:SavedBufView") && has_key(w:SavedBufView, buf)
        let v = winsaveview()
        let atStartOfFile = v.lnum == 1 && v.col == 0
        if atStartOfFile && !&diff
            call winrestview(w:SavedBufView[buf])
        endif
        unlet w:SavedBufView[buf]
    endif
endfunction

" When switching buffers, preserve window view.
if v:version >= 700
    autocmd BufLeave * call AutoSaveWinView()
    autocmd BufEnter * call AutoRestoreWinView()
endif

map <F2> :bn<CR>
map <F4> :!aspell -l en_US -c %
map <F5> :!aspell -l de_DE -c %
nmap <F6> :set invpaste paste?<CR>
imap <F6> <C-O>:set invpaste<CR>
set pastetoggle=<F6>
map <F7> :%s/\v\s+$//e<CR>
if &term =~ '^screen'
    execute "set <xUp>=\e[1;*A"
    execute "set <xDown>=\e[1;*B"
    execute "set <xRight>=\e[1;*C"
    execute "set <xLeft>=\e[1;*D"
endif

syntax on
syntax sync fromstart
autocmd BufEnter * :syntax sync fromstart
set bg=light
hi Comment ctermfg=243
hi Visual ctermbg=241
filetype plugin on

" vim:ts=4:sw=4:tw=79:expandtab
