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

  Plug 'itchyny/lightline.vim'

  Plug 'tpope/vim-fugitive'
  Plug 'airblade/vim-gitgutter'

  Plug 'ryanoasis/vim-devicons'

  Plug 'ConradIrwin/vim-bracketed-paste'

  "{{{ vim-go
    Plug 'fatih/vim-go'
    let g:go_highlight_build_constraints = 1
    let g:go_highlight_extra_types = 1
    let g:go_highlight_fields = 1
    let g:go_highlight_functions = 1
    let g:go_highlight_methods = 1
    let g:go_highlight_operators = 1
    let g:go_highlight_structs = 1
    let g:go_highlight_types = 1

    " Auto import on write
    let g:go_fmt_command = "goimports"
  "}}}

  "{{{ deoplete
    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
    if has('nvim')
      " Enable deoplete on startup
      let g:deoplete#enable_at_startup = 1
    endif
  "}}}

  Plug 'zchee/deoplete-go'

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
set hidden                      " allow buffer to go into background

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

" Terminal
nnoremap <c-p> :vsplit<cr>:terminal<cr>
tnoremap <c-w>h <C-\><C-N><C-w>h
tnoremap <c-w>j <C-\><C-N><C-w>j
tnoremap <c-w>k <C-\><C-N><C-w>k
tnoremap <c-w>l <C-\><C-N><C-w>l
tnoremap zz <C-\><C-n>ZZ

" Open search
nnoremap <silent> <leader><leader> :Files<cr>
nnoremap <silent> <leader>g :GFiles<cr>
nnoremap <silent> <leader>m :GFiles?<cr>
nnoremap <silent> <leader>b :Buffers<cr>
nnoremap <silent> <leader>w :Windows<cr>
nnoremap <silent> <leader>; :BLines<cr>
"nnoremap <silent> <leader>o :BTags<cr>
"nnoremap <silent> <leader>O :Tags<cr>
nnoremap <silent> <leader>h :History<cr>
nnoremap <silent> <leader>a :Ag<cr>

command! -bang -nargs=* Find
  \ call fzf#vim#grep(
  \ 'rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>),
  \ 1, <bang>0)

function! SearchWordWithAg()
  execute 'Ag' expand('<cword>')
endfunction
nnoremap <silent> K :call SearchWordWithAg()<cr>

" Shorter window nagivation
nnoremap <c-w>h <c-w><c-h>
nnoremap <c-w>j <c-w><c-j>
nnoremap <c-w>k <c-w><c-k>
nnoremap <c-w>l <c-w><c-l>

" Move to next git modification
nnoremap <c-g>k :GitGutterPrevHunk<cr>
nnoremap <c-g>j :GitGutterNextHunk<cr>
nnoremap <c-g>p :GitGutterPreviewHunk<cr>
nnoremap <c-g>u :GitGutterUndoHunk<cr>

" Fugitive Git commands
nnoremap gb :Gblame<cr>
nnoremap gs :Gstatus<cr>
nnoremap gc :Gcommit<cr>

" Close preview window
nnoremap zz :pc<cr>

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
nnoremap <silent> <return> :noh<cr><esc>

nnoremap <silent> <leader>f :NERDTreeToggle<cr><esc>

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

" Lightline {{{

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
