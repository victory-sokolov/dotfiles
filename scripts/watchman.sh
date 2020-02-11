#!/bin/sh


# https://facebook.github.io/watchman/docs/install.html
sudo apt-get install libtool -y
cd ~ && git clone https://github.com/facebook/watchman.git
cd ~/watchman
git checkout v4.9.0 # the latest stable release
sudo ./autogen.sh
./configure
make
sudo make install
