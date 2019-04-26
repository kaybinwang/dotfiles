"-------------------------------------------------------------------------------
" TODO
"-------------------------------------------------------------------------------
" Remove dependencies on lightline
" Clean up editor settings
" Make backwards compatible with vim
" Document this file
" Consider removing unused functionality
"   - Unused plugins
"   - Unused set options
"   - Unused mappings
"     - close all folds
"     - set rnu

"-------------------------------------------------------------------------------
" Table of contents
"-------------------------------------------------------------------------------
" 1. Plugins
"   1.1 Bootstrap
"   1.2 Plugin List
"     1.2.1 Themes & Appearance
"     1.2.2 File Searching
"     1.2.3 Navigation
"     1.2.4 Text Editing
"     1.2.5 Semantic Analysis
"     1.2.6 Developer Tools
"     1.2.7 Languages
" 2. Editor Settings
"   2.1 Interface
"   2.2 Status Line
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
" 4. File Specific Settings
" 5. Registered Commands
" 6. Helper Functions

"===============================================================================
" 1. Plugins
"===============================================================================

"-------------------------------------------------------------------------------
" 1.1 Bootstrap
"
" First time configuration and loading of plugins.
"-------------------------------------------------------------------------------

if has('nvim')
  let g:vim_plug_dir = expand('~/.config/nvim/autoload')
  let g:vimrc = expand('~/.config/nvim/init.vim')

  " Point to a python interpreter with `neovim` RPC module installed
  let g:python_host_prog = expand('~/.pyenv/versions/neovim2/bin/python')
  let g:python3_host_prog = expand('~/.pyenv/versions/neovim3/bin/python')
else
  let g:vim_plug_dir = expand('~/.vim/autoload')
  let g:vimrc = expand('~/.vimrc')
endif

let vim_plug = g:vim_plug_dir.'/plug.vim'
" Install vim-plug if not available
if !filereadable(vim_plug)
  echo "Installing vim-plug..."
  call mkdir(g:vim_plug_dir, 'p')
  silent! execute '!curl -fLo '.g:vim_plug.' --create-dirs '.
        \ 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  execute 'source '.fnameescape(vim_plug)
endif

"-------------------------------------------------------------------------------
" 1.2. Plugin List
"-------------------------------------------------------------------------------

call plug#begin('~/.vim/plugged')

" 1.2.1 Themes & Appearance {{{
Plug 'nanotech/jellybeans.vim'
Plug 'joshdick/onedark.vim'

Plug 'ryanoasis/vim-devicons'

