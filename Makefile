
allinstall: ## Installs everything
	android baseprogramms clitools docker go java mysql nginx node php postgresql python ruby tesseract vscode zsh


install: ## Install default selected apps
	baseprogramms clitools docker mysql nginx node php python ruby vscode zsh

android: ## Install Android studio, sdk and tools
	sudo snap install android-studio
	sudo apt-get install -y \
		android-tools \
		android-sdk \
		default-jdk \
		adb

gnomesettings: # Gnome settings
	# Use local time
	timedatectl set-local-rtc 1 --adjust-system-clock
	# Show battery percentage
	gsettings set org.gnome.desktop.interface show-battery-percentage true
	# ALT + SHIFT change language
    gsettings set org.gnome.desktop.input-sources xkb-options "['grp:alt_shift_toggle']"

	# Remove default apps
	sudo apt purge -y thunderbird gnome-screenshot

linuxsoftware: ## Install base programms: flameshot, albert, spotify, dropbox, vlc, chrome, postman
	sudo apt-get install -y \
		flameshot \
		gnome-tweak-tool \
		nautilus-dropbox \
		vlc browser-plugin-vlc \
		gedit-plugins

	# install chrome
	wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O google.deb
	sudo dpkg -i google.deb
	rm google.deb
	# install albert
	wget https://download.opensuse.org/repositories/home:/manuelschneid3r/xUbuntu_19.04/amd64/albert_0.16.1_amd64.deb -O albert.deb
	sudo dpkg -i albert.deb
	rm albert.deb
	# Stacer
	wget https://github.com/oguzhaninan/Stacer/releases/download/v1.1.0/stacer_1.1.0_amd64.deb -O stacer.deb
	sudo dpkg --install stacer.deb
	rm stacer.deb
	# Youtube DLL
	sudo wget http://yt-dl.org/downloads/latest/youtube-dl -O /usr/local/bin/youtube-dl
	sudo chmod a+rx /usr/local/bin/youtube-dl
	# Snap packages
	sudo snap install spotify postman slack --classic


clitools: ## Install cli tools
	at # schedule future tasks
	aptitude
	autojump
	build-essential
	csvtool
	curl
	dos2unix
	filemanager-actions
	fonts-powerline
	silversearcher-ag
	imagemagick
	jq # json processor
	libtool
	inotifywait
	make
	nghttp2-client
	neovim
	neofetch
	net-tools
	pandoc
	pdftk # join, shuffle, select for pdf files
	pwgen # random password generator
	preload # speed up app boot time
	powerline
	openssh-server
	openssh-client
	software-properties-common
	snapd
	sqlite3 libsqlite3-dev
	texlive # Latex
	tmux
	tree
	ubuntu-restricted-extras
	vim
	wine
	xbindkeys
	xclip


docker: ## Install Docker
	sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
	sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable" -y
	sudo apt update
	sudo apt install docker-ce -y
	# execute docker without sudo
	sudo usermod -aG docker ${USER}
	su - ${USER}
	id -nG
	sudo groupadd docker
	sudo gpasswd -a $USER docker
	sudo service docker restart

	# Docker compose
	sudo curl -L "https://github.com/docker/compose/releases/download/1.25.3/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
	sudo chmod +x /usr/local/bin/docker-compose

	# Docker Machine
	base=https://github.com/docker/machine/releases/download/v0.16.0
	curl -L $base/docker-machine-$(uname -s)-$(uname -m) >/tmp/docker-machine
	sudo mv /tmp/docker-machine /usr/local/bin/docker-machine
	sudo chmod +x /usr/local/bin/docker-machine


mysql: ## Install Mysql database
	sudo apt-get update -y
	sudo apt install mysql-server -y
	sudo apt install mycli

	# Create default mysql user
	sudo mysql -e "CREATE USER '${USER}'@'localhost' IDENTIFIED BY '123456'";
	sudo mysql -e "GRANT ALL PRIVILEGES ON * . * TO '${USER}'@'localhost'";
	sudo mysql -e "FLUSH PRIVILEGES";

