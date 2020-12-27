function! dotfiles#EditZshrc()
  edit ~/.zshrc
endfunc
command! Ezp call dotfiles#EditZshrc()

function! dotfiles#EditBashProfile()
  edit ~/.bash_profile
endfunc
command! Ebp call dotfiles#EditBashProfile()

function! dotfiles#EditBashAliases()
  edit ~/.bash_aliases
endfunc
command! Eba call dotfiles#EditBashAliases()
