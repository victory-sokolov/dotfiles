#!/bin/sh

# install nerd fonts: https://github.com/ryanoasis/nerd-fonts#option-3-install-script

git clone https://github.com/ryanoasis/nerd-fonts ~/.fonts
cd nerd-fonts
./install.sh
fc-cache -fv
