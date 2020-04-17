#!/bin/bash

# Node install
sudo npm cache clean -f
curl -sL https://deb.nodesource.com/setup_13.x | sudo -E bash -
sudo apt-get install -y nodejs
sudo npm install npm@latest -g

# Install npm packages globally without sudo on macOS and Linux
mkdir "${HOME}/.npm-packages"
npm config set prefix "${HOME}/.npm-packages"


npm_scripts=(
	"-g trash-cli",
	"-g electron --save-dev --save-exact",
	"-g gulp-cli",
	"-g browser-sync",
	"-g express",
	"-g eslint",
	"-g uncss" #remove unused css
	"-g stylelint --save-dev"
	"-g python-shell"
	"-g vtop"
	"-g localtunnel"
	"-g typescript"
	"-g gitbook"
	"-g webpack"
	"-g pm2"
	"-g nodemon"
	"-g node-inspector"
	"-g terminalizer"
	)

cd $HOME

for element in "${npm_scripts[@]}"
do
    npm install ${element}
done