Plug 'itchyny/lightline.vim'
" lightline.vim {{{

  let g:lightline = {
    \ 'colorscheme': 'jellybeans',
    \ 'active': {
    \   'left': [ [ 'mode', 'paste' ], [ 'fugitive', 'filename' ], ['ctrlpmark'] ],
    \   'right': [ [ 'syntastic', 'lineinfo' ], ['percent'], [ 'fileformat', 'fileencoding', 'filetype' ] ]
    \ },
    \ 'component_function': {
    \   'fugitive': 'LightlineFugitive',
    \   'filename': 'LightlineFilename',
    \   'fileformat': 'MyFileformat',
    \   'filetype': 'MyFiletype',
    \   'fileencoding': 'LightlineFileencoding',
    \   'mode': 'LightlineMode',
    \   'ctrlpmark': 'CtrlPMark',
    \ },
    \ 'component_expand': {
    \   'syntastic': 'SyntasticStatuslineFlag',
    \ },
    \ 'component_type': {
    \   'syntastic': 'error',
    \ },
    \ 'subseparator': { 'left': '|', 'right': '|' }
    \ }

  " Helper Functions {{{

  function! MyFiletype()
    return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype . ' ' . WebDevIconsGetFileTypeSymbol() : 'no ft') : ''
  endfunction

  function! MyFileformat()
    return winwidth(0) > 70 ? (&fileformat . ' ' . WebDevIconsGetFileFormatSymbol()) : ''
  endfunction

  function! LightlineModified()
    return &ft =~ 'help' ? '' : &modified ? '+' : &modifiable ? '' : '-'
  endfunction

  function! LightlineReadonly()
    return &ft !~? 'help' && &readonly ? '' : ''
  endfunction

  function! LightlineFilename()
    let fname = expand('%:t')
    return fname == 'ControlP' && has_key(g:lightline, 'ctrlp_item') ? g:lightline.ctrlp_item :
          \ fname == '__Tagbar__' ? g:lightline.fname :
          \ fname =~ '__Gundo\|NERD_tree' ? '' :
          \ &ft == 'vimfiler' ? vimfiler#get_status_string() :
          \ &ft == 'unite' ? unite#get_status_string() :
          \ &ft == 'vimshell' ? vimshell#get_status_string() :
          \ ('' != LightlineReadonly() ? LightlineReadonly() . ' ' : '') .
          \ ('' != fname ? fname : '[No Name]') .
          \ ('' != LightlineModified() ? ' ' . LightlineModified() : '')
  endfunction

  function! LightlineFugitive()
    try
      if expand('%:t') !~? 'Tagbar\|Gundo\|NERD' && &ft !~? 'vimfiler' && exists('*fugitive#head')
        let mark = ' '  " edit here for cool mark
        let branch = fugitive#head()
        return branch !=# '' ? mark.branch : ''
      endif
    catch
    endtry
    return ''
  endfunction

  function! LightlineFileencoding()
    return winwidth(0) > 70 ? (&fenc !=# '' ? &fenc : &enc) : ''
  endfunction

  function! LightlineMode()
    let fname = expand('%:t')
    return fname == '__Tagbar__' ? 'Tagbar' :
          \ fname == 'ControlP' ? 'CtrlP' :
          \ fname == '__Gundo__' ? 'Gundo' :
          \ fname == '__Gundo_Preview__' ? 'Gundo Preview' :
          \ fname =~ 'NERD_tree' ? 'NERDTree' :
          \ &ft == 'unite' ? 'Unite' :
          \ &ft == 'vimfiler' ? 'VimFiler' :
          \ &ft == 'vimshell' ? 'VimShell' :
          \ winwidth(0) > 60 ? lightline#mode() : ''
  endfunction

  let g:tagbar_status_func = 'TagbarStatusFunc'

  function! TagbarStatusFunc(current, sort, fname, ...) abort
      let g:lightline.fname = a:fname
    return lightline#statusline(0)
  endfunction

  let g:unite_force_overwrite_statusline = 0
  let g:vimfiler_force_overwrite_statusline = 0
  let g:vimshell_force_overwrite_statusline = 0
  "}}}
"}}}
"}}}


" 1.2.2 File Searching {{{
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': 'yes \| ./install' }
Plug 'junegunn/fzf.vim'
" fzf.vim {{{
  "let g:fzf_nvim_statusline = 0 " disable statusline overwriting

  " Similarly, we can apply it to fzf#vim#grep. To use ripgrep instead of ag:
  command! -bang -nargs=* Rg
    \ call fzf#vim#grep(
    \   'rg --column --line-number --no-heading --color=always '.shellescape(<q-args>), 1,
    \   <bang>0 ? fzf#vim#with_preview('up:60%')
    \           : fzf#vim#with_preview('right:50%:hidden', '?'),
    \   <bang>0)

"}}}
"}}}


" 1.2.3 Navigation {{{
Plug 'tpope/vim-unimpaired'
Plug 'christoomey/vim-tmux-navigator'
Plug 'qpkorr/vim-bufkill'
"}}}


" 1.2.4 Text Editing {{{
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
"}}}


" 1.2.5 Semantic Analysis {{{

