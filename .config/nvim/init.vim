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
  "{{{
    "let g:fzf_nvim_statusline = 0 " disable statusline overwriting
  "}}}

  Plug 'danro/rename.vim'

  Plug 'jiangmiao/auto-pairs'

  Plug 'itchyny/lightline.vim'
  "{{{

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

  Plug 'tpope/vim-fugitive'
  Plug 'airblade/vim-gitgutter'

  Plug 'tpope/vim-repeat'

  Plug 'ryanoasis/vim-devicons'

  Plug 'ConradIrwin/vim-bracketed-paste'

  Plug 'junegunn/vim-easy-align'
  "{{{
    " Start interactive EasyAlign in visual mode (e.g. vipga)
    xmap ga <Plug>(EasyAlign)

    " Start interactive EasyAlign for a motion/text object (e.g. gaip)
    nmap ga <Plug>(EasyAlign)
  "}}}

  Plug 'w0rp/ale'
  "{{{

    let g:ale_linters = {
    \ 'javascript': ['eslint'],
    \}

    " Error and warning signs.
    let g:ale_sign_error = '⤫'
    let g:ale_sign_warning = '⚠'

    let g:ale_lint_on_save = 1
    let g:ale_lint_on_text_changed = 0
    let g:ale_lint_on_enter = 0
    let g:ale_sign_warning = 'W>'
    let g:ale_sign_error = 'E>'
    let g:ale_set_quickfix = 1

  "}}}

  Plug 'hail2u/vim-css3-syntax'
  Plug 'chrisbra/Colorizer'
  "{{{
    let g:colorizer_auto_filetype='css,html'
    nnoremap <silent> <c-h> :ColorToggle<cr>
  "}}}

  Plug 'pangloss/vim-javascript'
  "{{{
    let g:javascript_plugin_jsdoc = 1
    let g:javascript_plugin_flow = 1
  "}}}
  Plug 'mxw/vim-jsx'
  "{{{
    let g:jsx_ext_required = 0
  "}}}
  Plug 'ternjs/tern_for_vim', { 'do': 'npm install && npm install -g tern' }

  Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries' }
  "{{{ vim-go
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
    let g:go_decls_mode = 'fzf'

    " Highlight same variable name
    "let g:go_auto_sameids = 1

    " :GoAddTags will default to snakecase when generating tags
    let g:go_addtags_transform = "snakecase"

  "}}}

  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
  "{{{ deoplete

    if has('nvim')
      " Enable deoplete on startup
      let g:deoplete#enable_at_startup = 1
    endif

    let g:python_host_prog = '/usr/local/bin/python2'
    let g:python3_host_prog = '/usr/local/bin/python3'"

    function! s:is_whitespace()
      let col = col('.') - 1
      return ! col || getline('.')[col - 1] =~? '\s'
    endfunction

    " Use tab to forward cycle
    inoremap <silent><expr><c-j> pumvisible() ? "\<c-n>" : "\<tab>"
    " Use tab to backward cycle
    inoremap <silent><expr><c-k> pumvisible() ? "\<c-p>" : "\<s-tab>"

    " Hide preview window after closing completion
    "autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif
    autocmd InsertLeave * if pumvisible() == 0 | pclose | endif

  "}}}
  Plug 'zchee/deoplete-go'
  Plug 'carlitux/deoplete-ternjs', { 'do': 'npm install -g tern' }
  Plug 'zchee/deoplete-jedi'
  "{{{
    let g:deoplete#sources#jedi#show_docstring = 1
  "}}}

  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-unimpaired'

  Plug 'scrooloose/nerdtree'
  "{{{

    " Single click expand
    let g:NERDTreeMouseMode=2

  "}}}

  " Put this after vim-go and unimpaired
  Plug 'qpkorr/vim-bufkill'
  "{{{
    nnoremap <silent> ZB :bd!<cr>
    nnoremap <silent> Zb :BD!<cr>
    nmap <silent> b[ :BB<cr>
    nmap <silent> b] :BF<cr>
    omap <silent> b[ :BB<cr>
    omap <silent> b] :BF<cr>
    xmap <silent> b[ :BB<cr>
    xmap <silent> b] :BF<cr>
  "}}}

  call plug#end()
endfunction
call VimrcLoadPlugins()

" Interface
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
set nostartofline                   " keeps cursor in place when switching buffers
set laststatus=2                    " extra status (lightline)
set noshowmode                      " hide the mode (lightline)
set showmatch                       " show unmatched parens
set lazyredraw                      " don't draw everything
set list                            " show invisible characters
set listchars=tab:>·,trail:·,nbsp:¬ " but only show useful characters
set termguicolors                   " true color
set background=dark
colorscheme jellybeans

" Use true color
let $NVIM_TUI_ENABLE_TRUE_COLOR=1

