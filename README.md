# kaybinwang's dotfiles
This repository contains the configuration for my dev environment.

These dotfiles support the following operating systems:
- Mac OS
- Alpine Linux

They can be installed directly onto the system using the installation script.
Alternatively, a docker image is provided that contains an `alpine` image with
the dotfiles set up.

## Installation
Run the install script to apply the dotfiles directly to your system. This will
determine the appropriate configuration based on your operating system.
```bash
$ git clone git@github.com:kaybinwang/dotfiles.git
$ cd dotfiles
$ ./install.sh
```

## Docker Image
You can run the pre-built docker image if you just want to access an environment
with the dotfiles already installed.
```bash
$ docker run -it --rm ghcr.io/kaybinwang/dotfiles zsh
```