" Code auto-completion
if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
  " deoplete {{{
    " let g:deoplete#enable_at_startup = 1
    function! s:is_whitespace()
      let col = col('.') - 1
      return ! col || getline('.')[col - 1] =~? '\s'
    endfunction

    " Use tab to c-j cycle, otherwise navigate insert mode
    " TODO: potentially switch to TAB because it's colliding with insert mode
    " navigations..
    inoremap <silent><expr><c-j> pumvisible() ? "\<c-n>" : "\<c-o>j"
    " Use tab to c-k cycle
    inoremap <silent><expr><c-k> pumvisible() ? "\<c-p>" : "\<c-o>k"

    " Hide preview window after closing completion
    autocmd InsertLeave * if pumvisible() == 0 | pclose | endif

    " Java completion settings
    let g:deoplete#enable_at_startup = 1
    let g:deoplete#omni_patterns = {}
    let g:deoplete#omni_patterns.java = '[^. *\t]\.\w*'
    let g:deoplete#sources = {}
    let g:deoplete#sources._ = []
    let g:deoplete#file#enable_buffer_path = 1

  "}}}
endif

" Code linting
Plug 'w0rp/ale'
"{{{

  let g:ale_linters = {
  \ 'javascript': ['eslint'],
  \ 'python': ['flake8', 'mypy'],
  \}

  let g:ale_python_flake8_options = '--max-line-length 120'

  " Error and warning signs.
  let g:ale_sign_error = '⤫'
  let g:ale_sign_warning = '⚠'

  let g:ale_lint_on_save = 1
  let g:ale_lint_on_text_changed = 0
  let g:ale_lint_on_enter = 0
  let g:ale_sign_warning = 'W>'
  let g:ale_sign_error = 'E>'
  let g:ale_set_quickfix = 1

  let g:ale_fixers = {'python': ['isort']}
  let g:ale_python_isort_options = ' --combine-as'.
          \ ' --use-parentheses'.
          \ ' --trailing-comma'.
          \ ' --multi-line 3'.
          \ ' -paffirm'.
          \ ' -otyping'.
          \ ' --line-width 100'.
          \ ' --virtual-env '.$ATT_WORKSPACE

"}}}

"}}}


" 1.2.6 Developer Tools {{{

" Git
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'airblade/vim-gitgutter'
Plug 'junegunn/gv.vim'

" Unix commands
Plug 'tpope/vim-eunuch'

" Run tests
Plug 'janko-m/vim-test'
"{{{ vim-test
  let test#python#runner = 'nose'
  " if has('nvim')
  "   let test#strategy = 'terminal'
  " else
  "   let test#strategy = 'vimterminal'
  " endif
"}}}

"}}}


" 1.2.7 Languages {{{

" Go
if executable('go')
  Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries' }
  " vim-go {{{
    let g:go_highlight_build_constraints = 1
    let g:go_highlight_extra_types = 1
    let g:go_highlight_fields = 1
    let g:go_highlight_functions = 1
    let g:go_highlight_methods = 1
    let g:go_highlight_operators = 1
    let g:go_highlight_structs = 1
    let g:go_highlight_types = 1

    " Semantic type inference on higlight
    let g:go_auto_type_info = 1

    " Auto import on write
    let g:go_fmt_command = 'goimports'
    "let g:go_decls_mode = 'fzf'

    " Highlight same variable name
    "let g:go_auto_sameids = 1

    " :GoAddTags will default to snakecase when generating tags
    let g:go_addtags_transform = "snakecase"

  "}}}
  if has('nvim')
    Plug 'zchee/deoplete-go', { 'do': 'make'}
  endif
endif

" JavaScript
Plug 'pangloss/vim-javascript'
" vim-javascript {{{
  let g:javascript_plugin_jsdoc = 1
  let g:javascript_plugin_flow = 1
"}}}
Plug 'mxw/vim-jsx'
" vim-jsx {{{
  let g:jsx_ext_required = 0
"}}}
if executable('npm')
  Plug 'ternjs/tern_for_vim', { 'do': 'npm install && npm install -g tern' }
  Plug 'carlitux/deoplete-ternjs', { 'do': 'npm install -g tern' }
  if has('nvim')
    Plug 'carlitux/deoplete-ternjs', { 'do': 'npm install -g tern' }
  endif
endif

