let s:statuslinemode = {
  \ 'n': 'NORMAL',
  \ 'no': 'N·Operator Pending',
  \ 'v': 'VISUAL',
  \ 'V': 'V-LINE',
  \ 'x22': 'V-BLOCK',
  \ "\<C-v>": 'V-BLOCK',
  \ 's': 'SELECT',
  \ 'S': 'S-LINE',
  \ "\<C-s>": 'S-BLOCK',
  \ 'i': 'INSERT',
  \ 'R': 'REPLACE',
  \ 'Rv': 'V-REPLACE',
  \ 'c': 'COMMAND',
  \ 'cv': 'Vim Ex',
  \ 'ce': 'Ex',
  \ 'r': 'Prompt',
  \ 'rm': 'More',
  \ 'r?': 'Confirm',
  \ '!': 'Shell',
  \ 't': 'TERMINAL',
  \}

function! statusline#Mode()
  return s:statuslinemode[mode()]
endfunction

function! statusline#Paste()
    if &paste == 1
        return "PASTE"
    else
        return ""
    endif
endfunction

function! statusline#GitBranch()
  " use fugitive instead of making an external call on each statusline render
  let l:mark = ' '
  let l:branch = fugitive#head()
  return l:branch != '' ? l:mark.l:branch : ''
endfunction

function! statusline#Filetype()
  return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype . ' ' . WebDevIconsGetFileTypeSymbol() : 'no ft') : ''
endfunction

function! statusline#Fileformat()
  return winwidth(0) > 70 ? (&fileformat . ' ' . WebDevIconsGetFileFormatSymbol()) : ''
endfunction

function! statusline#Modified()
  return &ft =~ 'help' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! statusline#Readonly()
  return &ft !~? 'help' && &readonly ? '' : ''
endfunction

function! statusline#Fileencoding()
  return winwidth(0) > 70 ? (&fenc !=# '' ? &fenc : &enc) : ''
endfunction
