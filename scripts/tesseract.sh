#!/bin/sh

# installation: https://github.com/tesseract-ocr/tesseract/wiki/Compiling-%E2%80%93-GitInstallation

sudo apt-get update -y
sudo apt-get install tesseract-ocr
sudo apt install libtesseract-dev
sudo apt-get install libpango1.0-dev
# Languages
sudo apt-get install tesseract-ocr-eng \
                    tesseract-ocr-lav \
                    tesseract-ocr-rus

sudo apt-get install imagemagick make

# Libs
sudo apt-get install libicu-dev libpango1.0-dev libcairo2-dev
cd /usr/share/tesseract-ocr
sudo git clone https://github.com/tesseract-ocr/tesseract
sudo git clone https://github.com/tesseract-ocr/langdata_lstm
cd tesseract

sudo ./autogen.sh
sudo ./configure
sudo make
sudo make install
sudo ldconfig
sudo make training
sudo make training-install
