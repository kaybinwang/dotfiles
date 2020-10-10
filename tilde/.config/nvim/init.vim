"-------------------------------------------------------------------------------
" TODO
"-------------------------------------------------------------------------------
"   - Revisit in LSP in Dec 2020 after nvim 0.5 release
"   - Consider breaking apart into separate filetypes for other languages
"     - Separate out vim8 / neovim specific functionality into separate files
"     - How to layout plugin mappings and configurations. separate? centralized?
"     - Should we bootstrap here?
"   - Invest in gq
"   - Revisit multiplexing in vim terminal / kitty / tmux
"   - Revisit FZF <-> RG integration
"   - Compatible terminal keybindings across nvim/vim8
"   - Fix bootstrapping errors from missing plugins
"   - Symlink plugins / dotfiles at leaf nodes
"   - Statusline padding

"===============================================================================
" Philosophy
"===============================================================================
"
" Changes will be made to the appropriate files so that we minimize start up
" time by only loading functionality when needed. For example Python
" functionality will only be loaded when opening up a Python file for the first
" time.
"
"   nvim/
"   ├── .vim/
"   │   ├── autoload/      - functions that are only called from mappings
"   │   └── after/
"   │       └── ftplugin/  - filetype specific configuration (e.g. Python spacing)
"   └── init.vim           - personal configuration that's always loaded

"-------------------------------------------------------------------------------
" Table of contents
"-------------------------------------------------------------------------------
" 1. Plugins
"   1.1 Bootstrap
"   1.2 Plugin List
"     1.2.1 User Interface
"     1.2.2 Text Editing & Navigation
"     1.2.3 Search
"     1.2.4 Developer Tools
" 2. Editor Settings
"   2.1 General
"     2.1.1 Backups
"     2.1.2 Undo History
"     2.1.3 Auto Save
"   2.2 User Interface
"     2.2.1 Theme
"     2.2.2 Buffers
"     2.2.3 Status Line
"   2.3 Text Editing & Navigation
"     2.3.1 Tabs & Indentation
"     2.3.2 Word Wrapping
"     2.3.3 Search
" 3. Key Mappings
"   3.0 Training Wheels
"   3.1 General
"   3.2 Navigation
"   3.3 Editing
"   3.4 Terminal
"   3.5 File Searching
"   3.6 Git
"   3.7 File Browser
"   3.8 Testing

"===============================================================================
" 1. Plugins
"===============================================================================

"-------------------------------------------------------------------------------
" 1.1 Bootstrap
"
" First time configuration and loading of plugins.
"-------------------------------------------------------------------------------
if has('nvim')
  let g:vim_plug_dir = resolve(expand('~/.config/nvim/autoload'))
  let g:vim_plugin_dir = resolve(expand('~/.config/nvim/.vim/plugged'))
  let g:vimrc = resolve(expand('~/.config/nvim/init.vim'))
else
  let g:vim_plug_dir = resolve(expand('~/.vim/autoload'))
  let g:vim_plugin_dir = resolve(expand('~/.vim/plugged'))
  let g:vimrc = resolve(expand('~/.vimrc'))
endif

" Install vim-plug if not available
let g:vim_plug = g:vim_plug_dir.'/plug.vim'
if !filereadable(g:vim_plug)
  silent! execute '!curl -fLo '.g:vim_plug.' --create-dirs '.
        \ 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  " Note that --sync flag is used to block the execution until the installer finishes.
  autocmd VimEnter * PlugInstall --sync | source g:vimrc
endif


"-------------------------------------------------------------------------------
" 1.2 Plugin List
"-------------------------------------------------------------------------------

call plug#begin(g:vim_plugin_dir)

" 1.2.1 User Interface
Plug 'nanotech/jellybeans.vim'
Plug 'danilo-augusto/vim-afterglow'
Plug 'ryanoasis/vim-devicons'
Plug 'sheerun/vim-polyglot'
Plug 'affirm/vim-policy-syntax'
Plug 'hail2u/vim-css3-syntax'
Plug 'chrisbra/Colorizer'

" 1.2.2 Text Editing & Navigation
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-unimpaired'

" 1.2.3 Search
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" 1.2.4 Developer Tools
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-eunuch'
Plug 'janko-m/vim-test'

call plug#end()


"===============================================================================
" 2. Editor Settings
"===============================================================================

"-------------------------------------------------------------------------------
" 2.1 General
"-------------------------------------------------------------------------------

" on - set filetype on file load, triggering the FileType event
" indent - loads indent scripts in 'runtimepath' for the filetype
" plugin - loads ftplugin scripts in 'runtimepath' for the filetype
filetype indent plugin on

