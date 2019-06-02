#!/bin/bash

npm_scripts=(
	"-g trash-cli",
	"electron --save-dev --save-exact",
	"-g gulp",
	"-g browser-sync",
	"express",
	"-g eslint",
	"-g uncss" #remove unused css
	"stylelint --save-dev"
	"python-shell"
)

for element in "${npm_scripts[@]}"
do
    sudo npm install ${element}
done