" Python
Plug 'davidhalter/jedi-vim'
" jedi-vim {{{
  let g:jedi#goto_command = 'gd'
  let g:jedi#smart_auto_mappings = 0 " No auto import tyyping
  let g:jedi#popup_on_dot = 0 " Manually activate completions
  let g:jedi#goto_assignments_command = '' " goto fallsback onto assignments
  let g:jedi#goto_definitions_command = '' " deprecated!
  let g:jedi#documentation_command = 'K'
  let g:jedi#usages_command = '<leader>n'
  let g:jedi#completions_command = '<C-Space>'
  let g:jedi#rename_command = '<leader>r'
"}}}
if has('nvim')
  Plug 'zchee/deoplete-jedi'
  " deoplete-jedi {{{
    let g:deoplete#sources#jedi#show_docstring = 1
  "}}}
endif

" Additional Languages
Plug 'affirm/vim-policy-syntax'

Plug 'tomlion/vim-solidity'

Plug 'sheerun/vim-polyglot'

Plug 'hail2u/vim-css3-syntax'
Plug 'chrisbra/Colorizer'
" Colorizer {{{
  let g:colorizer_auto_filetype='css,html'
  nnoremap <silent> <c-h> :ColorToggle<cr>
"}}}
"}}}

call plug#end()


"===============================================================================
" 2. Editor Settings
"===============================================================================

colorscheme jellybeans

filetype indent plugin on           " plugins
set number                          " line numbers
set cursorline                      " highlight current line
set wrap                            " enable text wrap
set linebreak                       " don't hard wrap in the middle of word
set textwidth=80                    " hard wrap text after 80 chars
set colorcolumn=80                  " vertical line marker at 80 chars
set showcmd                         " show command in status bar
set scrolloff=5                     " keep at least 5 lines above/below
set shortmess+=aAIsT                " disable welcome screen and other messages
set showcmd                         " show any commands
set sidescroll=1                    " smoother horizontal scrolling
set sidescrolloff=5                 " keep at least 5 lines left/right
set splitbelow                      " create new splits below
set splitright                      " create new splits to the right
set wildmenu                        " enable wildmenu
set wildmode=longest:full,full      " configure wildmenu
set path+=**                        " recursive searching
set complete-=i                     " don't include all files, it's slow
set nostartofline                   " keeps cursor in place when switching buffers
set laststatus=2                    " extra status (lightline)
set noshowmode                      " hide the mode (lightline)
set showmatch                       " show unmatched parens
set lazyredraw                      " don't draw everything
set list                            " show invisible characters
set listchars=tab:>·,trail:·,nbsp:¬ " but only show useful characters
if has('termguicolors')
  set termguicolors                 " true color
endif
set background=dark
set backspace=indent,eol,start      " allow backspace

" Magic cursor switching?
if !has('nvim')
  let &t_ti.="\e[1 q"
  let &t_SI.="\e[5 q"
  let &t_EI.="\e[1 q"
  let &t_te.="\e[0 q"
endif

" Use true color
let $NVIM_TUI_ENABLE_TRUE_COLOR=1

" Folding
setl foldmethod=marker " hides markers within vim config
setl foldlevel=0
setl modelines=1

" Background
set mouse=                      " enable mouse support
set autoread                    " update file when changed outside of vim
" set clipboard=unnamed           " use native clipboard
set history=200                 " store last 200 commands as history
set nobackup                    " don't save backups
set noerrorbells                " no error bells please
set noswapfile                  " no swapfiles
set nowritebackup               " don't save a backup while editing
set ttyfast                     " indicates a fast terminal connection
set undodir=~/.vim/undodir      " set undofile location
set undofile                    " maintain undo history between sessions
set undolevels=1000             " store 1000 undos
set hidden                      " allow buffer to go into background

" Auto read/write on switch
au FocusGained,BufEnter * :checktime
au FocusLost,WinLeave * :silent! noautocmd w

" Whitespace
set expandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2
set smartindent   " copy indentation from the previous line for new line

" Search
set incsearch
set hlsearch
set smartcase
set ignorecase

" Auto insert if terminal open
if has('nvim')
  au TermOpen * setl nonumber norelativenumber
  au BufEnter * if &buftype == 'terminal' | :startinsert | endif
endif


"===============================================================================
" 3. Key Mappings
"===============================================================================

