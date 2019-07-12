#!/bin/bash

# Node install
sudo npm cache clean -f
sudo npm install -g n
sudo n stable
sudo n latest

npm_scripts=(
	"-g trash-cli",
	"electron --save-dev --save-exact",
	"-g gulp-cli",
	"-g browser-sync",
	"express",
	"-g eslint",
	"-g uncss" #remove unused css
	"stylelint --save-dev"
	"python-shell"
	"-g vtop"
	"-g localtunnel"
)

cd $HOME

for element in "${npm_scripts[@]}"
do
    sudo npm install ${element}
done

