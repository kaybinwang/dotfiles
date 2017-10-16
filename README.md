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
3. Apply a [Nerd Font](https://github.com/ryanoasis/nerd-fonts) to terminal.

If you're using a terminal without true color support, comment out the line `set termguicolors` in `.vimrc`.

## About
Information about some of the stuff I use.

### Terminal
Currently using [iTerm 2.0](https://www.iterm2.com).

### NeoVim
- Version: 8.0
- Colors: [vim-one](https://github.com/rakr/vim-one)
- Semantic Completion: [completor.vim](https://github.com/maralla/completor.vim)
    - Java: [javacomplete2](https://github.com/artur-shaik/vim-javacomplete2)
    - Python: [jedi](https://github.com/davidhalter/jedi)
- Syntax Checker: [syntastic](https://github.com/vim-syntastic/syntastic)
    - Python: [pylint](https://github.com/PyCQA/pylint)
- Fuzzy Search: [ctrlp](https://github.com/kien/ctrlp.vim)

## TODO
- Have a `update_dotfiles` command in `PATH` that will execute the install
  script and pull from repo and update the dotfiles.
- Install and customize languages, e.g. Python, Go, ...
- Add a curl hook that will execute bootstrap
- Ctrl Key remap
- tab colors (need newer bash)
- make neovim config file backwards compatible
- bash profile document (alias)
- create dotfiles if they don't exist on linking
- make bash profile backwards compatible (for bashrc), also so we can source
  safely
- create verbose command tree, e.g. `dfsetup create [pkg]`, `dfsetup reinstall [pkg]`
