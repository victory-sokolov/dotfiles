#!/bin/bash

# Node install
sudo npm cache clean -f
curl -sL https://deb.nodesource.com/setup_13.x | sudo -E bash -
sudo apt-get install -y nodejs
sudo npm install npm@latest -g

npm_scripts=(
	"-g trash-cli",
	"-g create-react-app",
	"electron --save-dev --save-exact",
	"-g gulp-cli",
	"-g browser-sync",
	"-g express",
	"-g eslint",
	"-g uncss" #remove unused css
	"stylelint --save-dev"
	"python-shell"
	"-g vtop"
	"-g localtunnel"
	"-g typescript"
	"-g gitbook"
	"-g webpack"
	"-g pm2"
	)

cd $HOME

for element in "${npm_scripts[@]}"
do
    sudo npm install ${element}
done