set mouse=                          " diasable mouse interactions
set hidden                          " allow buffer to go into background
set ttyfast                         " indicates a fast terminal connection
set backspace=indent,eol,start      " allow backspace, ^W, ^U over these chars
set history=200                     " store last 200 commands as history
set noerrorbells                    " no error bells please
set path+=**                        " recursive searching
set complete-=i                     " don't include all files, it's slow
set shortmess+=aAIsT                " disable welcome screen and other messages
set nostartofline                   " keeps cursor in place when switching buffers

" 2.1.1 Backups
set nobackup                        " don't save backups
set noswapfile                      " no swapfiles
set nowritebackup                   " don't save a backup while editing

" 2.1.2 Undo History
set undodir=~/.vim/undodir          " set undofile location
set undofile                        " maintain undo history between sessions
set undolevels=1000                 " store 1000 undos

" 2.1.3 Auto Save
autocmd FocusGained,BufEnter * :checktime          " auto read
autocmd FocusLost,WinLeave * :silent! noautocmd w  " auto write


"-------------------------------------------------------------------------------
" 2.2 User Interface
"-------------------------------------------------------------------------------

" 2.2.1 Theme
if &runtimepath =~? "afterglow"
  colorscheme afterglow
endif
set background=dark
" set termguicolors                   " true colors

" 2.2.2 Buffers
syntax on                           " syntax highlighting
set number                          " line numbers
set cursorline                      " highlight current line
set list                            " show invisible characters
set listchars=tab:>·,trail:·,nbsp:¬ " but only show useful characters
set lazyredraw                      " don't draw everything
set updatetime=100                  " faster updates, used for gitgutter

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