"-------------------------------------------------------------------------------
" 3.0 Training Wheels
"-------------------------------------------------------------------------------


"-------------------------------------------------------------------------------
" 3.1 General
"-------------------------------------------------------------------------------

let mapleader = " "

" Esc from insert mode using jj fast
inoremap jj <esc>

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

" Faster playback
nnoremap Q @q


"-------------------------------------------------------------------------------
" 3.2 Navigation
"-------------------------------------------------------------------------------

" Move into line wraps
nnoremap j gj
nnoremap k gk

" Nagivate window splits
nnoremap <c-h> <c-w><c-h>
nnoremap <c-j> <c-w><c-j>
nnoremap <c-k> <c-w><c-k>
nnoremap <c-l> <c-w><c-l>


"-------------------------------------------------------------------------------
" 3.3 Editing
"-------------------------------------------------------------------------------

" make Y like D
nnoremap Y y$

" Close all folds except the current line
nnoremap zp zMzv

" Toggle relative line numbers
nnoremap <silent> <C-n> :call ToggleRelativeNumber()<cr>


"-------------------------------------------------------------------------------
" 3.4 Terminal
"-------------------------------------------------------------------------------

if has('nvim') || has('terminal')

  " Create a new terminal
  nnoremap <silent> <c-t> :vsplit<cr>:NewTerminal<cr>
  tnoremap <silent> <c-t> <c-\><c-n>:vsplit<cr>:NewTerminal<cr>

  " Escape out of terminal
  tnoremap <c-[> <c-\><c-n>

  " Window-related <C-W> commands, but in terminal mode
  " TODO: this conflicts with backspace
  tnoremap <c-h> <c-\><c-n><c-w>h
  "TODO: this stays in normal if there's no window
  "maybe use alt-h instead for all window navs or tab...
  " and use c-j in terminal for scrolling up
  tnoremap <c-j> <c-\><c-n><c-w>j
  tnoremap <c-k> <c-\><c-n><c-w>k
  tnoremap <c-l> <c-\><c-n><c-w>l

  " Swap terminal windows
  tnoremap <c-w>H <c-\><c-n><c-w>H
  tnoremap <c-w>J <c-\><c-n><c-w>J
  tnoremap <c-w>K <c-\><c-n><c-w>K
  tnoremap <c-w>L <c-\><c-n><c-w>L
  tnoremap <c-w>r <c-\><c-n><c-w>r
  tnoremap <c-w>R <c-\><c-n><c-w>R
  tnoremap <c-w>T <c-\><c-n><c-w>T

  " New vertical split
  tnoremap <silent> <c-w>v <c-\><c-n>:vsplit<cr>

  " New horizontal split
  tnoremap <silent> <c-w>s <c-\><c-n>:sp<cr>

  " New tab
  tnoremap <silent> <c-w>t <c-\><c-n>:tabnew<cr>

" Close terminal window
  tnoremap <c-w>q <c-\><c-n><c-w>q
endif


"-------------------------------------------------------------------------------
" 3.5 File Searching
"-------------------------------------------------------------------------------

let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

" Open search
nnoremap <silent> <leader><leader> :Files<cr>
nnoremap <silent> <leader>p :GFiles<cr>
nnoremap <silent> <leader>m :GFiles?<cr>
nnoremap <silent> <leader>b :Buffers<cr>
nnoremap <silent> <leader>w :Windows<cr>
nnoremap <silent> <leader>; :BLines<cr>
nnoremap <silent> <leader>l :Lines<cr>
nnoremap <silent> <leader>h :History<cr>
nnoremap <silent> <leader>a :FindInExact<cr>

command! -bang -nargs=* FindIn
  \ call fzf#vim#grep(
  \ 'rg --column --line-number --no-heading --color=always '.shellescape(<q-args>), 1,
  \ {'options': '--delimiter : --nth 4..'},
  \ <bang>0)

command! -bang -nargs=* FindInExact
  \ call fzf#vim#grep(
  \ 'rg --column --line-number --no-heading --color=always '.shellescape(<q-args>), 1,
  \ {'options': '--delimiter : --nth 4.. --exact'},
  \ <bang>0)

