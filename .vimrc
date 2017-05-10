" General Settings {{{
set nocompatible                " vim, not vi [must be first]
syntax on                       " syntax highlightling
filetype plugin indent on       " filetype plugin indentation
set hidden                      " hides buffers even with changes

setlocal foldmethod=marker      " hides markers within vim config
setlocal foldlevel=0
setlocal modelines=1
"}}}

" Interface {{{
set number                      " line numbers
set colorcolumn=81              " hard line at 81 characters
set cursorline                  " highlight current line
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
set ruler                       " show relative line/pos at bottom
set laststatus=2                " extra status (lightline)
set noshowmode                  " hide the mode (lightline)
set showmatch                   " show unmatched parens
set lazyredraw                  " don't draw everything
"}}}

" Whitespace {{{
set expandtab                   " use tabs instead of spaces
set nojoinspaces                " use one space, not two, after punctuation
set shiftround                  " shift to next tabstop
set shiftwidth=4                " amount of space used for indentation
set softtabstop=4               " appearance of tabs
set tabstop=4                   " use two spaces for tabs
"}}}

" Text appearance {{{
set list                              " show invisible characters
set listchars=tab:>·,trail:·,nbsp:¬   " but only show useful characters
set nowrap
"}}}

" Interaction {{{
set backspace=2                 " make backspace work like most other apps
set whichwrap=b,s,h,l,<,>,[,]   " backspace and cursor keys wrap too
"}}}

" Searching {{{
set hlsearch                    " highlight search matches
set ignorecase                  " set case insensitive searching
set incsearch                   " find as you type search
set smartcase                   " case sensitive searching when not all lowercase
"}}}

" Background {{{
set autoread                    " update file when changed outside of vim
set autoindent                  " copy indentation from the previous line for new line
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
"}}}

" Encoding {{{
if !&readonly && &modifiable
  set fileencoding=utf-8        " the encoding written to file
endif
set encoding=utf-8              " the encoding displayed
"}}}

" Mappings {{{
let mapleader = " "

" Esc from insert mode using jj fast
inoremap jj <Esc>

" Shorter window nagivation
nnoremap <C-H> <C-W><C-H>
nnoremap <C-J> <C-W><C-J>
nnoremap <C-J> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>

" Toggle relative line numbers
nnoremap <silent> <C-n> :call RelativeNumberToggle()<cr>

" Newline without insert
nnoremap <cr> o<esc>

" Toggle paste mode
set pastetoggle=<F2>
nnoremap <silent> <leader>p :set paste<CR>"*p:set nopaste<CR>

" Sort
vnoremap <leader>s :sort<CR>

" Fix tabs to settings
nnoremap <Leader>t :retab<CR>

" Edit vimrc
nnoremap <leader>ev :vsplit $MYVIMRC<cr>

" Source vimrc 
nnoremap <leader>sv :source $MYVIMRC<CR>

" Save
nnoremap <Leader>w :w<CR>

" Clear search
nnoremap <leader>c :noh<CR>

" Select all
nnoremap <leader>a ggVG<CR>

" Copy all
nnoremap <leader>y ggVGy<CR>

" Upper or lowercase the current word
nnoremap <leader>^ gUiW
nnoremap <leader>v guiW
"}}}

" File Settings {{{
au BufRead,BufNewFile  *.sig setl filetype=sml
au FileType html setl sts=2 sw=2 ts=2
au FileType javascript setl sts=2 sw=2 ts=2
au FileType java setl colorcolumn=100
au FileType txt setl textwidth=80 wrap
au FileType tex setl textwidth=80 wrap
au FileType markdown setl wrap
"}}}

" Plugin list {{{

" Automatically install vim-plug and run PlugInstall if vim-plug not found
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
Plug 'rakr/vim-one'
Plug 'lifepillar/vim-solarized8'
Plug 'morhetz/gruvbox'
Plug 'itchyny/lightline.vim'
Plug 'ryanoasis/vim-devicons'
Plug 'itchyny/lightline.vim'
Plug 'vim-syntastic/syntastic'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'scrooloose/nerdcommenter'
Plug 'maralla/completor.vim'
Plug 'artur-shaik/vim-javacomplete2'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
call plug#end()
"}}}

" Theme {{{

set termguicolors
set background=light
colorscheme one

"}}}

" Lightline {{{

let g:lightline = {
      \ 'colorscheme': 'one',
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

function! LightlineFileformat()
  return winwidth(0) > 70 ? &fileformat : ''
endfunction

function! LightlineFiletype()
  return winwidth(0) > 70 ? (&filetype !=# '' ? &filetype : 'no ft') : ''
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

function! CtrlPMark()
  if expand('%:t') =~ 'ControlP' && has_key(g:lightline, 'ctrlp_item')
    call lightline#link('iR'[g:lightline.ctrlp_regex])
    return lightline#concatenate([g:lightline.ctrlp_prev, g:lightline.ctrlp_item
          \ , g:lightline.ctrlp_next], 0)
  else
    return ''
  endif
endfunction

let g:ctrlp_status_func = {
  \ 'main': 'CtrlPStatusFunc_1',
  \ 'prog': 'CtrlPStatusFunc_2',
  \ }

function! CtrlPStatusFunc_1(focus, byfname, regex, prev, item, next, marked)
  let g:lightline.ctrlp_regex = a:regex
  let g:lightline.ctrlp_prev = a:prev
  let g:lightline.ctrlp_item = a:item
  let g:lightline.ctrlp_next = a:next
  return lightline#statusline(0)
endfunction

function! CtrlPStatusFunc_2(str)
  return lightline#statusline(0)
endfunction

let g:tagbar_status_func = 'TagbarStatusFunc'

function! TagbarStatusFunc(current, sort, fname, ...) abort
    let g:lightline.fname = a:fname
  return lightline#statusline(0)
endfunction

augroup AutoSyntastic
  autocmd!
  autocmd BufWritePost *.c,*.cpp call s:syntastic()
augroup END
function! s:syntastic()
  SyntasticCheck
  call lightline#update()
endfunction

let g:unite_force_overwrite_statusline = 0
let g:vimfiler_force_overwrite_statusline = 0
let g:vimshell_force_overwrite_statusline = 0
"}}}

"}}}

" Ctrl-P {{{
" index current directory
let g:ctrlp_working_path_mode = '0'

" ignore files
set wildignore+=*/tmp/*,*.so,*.swp,*.zip     " MacOSX/Linux
set wildignore+=*\\tmp\\*,*.swp,*.zip,*.exe  " Windows
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|hg|svn)$',
  \ 'file': '\v\.(exe|so|dll)$',
  \ }
"}}}

" VimDevIcons {{{
let g:webdevicons_enable = 1
let g:webdevicons_enable_ctrlp = 1
"}}}

" completor.vim {{{
let g:completor_python_binary = '/usr/local/bin/python'
let g:completor_java_omni_trigger = "[\\w\\)\\]\\}'\"]+\\.\\w*$"

" tab cycling
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr> pumvisible() ? "\<C-y>\<cr>" : "\<cr>"
"}}}

" javacomplete2 {{{
au FileType java setl omnifunc=javacomplete#Complete
"}}}

" NERD Commenter {{{
let NERDSpaceDelims=1
"}}}

" Syntastic {{{
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

let g:syntastic_javascript_checkers=['eslint']
let g:syntastic_python_checkers = ['pylint']
let g:syntastic_java_checkers=['javac']
let g:syntastic_java_javac_config_file_enabled = 1
"}}}
