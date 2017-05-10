# kaybinwang's dotfiles
The configuration I use on MacOS.

## Installation
Note these are the steps I take for a clean install on a new system. Please backup your existing environment before you overwrite any files.

1. Clone the repository to `~`.
```
git clone https://github.com/kaybinwang/dotfiles.git ~/
```
2. Execute `install.sh`.
```
cd
./scripts/install.sh
```

If you're using a terminal without true color support, comment out the line `set termguicolors` in `.vimrc`.

## About
Information about some of the stuff I use.

### Terminal
Currently using `iTerm 2.0`.

### Vim
- Version: 8.0
- Colors: [vim-one](https://github.com/rakr/vim-one)
- Semantic Completion: [completor.vim](https://github.com/maralla/completor.vim)
    - Java: [javacomplete2](https://github.com/artur-shaik/vim-javacomplete2)
    - Python: [jedi](https://github.com/davidhalter/jedi)
- Syntax Checker: [syntastic](https://github.com/vim-syntastic/syntastic)
    - Python: [pylint](https://github.com/PyCQA/pylint)
- Fuzzy Search: [ctrlp](https://github.com/kien/ctrlp.vim)

### Tmux