function! SearchWordWithRg()
  execute 'FindInExact' expand('<cword>')
endfunction
nnoremap <silent> K :call SearchWordWithRg()<cr>

" Command for git grep
" - fzf#vim#grep(command, with_column, [options], [fullscreen])
command! -bang -nargs=* GGrep
  \ call fzf#vim#grep(
  \   'git grep --line-number '.shellescape(<q-args>), 0,
  \   { 'dir': systemlist('git rev-parse --show-toplevel')[0] }, <bang>0)

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

"===============================================================================
" 4. File Specific Settings
"===============================================================================

au FileType html call HtmlFileSettings()
au FileType javascript call JavascriptFileSettings()
au FileType java call JavaFileSettings()
au FileType go call GoFileSettings()
au FileType python call PythonFileSettings()
au FileType markdown call PlainTextFileSettings()
au FileType txt call PlainTextFileSettings()
au FileType tex call PlainTextFileSettings()
au FileType python call PythonFileSettings()
au FileType cucumber call CucumberFileSettings()
au BufRead,BufNewFile *.jsp call JspFileSettings()
au BufRead,BufNewFile *.tmpl call GoTmplFileSettings()
au BufRead,BufNewFile *.sig setl filetype=sml
au BufRead,BufNewFile *.bsh setl syntax=java
au BufRead,BufNewFile .gitconfig-* setl filetype=gitconfig
au BufRead,BufNewFile .zsh_extras setl filetype=zsh
au BufRead,BufNewFile .bash_extras setl filetype=sh

function! PlainTextFileSettings()
  setl textwidth=80 wrap linebreak
endfunc

function! HtmlFileSettings()
  setl sts=2 sw=2 ts=2
endfunc

function! JavascriptFileSettings()
  "TODO: figure this out or don't use javacomplete
  "setl omnifunc=javacomplete#Complete
  setl sts=2 sw=2 ts=2
endfunc

function! JspFileSettings()
  setl syntax=html
  setl sts=2 sw=2 ts=2
endfunc

function! GoTmplFileSettings()
  setl syntax=html
  setl sts=2 sw=2 ts=2
endfunc

function! GoFileSettings()
  setl noexpandtab
endfunc

function! JavaFileSettings()
  setl sts=2 sw=2 ts=2
  setl colorcolumn=90
  setl textwidth=90
  nnoremap K :JavaDocPreview<cr>
  nnoremap <Leader>jr  :JavaRename 
  nnoremap <Leader>ji  :JavaImport<cr>
  nnoremap <Leader>jio :JavaImportOrganize<cr>
  nnoremap <Leader>jch :JavaCallHierarchy<cr>
  nnoremap <Leader>js  :JavaSearch<cr>
  nnoremap <Leader>jc  :JavaCorrect<cr>
  nnoremap <Leader>jcs :Checkstyle<cr>
endfunc

function! PythonFileSettings()
  set sts=4 sw=4 ts=4
  setl colorcolumn=120
  setl textwidth=120
endfunc

function! CucumberFileSettings()
  set sts=4 sw=4 ts=4
  setl colorcolumn=120
  setl textwidth=120
endfunc

"===============================================================================
" 5. Registered Commands
"===============================================================================

function! EditZshrc()
  edit ~/.zshrc
endfunc
command! Ezp call EditZshrc()

function! EditBashProfile()
  edit ~/.bash_profile
endfunc
command! Ebp call EditBashProfile()

function! EditBashAliases()
  edit ~/.bash_aliases
endfunc
command! Eba call EditBashAliases()

function! NewTerminal()
  if has('nvim')
    terminal
  else
    terminal++curwin
  endif
endfunc
command! NewTerminal call NewTerminal()

"===============================================================================
" 6. Helper Functions
"===============================================================================

function! HasTerminal()
  return has('nvim') || has('terminal')
endfunc

function! ToggleRelativeNumber()
  if &relativenumber == 1
    set norelativenumber
  else
    set relativenumber
  endif
endfunc
