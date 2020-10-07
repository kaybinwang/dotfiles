if has('nvim')
  let g:vim_plug_dir = expand('~/.config/nvim/autoload')
  let g:vimrc = expand('~/.config/nvim/init.vim')
else
  let g:vim_plug_dir = expand('~/.vim/autoload')
  let g:vimrc = expand('~/.vimrc')
endif

" on - set filetype on file load, triggering the FileType event
" indent - loads indent scripts in 'runtimepath' for the filetype
" plugin - loads ftplugin scripts in 'runtimepath' for the filetype
filetype indent plugin on

syntax on                           " syntax highlighting
set mouse=                          " no mouse
set number                          " line numbers
set cursorline                      " highlight current line
set textwidth=80                    " hard wrap text after 80 chars
set colorcolumn=80                  " vertical line marker at 80 chars
set list                            " show invisible characters
set listchars=tab:>·,trail:·,nbsp:¬ " but only show useful characters
set backspace=indent,eol,start      " allow backspace, ^W, ^U over these chars

" Search
set hlsearch                        " highlight search results
set incsearch                       " incrementally jump to search results
set ignorecase                      " search queries are case-insensitive
set smartcase                       " search queries are case-sensitive when cased

" Tabs & Indentation
set expandtab                       " convert tabs into spaces
set tabstop=2                       " number of spaces a \t takes up
set softtabstop=2                   " number of spaces to insert/remove on tab/backspace
set shiftwidth=2                    " number of spaces to use for auto-indention, e.g. gq, >, <
set shiftround                      " indents like > < round to nearest multiple of 'shiftwidth'

" Status Line
set laststatus=2                    " always show a status line
set statusline=
set statusline+=\ 
set statusline+=%{StatuslineMode()} " current editor mode
set statusline+=\ 
set statusline+=%#PmenuSel#
set statusline+=%{StatuslineGit()}  " current git branch
set statusline+=\|\ 
set statusline+=%f                  " relative path to current buffer
set statusline+=%4m                 " modified flag
set statusline+=\ 
set statusline+=%#LineNr#
set statusline+=%=
set statusline+=%{&fileformat}
set statusline+=\ \|\ 
set statusline+=%{&fileencoding?&fileencoding:&encoding}
set statusline+=\ \|\ 
set statusline+=%y                  " filetype
set statusline+=\ \|\ 
set statusline+=%p%%                " percentage through file in lines
set statusline+=\ \|\ 
set statusline+=%l:%c               " line number : column number

function! CurrentGitBranch()
  " return system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
  return "master"
endfunction

let g:statuslinemode = {
  \ 'n': 'NORMAL',
  \ 'no': 'N·Operator Pending',
  \ 'v': 'VISUAL',
  \ 'V': 'V·Line',
  \ 'x22': 'V·Block',
  \ 's': 'Select',
  \ 'S': 'S·Line',
  \ 'x19': 'S·Block',
  \ 'i': 'INSERT',
  \ 'R': 'REPLACE',
  \ 'Rv': 'V·Replace',
  \ 'c': 'Command',
  \ 'cv': 'Vim Ex',
  \ 'ce': 'Ex',
  \ 'r': 'Prompt',
  \ 'rm': 'More',
  \ 'r?': 'Confirm',
  \ '!': 'Shell',
  \ 't': 'Terminal',
  \}

function! StatuslineMode()
  return g:statuslinemode[mode()]
endfunction

function! StatuslineGit()
  let l:branchname = CurrentGitBranch()
  return strlen(l:branchname) > 0?'  '.l:branchname.' ':''
endfunction

" Cursor settings:
"  1 -> blinking block
"  2 -> solid block 
"  3 -> blinking underscore
"  4 -> solid underscore
"  5 -> blinking vertical bar
"  6 -> solid vertical bar
if &term =~ 'xterm' && !has('nvim')
  let &t_EI = "\<Esc>[2 q"          " EI = NORMAL mode
  let &t_SI = "\<Esc>[6 q"          " SI = INSERT mode
  let &t_SR = "\<Esc>[4 q"          " SR = REPLACE mode
endif

let mapleader = " "

" Open vimrc
nnoremap <leader>ov :execute 'edit' g:vimrc<cr>

" Edit vimrc
nnoremap <silent> <leader>ev :execute 'vsplit '.fnameescape(g:vimrc)<cr>

" Source vimrc 
nnoremap <silent> <leader>sv :execute 'source '.fnameescape(g:vimrc)<cr>

" Reload plugins
nnoremap <silent> <leader>rp :update<cr>:execute 'source '.fnameescape(g:vimrc)<cr>:PlugInstall<cr>
