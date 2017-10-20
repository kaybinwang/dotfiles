# kaybinwang's dotfiles
The configuration I use on MacOS.

## Installation

## About
Information about some of the stuff I use.

### Terminal

### NeoVim

## TODO
Prioritize bugs, techdebt over features

Bugs, tech debt, etc
- merge bootstrap functionality into dfsetup
- fix deoplete-tern and tern-js vim.. UpdateRemotePlugins not working..
- make neovim config file backwards compatible
- make bash profile backwards compatible (for bashrc), also so we can source safely
  - make sure .bashrc is being copied over via dfsetup
- move setup system into it's own utility? 
- move setup github into it's own utility? actually this makes more sense as a
  package.

Features
- 100% coverage of brew list
- Have a `update_dotfiles` command in `PATH` that will execute the install
  script and pull from repo and update the dotfiles.
- Install and customize languages, e.g. Python, Go, ...
- Add a curl hook that will execute bootstrap
- Ctrl Key remap
- tab colors (need newer bash)
- bash profile document (alias)
- create dotfiles if they don't exist on linking
- create verbose command tree, e.g. `dfsetup create [pkg]`, `dfsetup reinstall [pkg]`
- restore backups... :O
- NERD font install auto
- way to install all vim plugins on load or during install script ?
- list all available packages
