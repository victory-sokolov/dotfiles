
# My DotFiles for Linux

![](https://i.imgur.com/yuX27Pt.png)

This is my personalized Linux/WSL2 dotfiles.
Configurations include predefined aliases, functions, vim settings, scripts for the installation of various CLI utilities and software.

Currently using **Windows 11 + WSL2**

### Contents

* [Installation](#installation)
* [Aliases and functions](#aliases-and-functions)
* [ZSH](#zsh-settings)
* [VIM](#vim)
* [VSCode](#vs-code)
## Installation

1. Clone repo `git clone https://github.com/victory-sokolov/dotfiles`
2. Installation of environment is defined in Makefile, execute `make` to see available commands. Check `make install` command which will set-up base development environment and soft link `dotfiles` like `aliases`, `function` and etc.

![](https://i.imgur.com/pwsL7mm.png)

## Aliases and functions

You can list all available custom aliases and functions via the following commands:
* aliases - `lalias`
* functions - `fhelp`

## ZSH

List of ZSH plugins I use

* [git](https://github.com/robbyrussell/oh-my-zsh/tree/master/plugins/git) - Git aliases
* [extract](https://github.com/thetic/extract) - extracts all types of archives
* [sudo](https://github.com/hcgraf/zsh-sudo) - press ESC twice to prepend command with sudo
* [npm](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/npm) - npm aliases
* [react-native](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/react-native) ReactNative aliases
* [web-search](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/web-search)  - aliases for searching with Google, Wiki, Bing, YouTube
* [you-should-use](https://github.com/MichaelAquilina/zsh-you-should-use) - reminds you to use defined alises
* [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions) - suggests commands as you type
*  [zsh-completions](https://github.com/zsh-users/zsh-completions) - zsh autocomplete
*  [z](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/z) -  tracks your most visited directories and allows you to access them with few keystrokes
*  [kubectl](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/kubectl) Kubernetes aliases
*  [encode64](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/encode64) base64 encode/decoder
*  [docker](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/docker) docker autocompletion
## VIM

NeoVim + NerdTree

![](https://i.imgur.com/x6Vy2Qx.png)

### Plugins



## VS Code

I'm using the default VS code Theme as well I like [Cobalt2](https://marketplace.visualstudio.com/items?itemName=wesbos.theme-cobalt2itemName=wesbos.theme-cobalt2) theme

List of [Extensions](vscode/extensions.md) that I use
