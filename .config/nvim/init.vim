let g:vim_home = expand('~/.config/nvim')
let g:vim_plug_dir = g:vim_home.'/autoload'
let g:vimrc = g:vim_home.'/init.vim'

function! VimrcLoadPlugins()
  let vim_plug = g:vim_plug_dir.'/plug.vim'
  " Install vim-plug if not available
  if !filereadable(vim_plug)
    echo "Installing vim-plug..."
    call mkdir(g:vim_plug_dir, 'p')
    silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
      \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    execute 'source '.fnameescape(vim_plug)
  endif

  call plug#begin('~/.vim/plugged')
  Plug 'nanotech/jellybeans.vim'

  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': 'yes \| ./install' }
  Plug 'junegunn/fzf.vim'

  Plug 'tpope/vim-fugitive'

  call plug#end()
endfunction
call VimrcLoadPlugins()

" Interface
filetype indent plugin on               " plugins
set number                              " line numbers
set cursorline                          " highlight current line
set wrap                                " enable text wrap
set linebreak                           " don't hard wrap in the middle of word
set textwidth=80                        " hard wrap text after 80 chars
set colorcolumn=80                      " vertical line marker at 80 chars
set showcmd                     " show command in status bar
set scrolloff=5                 " keep at least 5 lines above/below
set shortmess+=aAIsT            " disable welcome screen and other messages
set showcmd                     " show any commands
set sidescroll=1                " smoother horizontal scrolling
set sidescrolloff=5             " keep at least 5 lines left/right
set splitbelow                  " create new splits below
set splitright                  " create new splits to the right
set wildmenu                    " enable wildmenu
set wildmode=longest:full,full  " configure wildmenu
set nostartofline               " keeps cursor in place when switching buffers
set laststatus=2                " extra status (lightline)
set noshowmode                  " hide the mode (lightline)
set showmatch                   " show unmatched parens
set lazyredraw                  " don't draw everything
set list                              " show invisible characters
set listchars=tab:>·,trail:·,nbsp:¬   " but only show useful characters
set termguicolors                     " true color
set background=dark
colorscheme jellybeans

" Use true color
let $NVIM_TUI_ENABLE_TRUE_COLOR=1

" Terminal colors
let g:terminal_color_0  = '#3b3b3b'
let g:terminal_color_1  = '#cf6a4c'
let g:terminal_color_2  = '#99ad6a'
let g:terminal_color_3  = '#d8ad4c'
let g:terminal_color_4  = '#597bc5'
let g:terminal_color_5  = '#a037b0'
let g:terminal_color_6  = '#71b9f8'
let g:terminal_color_7  = '#adadad'
let g:terminal_color_8  = '#3b3b3b'
let g:terminal_color_9  = '#cf6a4c'
let g:terminal_color_10  = '#99ad6a'
let g:terminal_color_11  = '#d8ad4c'
let g:terminal_color_12  = '#597bc5'
let g:terminal_color_13  = '#a037b0'
let g:terminal_color_14  = '#71b9f8'
let g:terminal_color_15  = '#adadad'

" Folding
setl foldmethod=marker           " hides markers within vim config
setl foldlevel=0
setl modelines=1

" Background
set autoread                    " update file when changed outside of vim
set clipboard=unnamed           " use native clipboard
set history=200                 " store last 200 commands as history
set nobackup                    " don't save backups
set noerrorbells                " no error bells please
set noswapfile                  " no swapfiles
set nowritebackup               " don't save a backup while editing
set ttyfast                     " indicates a fast terminal connection
set undodir=~/.vim/undodir      " set undofile location
set undofile                    " maintain undo history between sessions
set undolevels=1000             " store 1000 undos

" Whitespace
set expandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2
set smartindent                 " copy indentation from the previous line for new line

" Search
set incsearch
set hlsearch
set smartcase
set ignorecase

" Key Mappings
let mapleader = " "

" Esc from insert mode using jj fast
inoremap jj <esc>

" Move into line wraps
nnoremap j gj
nnoremap k gk

" New tab
nnoremap <c-t> :tabnew<cr>

nnoremap <c-p> :vsplit<cr>:terminal<cr>

" Open search
nnoremap <silent> <leader><leader> :Files<cr>
nnoremap <silent> <leader>g :GFiles<cr>
nnoremap <silent> <leader>m :GFiles?<cr>
nnoremap <silent> <leader>b :Buffers<cr>
nnoremap <silent> <leader>w :Windows<cr>
nnoremap <silent> <leader>; :BLines<cr>
"nnoremap <silent> <leader>o :BTags<cr>
"nnoremap <silent> <leader>O :Tags<cr>
nnoremap <silent> <leader>? :History<cr>

" Shorter window nagivation
nnoremap <c-h> <c-w><c-h>
nnoremap <c-j> <c-w><c-j>
nnoremap <c-k> <c-w><c-k>
nnoremap <c-l> <c-w><c-l>

" Move to next git modification
nnoremap <c-g>j :GitGutterNextHunk<cr><esc>
nnoremap <c-g>k :GitGutterPrevHunk<cr><esc>

" Fugitive Git commands
nnoremap gb :Gblame<cr><esc>
nnoremap gs :Gstatus<cr><esc>
nnoremap gc :Gcommit<cr>

" Toggle hard word wrap
function! ToggleWordWrap()
  let format_option = strridx(&formatoptions, 't')
  if format_option > 0
    set formatoptions-=t
    echo 'Word wrap disabled'
  else
    set formatoptions+=t
    echo 'Word wrap enabled'
  endif
endfunc
nnoremap <c-w> :call ToggleWordWrap()<cr>

" Toggle relative line numbers
function! ToggleRelativeNumber()
  if &relativenumber == 1
    set norelativenumber
  else
    set relativenumber
  endif
endfunc
nnoremap <silent> <C-n> :call ToggleRelativeNumber()<cr>

" Open vimrc
nnoremap <leader>ov :execute 'edit' g:vimrc<cr>

" Edit vimrc
nnoremap <leader>ev :execute 'vsplit '.fnameescape(g:vimrc)<cr>

" Source vimrc 
nnoremap <leader>sv :execute 'source '.fnameescape(g:vimrc)<cr>

" Clear search
nnoremap <return> :noh<cr><esc>

nnoremap <leader>f :NERDTreeToggle<cr><esc>

" File Settings
au FileType html call HtmlFileSettings()
au FileType javascript call JavascriptFileSettings()
au FileType java call JavaFileSettings()
au FileType go call GoFileSettings()
au FileType markdown, txt, tex call PlainTextFileSettings()
au BufRead,BufNewFile *.jsp call JspFileSettings()
au BufRead,BufNewFile *.tmpl call GoTmplFileSettings()
au BufRead,BufNewFile  *.sig setl filetype=sml
au BufRead,BufNewFile *.thrift, *.bsh setl syntax=java

function! PlainTextFileSettings()
  setl textwidth=80 wrap linebreak
endfunc

function! HtmlFileSettings()
  setl sts=2 sw=2 ts=2
endfunc

function! JavascriptFileSettings()
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
  nnoremap K :JavaDocPreview<cr>
  nnoremap <Leader>jr  :JavaRename 
  nnoremap <Leader>ji  :JavaImport<cr>
  nnoremap <Leader>jio :JavaImportOrganize<cr>
  nnoremap <Leader>jch :JavaCallHierarchy<cr>
  nnoremap <Leader>js  :JavaSearch<cr>
  nnoremap <Leader>jc  :JavaCorrect<cr>
  nnoremap <Leader>jcs :Checkstyle<cr>
endfunc