" Terminal colors
let g:terminal_color_0  = '#3b3b3b'
let g:terminal_color_1  = '#ea8986'
let g:terminal_color_2  = '#a4c38c'
let g:terminal_color_3  = '#ffc68d'
let g:terminal_color_4  = '#a7cae3'
let g:terminal_color_5  = '#e8cefb'
let g:terminal_color_6  = '#00a7a0'
let g:terminal_color_7  = '#c9c9c9'
let g:terminal_color_8  = '#3b3b3b'
let g:terminal_color_9  = '#ffb2b0'
let g:terminal_color_10 = '#c8e3b9'
let g:terminal_color_11 = '#ffe2af'
let g:terminal_color_12 = '#bee0f8'
let g:terminal_color_13 = '#fce3ff'
let g:terminal_color_14 = '#0cbeb7'
let g:terminal_color_15 = '#c9c9c9'

" Folding
setl foldmethod=marker " hides markers within vim config
setl foldlevel=0
setl modelines=1

" Background
set mouse=a                     " enable mouse support
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

" Auto read/write on switch
au FocusGained,BufEnter * :silent! !
"au FocusLost,WinLeave * :silent! w

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

" Key Mappings
let mapleader = " "

" Esc from insert mode using jj fast
inoremap jj <esc>

" Move into line wraps
nnoremap j gj
nnoremap k gk

" Faster playback
nnoremap Q @q

" New tab
nnoremap <silent> <c-t>t :tabnew<cr>
tnoremap <silent> <c-t>t <c-\><c-n>:tabnew<cr>

" Auto insert if terminal open
au BufEnter * if &buftype == 'terminal' | :startinsert | endif
nnoremap <silent> <c-p> :vsplit<cr>:terminal<cr>
tnoremap <silent> <c-p> <c-\><c-n>:vsplit<cr>:terminal<cr>

" Window navigation
tnoremap <c-h> <c-\><c-n><c-w>h
tnoremap <c-j> <c-\><c-n><c-w>j
tnoremap <c-k> <c-\><c-n><c-w>k
tnoremap <c-l> <c-\><c-n><c-w>l

" Prevent window nav mappins from leaving fzf
autocmd FileType fzf tnoremap <buffer> <c-j> <down>
autocmd FileType fzf tnoremap <buffer> <c-k> <up>

" Vertical split
tnoremap <silent> <c-w>s <c-\><c-n>:vsplit<cr>

" Close
tnoremap <c-q> <c-\><c-n>ZZ
nnoremap <c-q> ZZ

nnoremap <silent> <c-s> :update<cr>

" Visual mode
tnoremap <c-v> <c-\><c-n>

" Close all folds except the current line
nnoremap zp zMzv

" Open search
nnoremap <silent> <leader><leader> :Files<cr>
nnoremap <silent> <leader>p :GFiles<cr>
nnoremap <silent> <leader>m :GFiles?<cr>
nnoremap <silent> <leader>b :Buffers<cr>
nnoremap <silent> <leader>w :Windows<cr>
nnoremap <silent> <leader>; :BLines<cr>
nnoremap <silent> <leader>l :Lines<cr>
"nnoremap <silent> <leader>o :BTags<cr>
"nnoremap <silent> <leader>O :Tags<cr>
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

" Shorter window nagivation
" This can't be <c-h> or else it will break search scroll
nnoremap <c-h> <c-w><c-h>
nnoremap <c-j> <c-w><c-j>
nnoremap <c-k> <c-w><c-k>
nnoremap <c-l> <c-w><c-l>

" Move to next git modification
nnoremap <silent> <leader>gp :GitGutterPreviewHunk<cr>
nnoremap <silent> <leader>gu :GitGutterUndoHunk<cr>

" Fugitive Git commands
nnoremap <silent> gb :Gblame<cr>
nnoremap <silent> gs :Gstatus<cr>
nnoremap <silent> gc :Gcommit<cr>

" Close preview window
nnoremap <silent> zz :pc<cr>

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
nnoremap <silent> <c-e> :call ToggleWordWrap()<cr>

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
nnoremap <silent> <leader>ev :execute 'vsplit '.fnameescape(g:vimrc)<cr>

" Source vimrc 
nnoremap <silent> <leader>sv :execute 'source '.fnameescape(g:vimrc)<cr>

" Reload plugins
nnoremap <silent> <leader>rp <leader>sv<cr>:PlugInstall<cr>

" Clear search
nnoremap <silent> <return> :noh<cr><esc>

nnoremap <silent> <leader>f :NERDTreeToggle<cr><esc>

" File Settings
au FileType html call HtmlFileSettings()
au FileType javascript call JavascriptFileSettings()
au FileType java call JavaFileSettings()
au FileType go call GoFileSettings()
au FileType markdown call PlainTextFileSettings()
au FileType txt call PlainTextFileSettings()
au FileType tex call PlainTextFileSettings()
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