postgresql: ## Install PosgreSQL
	sudo apt-get update && sudo apt-get upgrade -y
	sudo apt-get install postgresql postgresql-contrib
	# Add the GPG key
	wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
	sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" >> /etc/apt/sources.list.d/pgdg.list'
	sudo apt-get update


tesseract: ## Install Tesseract binaries
	# installation: https://github.com/tesseract-ocr/tesseract/wiki/Compiling-%E2%80%93-GitInstallation
	sudo apt-get update -y
	sudo apt-get install tesseract-ocr
	sudo apt install libtesseract-dev
	sudo apt-get install libpango1.0-dev
	# Languages
	sudo apt-get install tesseract-ocr-eng
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


ruby: ## Install ruby and gems
	sudo apt-get install ruby-full -y
	gems=(
		colorls
	)
	for gems in {gem[@]}; do
		sudo gem install ${gem} -y
	done

java: ## Install Java JDK8, Intellij IDEA community
	sudo apt-get update && apt-get install openjdk-8-jdk -y
	sudo snap install intellij-idea-community --classic

go: ## Install Go lang
	sudo snap install --classic go

php: ## Install PHP7.4/Symfony, Apache
	sudo apt-get install apache2 -y

	# PHP7 Install
	sudo add-apt-repository ppa:ondrej/php -yes
	sudo apt-get update
	sudo apt-get install -y php7.4

	# Extension
	sudo apt install -yes \
		php7.4-mysql \
		php7.4-curl \
		php7.4-json \
		php7.4-cgi \
		php7.4-xsl \
		php7.4-apcu \
		php7.4-zip \
		php7.4-gd \
		php7.4-bcmath

	
	# PHP Unit testing
	wget -O phpunit https://phar.phpunit.de/phpunit-8.phar
	chmod +x phpunit

	# Composer install
	curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer -y

	# XDEBUG
	sudo apt-get install php-xdebug -y

	# Symfony
	wget https://get.symfony.com/cli/installer -O - | bash


python:: ## Install Python,Poetry & Dependencies
	sudo apt-get install -y \
		python3-pip \
		python-virtualenv \
		python3-venv \
		pylint \
		thefuck

	# https://powerline.readthedocs.io/en/latest/installation.html#generic-requirements
	pip3 install -y \
		powerline-status \
		--upgrade setuptools

	# Poetry dependency managment
	curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python


vscode: ## Install VS Code editor
	sudo snap install vscode --classic
	code --install-extension shan.code-settings-sync

nginx: ## Install nginx
	sudo add-apt-repository ppa:nginx/stable -y
	sudo apt-get install nginx

node: ## Install NodeJS & packages
	curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
	sudo apt-get install -y nodejs
	npm install npm@latest -g
	# Node packages
	npm_scripts=(
		"-g trash-cli",
		"-g electron --save-dev --save-exact",
		"-g gulp-cli",
		"-g browser-sync",
		"-g express",
		"-g eslint",
		"-g uncss"
		"-g stylelint --save-dev"
		"-g python-shell"
		"-g vtop"
		"-g localtunnel"
		"-g typescript"
		"-g webpack"
		"-g pm2"
		"-g nodemon"
		"-g node-inspector"
		"-g terminalizer"
		"-g depcheck"
	)
	for element in "${npm_scripts[@]}"
	do
		npm install ${element}
	done

zsh: ## Install zsh,oh-my-zsh & plugins
	sudo apt-get install -yes zsh
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" -y
	sudo chsh -s $(which zsh)
	# Install plugins
	zsh_plugins=(
		https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
		https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
		https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-completions
		https://github.com/lukechilds/zsh-nvm ~/.oh-my-zsh/custom/plugins/zsh-nvm
		https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/themes/powerlevel9k
		https://github.com/MichaelAquilina/zsh-autoswitch-virtualenv.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/autoswitch_virtualenv
		https://github.com/Tarrasch/zsh-autoenv ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-autoenv
	)
	for plug in "${zsh_plugins[@]}"; do
		git clone ${plug}
	done


help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
	| sort \
	| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'


.DEFAULT_GOAL := help