" 2.2.3 Status Line
set noshowmode                               " hide mode in command line bar
set noruler                                  " hide line, col number in command line bar
set showcmd                                  " show in-flight keystrokes in command line bar
set laststatus=2                             " always show a status lin v
set statusline=
set statusline+=\ 
set statusline+=%{statusline#Mode()}         " current editor mode
set statusline+=%{statusline#Paste()}        " flag if paste is enabled
set statusline+=\ 
set statusline+=%#Pmenu#
set statusline+=%{statusline#GitBranch()}    " current git branch
set statusline+=\|\ 
set statusline+=%{statusline#Readonly()}     " flag is file is readonly
set statusline+=%f                           " relative path to current buffer
set statusline+=%{statusline#Modified()}     " flag if file is modified
set statusline+=\ 
set statusline+=%#Visual#
set statusline+=%=
set statusline+=%{statusline#Fileformat()}   " fileformat
set statusline+=\ \|\ 
set statusline+=%{statusline#Fileencoding()} " fileencoding
set statusline+=\ \|\ 
set statusline+=%{statusline#Filetype()}     " filetype
set statusline+=\ \|\ 
set statusline+=%3p%%                        " percentage through file in lines
set statusline+=\ \|\ 
set statusline+=%4l:%-4c                     " line number : column number


"-------------------------------------------------------------------------------
" 2.3 Text Editing & Navigation
"-------------------------------------------------------------------------------

" 2.3.1 Tabs & Indentation
set expandtab                       " convert tabs into spaces
set tabstop=2                       " number of spaces a \t takes up
set softtabstop=2                   " number of spaces to insert/remove on tab/backspace
set shiftwidth=2                    " number of spaces to use for auto-indention, e.g. gq, >, <
set shiftround                      " indents like > < round to nearest multiple of 'shiftwidth'

" 2.3.2 Word Wrapping
set colorcolumn=80                  " vertical line marker at 80 chars
set wrap                            " enable visual text wrapping
set textwidth=80                    " line break after 80 chars
set linebreak                       " don't break lines in the middle of word

" 2.3.3 Search
set hlsearch                        " highlight search results
set incsearch                       " incrementally jump to search results
set ignorecase                      " search queries are case-insensitive
set smartcase                       " search queries are case-sensitive when cased


"===============================================================================
" 3. Key Mappings
"===============================================================================

"-------------------------------------------------------------------------------
" 3.0 Training Wheels
"
" Experimental or deprecated keybindings.
"-------------------------------------------------------------------------------


"-------------------------------------------------------------------------------
" 3.1 General
"-------------------------------------------------------------------------------

let mapleader = " "

" Open vimrc
nnoremap <leader>ov :execute 'edit' g:vimrc<cr>

" Edit vimrc
nnoremap <silent> <leader>ev :execute 'vsplit '.fnameescape(g:vimrc)<cr>

" Source vimrc 
nnoremap <silent> <leader>sv :execute 'source '.fnameescape(g:vimrc)<cr>

" Reload plugins
nnoremap <silent> <leader>rp :update<cr>:execute 'source '.fnameescape(g:vimrc)<cr>:PlugInstall<cr>

" Clear search
nnoremap <silent> <return> :noh<cr><esc>


"-------------------------------------------------------------------------------
" 3.2 Navigation
"-------------------------------------------------------------------------------

" Move into line wraps
nnoremap j gj
nnoremap k gk

" Nagivate window splits
" nnoremap <C-h> <C-w><C-h>
" nnoremap <C-j> <C-w><C-j>
" nnoremap <C-k> <C-w><C-k>
" nnoremap <C-l> <C-w><C-l>


"-------------------------------------------------------------------------------
" 3.3 Editing
"-------------------------------------------------------------------------------

" make Y like D
nnoremap Y y$

" Toggle relative line numbers
nnoremap <silent> <C-n> :call togglernu#ToggleRelativeNumber()<cr>

let g:colorizer_auto_filetype='css,html'
nnoremap <silent> <c-h> :ColorToggle<cr>


"-------------------------------------------------------------------------------
" 3.4 Terminal
"-------------------------------------------------------------------------------

" TODO: unify terminal bindings across nvim/vim8

" bring vim 8.2 bindings to nvim
if has('nvim')
  tnoremap <C-w>N <C-\><C-n>
  tnoremap <C-w>: <C-\><C-n>:

  tnoremap <C-w>h <C-\><C-n><C-w>h
  tnoremap <C-w>j <C-\><C-n><C-w>j
  tnoremap <C-w>k <C-\><C-n><C-w>k
  tnoremap <C-w>l <C-\><C-n><C-w>l

  autocmd TermOpen * setl nonumber norelativenumber
  autocmd BufEnter * if &buftype == 'terminal' | :startinsert | endif
endif


"-------------------------------------------------------------------------------
" 3.5 File Searching
"-------------------------------------------------------------------------------

let g:fzf_colors = {
  \ 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment']
  \}

" Open search
nnoremap <silent> <leader><leader> :Files<cr>
nnoremap <silent> <leader>p :GFiles<cr>
nnoremap <silent> <leader>m :GFiles?<cr>
nnoremap <silent> <leader>b :Buffers<cr>
nnoremap <silent> <leader>w :Windows<cr>
nnoremap <silent> <leader>; :BLines<cr>
nnoremap <silent> <leader>l :Lines<cr>
nnoremap <silent> <leader>h :History<cr>
nnoremap <silent> <leader>a :Rg<cr>

command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case -- '.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview(), <bang>0)

" Scroll search results
autocmd FileType fzf tnoremap <buffer> <c-j> <down>
autocmd FileType fzf tnoremap <buffer> <c-k> <up>
autocmd FileType fzf tnoremap <buffer> <c-h> <c-h>
autocmd FileType fzf tnoremap <buffer> <c-l> <c-l>


"-------------------------------------------------------------------------------
" 3.6 Git
"-------------------------------------------------------------------------------

" Move to next git modification
nnoremap <silent> <leader>gp :GitGutterPreviewHunk<cr>
nnoremap <silent> <leader>gu :GitGutterUndoHunk<cr>

" Fugitive Git commands
nnoremap <silent> <leader>gb :Gblame<cr>
nnoremap <silent> <leader>gd :Gdiff<cr>
nnoremap <silent> <leader>gs :Gstatus<cr>
nnoremap <silent> <leader>gc :Gcommit<cr>


"-------------------------------------------------------------------------------
" 3.7 File Browser
"-------------------------------------------------------------------------------

" Turn off top banner by default (toggle with I)
let g:netrw_banner = 0

" Tree view
let g:netrw_liststyle = 3


"-------------------------------------------------------------------------------
" 3.8 Testing
"-------------------------------------------------------------------------------

let test#python#runner = 'nose'
let test#python#options = '-s'
if has('nvim')
  let test#strategy = 'terminal'
else
  let test#strategy = 'vimterminal'
endif

" Execute the test in the current file that's closest to the cursor
" If the current file is not a test, then it reruns a previous nearest test
nnoremap <silent> <leader>tn :TestNearest<cr>

" Run tests for the current file. If the current file is not a test, then it
" reruns a previously touched test file
nnoremap <silent> <leader>tf :TestFile<cr>

" Runs the most recently executed test
nnoremap <silent> <leader>tl :TestLast<cr>

" Open the last run test in the current buffer
nnoremap <silent> <leader>tv :TestVisit<cr>
