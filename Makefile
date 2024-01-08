# shellcheck disable=SC2086
SHELL := /bin/zsh

ZSH_PLUGINS := "$(shell cat install/ohmyzshfile)"
OS := $(shell ./scripts/detect_os.sh)

.SILENT: symlinks

symlinks: ## Symlink files
	for f in \.[^.]*; do \
		FILE="$$(basename $$f)"; \
		ln -vsf "$$PWD/$$FILE" "$$HOME"; \
	done; \


init: symlinks ## Symlink files
	ln -vsf ${PWD}/zsh/.zshrc ${HOME}/.zshrc
	ln -vsf ${PWD}/zsh/.aliases ${HOME}/.aliases
	ln -vsf ${PWD}/zsh/.functions ${HOME}/.functions
	ln -vsf ${PWD}/zsh/.exports ${HOME}/.exports
	ln -vsf ${PWD}/zsh/.inputrc ${HOME}/.inputrc
	ln -vsf ${PWD}/nvm ${HOME}/.config/
	ln -vsf ${PWD}/.ignore ${HOME}/.ignore
	ln -vsf ${PWD}/.curlrc ${HOME}/.curlrc
	ln -vsf ${PWD}/.psqlrc ${HOME}/.psqlrc
	ln -vsf ${PWD}/.sqliterc ${HOME}/.sqliterc
	ln -vsf ${PWD}/.pythonrc.py ${HOME}/.pythonrc.py
	ln -vsf ${PWD}/.ripgreprc ${HOME}/.ripgreprc
	
	# Git
	ln -vsf ${PWD}/git/.gitconfig ${HOME}/.gitconfig
	ln -vsf ${PWD}/git/.gitattributes ${HOME}/.gitattributes
	ln -vsf ${PWD}/git/.gitmessage ${HOME}/.gitmessage
	ln -vsf ${PWD}/git/.gitignore_global ${HOME}/.gitignore_global

	# Formatter
	ln -vsf ${PWD}/formatting/.prettierrc ${HOME}/.prettierc
	ln -vsf ${PWD}/formatting/.eslintrc ${HOME}/.eslintrc
	ln -vsf ${PWD}/formatting/.prettierignore ${HOME}/.prettierignore
	ln -vsf ${PWD}/formatting/.eslintignore ${HOME}/.eslintignore
	ln -vsf ${PWD}/formatting/.editorconfig ${HOME}/.editorconfig
	ln -vsf ${PWD}/formatting/.stylelintrc ${HOME}/.stylelintrc

	# Node
	ln -vsf ${PWD}/.npmrc ${HOME}/.npmrc
	ln -vsf ${PWD}/.nvmrc ${HOME}/.nvmrc

install:
	set -e
	clitools docker postgresql nginx node php python vscode zsh init

macinstall: ## macOS setup
	# Check for Homebrew and install if we don't have it
	@if test ! $(which brew); then \
		/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)" \
		echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> $HOME/.zprofile \
		eval "$(/opt/homebrew/bin/brew shellenv)" \
	fi

	# Update Homebrew
	brew update

	# Install all the dependencies with bundle (See Brewfile)
	brew tap homebrew/bundle
	brew tap homebrew/cask
	brew tap homebrew/cask-drivers
	brew bundle --file macos/Brewfile

android: ## Android sdk and tools
	SDK_VERSION=29

	wget https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip -P /home/${USER}
	unzip /home/${USER}/sdk-tools-linux-4333796.zip -d /home/${USER}/Android/Sdk

	rm /home/${USER}/sdk-tools-linux-4333796.zip
	sudo apt-get install -y lib32z1 openjdk-8-jdk gradle

	yes | /home/${USER}/Android/tools/bin/sdkmanager "platform-tools" "platforms;android-29" "build-tools;29.0.3"

	export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
	export PATH=$PATH:$JAVA_HOME/bin

	export ANDROID_HOME=${HOME}/Android/Sdk
	export PATH=${PATH}:${ANDROID_HOME}/tools
	export PATH=${PATH}:${ANDROID_HOME}/emulator
	export PATH=${PATH}:${ANDROID_HOME}/tools/bin
	export PATH=${PATH}:${ANDROID_HOME}/platform-tools


linux: ## Install Ubuntu programms: flameshot, albert, spotify, dropbox, vlc, chrome, postman and update settings
	# Installation is ment only for Linux distros

	# Use local time
	timedatectl set-local-rtc 1 --adjust-system-clock
	# Show battery percentage
	gsettings set org.gnome.desktop.interface show-battery-percentage true
	# ALT + SHIFT change language
	gsettings set org.gnome.desktop.input-sources xkb-options "['grp:alt_shift_toggle']"
	# Enable minimize dock
	gsettings set org.gnome.shell.extensions.dash-to-dock click-action 'minimize'

	# enable numlock on startup
	gsettings set org.gnome.desktop.peripherals.keyboard numlock-state true

	# enable switch language with ALT + SHIFT
	gsettings set org.gnome.desktop.input-sources xkb-options "['grp:alt_shift_toggle']"

	# Remove default apps
	sudo apt purge -y thunderbird gnome-screenshot

	sudo apt-get install -y \
		ubuntu-restricted-extras \
		filemanager-actions \
		flameshot \
		gnome-tweak-tool \
		nautilus-dropbox \
		vlc \
		wine \
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
	sudo apt install stacer -y

	# Youtube DLL
	sudo wget http://yt-dl.org/downloads/latest/youtube-dl -O /usr/local/bin/youtube-dl
	sudo chmod a+rx /usr/local/bin/youtube-dl
	# Snap packages
	sudo snap install spotify postman slack --classic

	# Video recorder
	sudo add-apt-repository ppa:sylvain-pineau/kazam -y
	sudo apt-get update -y
	sudo apt install kazam -y

clitools: ## Install cli tools
	sudo apt-get install -y \
		at \
		aptitude \
		build-essential \
		cmake \
		csvtool \
		curl \
		dos2unix \
		duf \
		fonts-powerline \
		ffmpeg \
		fdupes \
		fzf \
		silversearcher-ag \
		shellcheck \
		sshpass \
		imagemagick \
		jq \
		lsd \
		libtool \
		libbz2-dev \
		libssl-dev \
		inotify-tools \
		nghttp2-client \
		neofetch \
		net-tools \
		ncdu \
		nvtop \
		pkg-config \
		pdftk \
		pwgen \
		preload \
		powerline \
		ripgrep \
		openssh-server \
		openssh-client \
		subversion \
		software-properties-common \
		sqlite3 libsqlite3-dev \
		tmux \
		trash-cli \
		tree \
		traceroute \
		xbindkeys \
		xclip \
		vim

	# install bat cat replacement with syntax highlight
	install_latest_release sharkdp/bat

	# install autoenv. Load automatically .env files
	wget --show-progress -o /dev/null -O- 'https://raw.githubusercontent.com/hyperupcall/autoenv/master/scripts/install.sh' | sh

	# Better Git diff tool
	install_latest_release dandavison/delta

	# Smarter cd command, inspired by z and autojump
	curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash

	# Fira code font
	sudo apt install fonts-firacode
	sudo fc-cache -fv

	# Tidy-HTML5 format html in CLI
	install_latest_release htacg/tidy-html5

nvim: ## Neovim + Astrovim
	cd ~
	curl -LO https://github.com/neovim/neovim/releases/download/v0.9.1/nvim-linux64.deb
	curl -LO https://github.com/neovim/neovim/releases/download/v0.9.1/nvim.appimage
	sudo apt install ./nvim-linux64.deb
	git clone https://github.com/AstroNvim/AstroNvim ~/.config/nvim
	nvim +PackerSync

docker: ## Docker
	sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
	sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable" -y
	sudo apt update
	sudo apt install docker-ce -y
	sudo usermod -aG docker ${USER}
	su - ${USER}
	id -nG
	sudo groupadd docker
	sudo gpasswd -a ${USER} docker
	sudo service docker restart

	# Docker compose
	sudo curl -L "https://github.com/docker/compose/releases/download/2.16.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
	sudo chmod +x /usr/local/bin/docker-compose

	# Docker utils
	sudo apt-get install docker-ctop

kubernetes: ## Kubernetes
	curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
	curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"

	# install kubectl
	sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl -y

mysql: ## Mysql
	sudo apt-get update -y
	sudo apt install mysql-server -y
	sudo apt install mycli -y

	# Create default mysql user
	# start mysql
	sudo /etc/init.d/mysql start
	sudo mysql -e "CREATE USER '${USER}'@'localhost' IDENTIFIED BY '123456'";
	sudo mysql -e "GRANT ALL PRIVILEGES ON * . * TO '${USER}'@'localhost'";
	sudo mysql -e "FLUSH PRIVILEGES";
	sudo /etc/init.d/mysql stop

mc: ## Midnight commander ( File manager in CLI )
	sudo apt-get install mc -y
	# Install dracula theme
	mkdir ~/dracula-theme && cd ~/dracula-theme
	git clone https://github.com/dracula/midnight-commander.git

	mkdir -p ~/.local/share/mc/skins && cd ~/.local/share/mc/skins
	ln -s ~/dracula-theme/midnight-commander/skins/dracula.ini
	ln -s ~/dracula-theme/midnight-commander/skins/dracula256.ini

	#  edit ~/.config/mc/ini and add skin=dracula to the [Midnight-Commander] section..
	# skin=dracula256

remove-mysql: ## Remove MySQL
	sudo apt-get purge mysql mysql-server mysql-common mysql-client -y
	# back up old databases
	mv /var/lib/mysql /var/lib/mysql-bak

postgresql: ## PostgreSQL
	sudo apt-get update && sudo apt-get upgrade -y
	sudo apt-get install postgresql postgresql-contrib python3-psycopg2 libpq-dev
	# Add the GPG key
	wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
	sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" >> /etc/apt/sources.list.d/pgdg.list'
	sudo apt-get update -y

	# Create base user
	sudo -u postgres bash -c "psql -c \"CREATE ROLE ${USER} LOGIN SUPERUSER PASSWORD '123456';\""

	# pgcli client
	sudo apt-get install pgcli

remove-postgres: ## Completely deletes PostgreSQL
	sudo apt-get --purge remove postgresql -y
	sudo apt-get --purge remove postgresql-client-14 -y
	sudo apt-get --purge remove postgresql-client-common -y

	# remove remaining files
	rm -rf /var/lib/postgresql/
	rm -rf /var/log/postgresql/
	rm -rf /etc/postgresql/
	userdel -f postgres

mongodb: ## MongoDB
	wget -qO - https://www.mongodb.org/static/pgp/server-5.0.asc | sudo apt-key add -
	echo "deb https://repo.mongodb.org/apt/ubuntu $(lsb_release -sc)/mongodb-org/5.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-5.0.list

	sudo apt update -y
	sudo apt install -y mongodb-org
	sudo systemctl enable --now mongod


tesseract: ## Install Tesseract binaries
	# installation: https://github.com/tesseract-ocr/tesseract/wiki/Compiling-%E2%80%93-GitInstallation
	sudo add-apt-repository ppa:alex-p/tesseract-ocr-devel -y
	sudo apt-get update -y
	sudo apt-get install tesseract-ocr
	sudo apt install libtesseract-dev
	sudo apt-get install libpango1.0-dev libcurl4-gnutls-dev
	# Languages
	sudo apt-get install tesseract-ocr-eng
	sudo apt-get install imagemagick make
	# Libs
	sudo apt-get install libicu-dev libpango1.0-dev libcairo2-dev
	cd /usr/local/
	mkdir tesseract-ocr && cd tesseract-ocr
	git clone https://github.com/tesseract-ocr/tesseract
	git clone https://github.com/tesseract-ocr/langdata_lstm
	cd tesseract

	./autogen.sh
	./configure
	make
	make install
	ldconfig
	make training
	make training-install

paddle-annotator: ## Paddle image annotation tool
	# If you have cuda9 or cuda10 installed on your machine, please run the following command to install
	# python3 -m pip install paddlepaddle-gpu -i https://mirror.baidu.com/pypi/simple

	# If you only have cpu on your machine, please run the following command to install
	python3 -m pip install paddlepaddle -i https://mirror.baidu.com/pypi/simple
	pip3 install PPOCRLabel

	# Select label mode and run
	# PPOCRLabel  # [Normal mode] for [detection + recognition] labeling
	# PPOCRLabel --kie True # [KIE mode] for [detection + recognition + keyword extraction] labeling

haskell: ## Install Haskell
	sudo apt-get install -y haskell-platform

ruby: ## Install ruby and gems
	sudo apt-get install ruby-full -y

	gems=(
		colorls
	)

	for gems in {gem[@]}; do
		gem install ${gem} -y
	done

java: ## Java JDK8
	sudo apt-get update && sudo apt-get install openjdk-8-jdk -y
	sudo apt-get install maven -y


dotnet: ## C#, Net core
	wget https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
	sudo dpkg -i packages-microsoft-prod.deb
	rm packages-microsoft-prod.deb

	sudo apt-get update && sudo apt-get install -y dotnet-sdk-6.0
	# Runtime
	sudo apt-get update && sudo apt-get install -y aspnetcore-runtime-6.0

	# Azure CLI
	sudo curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

	# Global packages
	dotnet tool install -g dotnet-ef

	# Dotnet Vscode extensions
	cat vscode/dotnet.txt | xargs code --install-extension

elastic: ## ElastiSearch
	wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
	sudo sh -c 'echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" > /etc/apt/sources.list.d/elastic-7.x.list'
	sudo apt update -y
	sudo apt install elasticsearch -y
	sudo systemctl enable elasticsearch.service --now


go: ## Go lang
	sudo apt-get install golang-go
	export GOPATH="$HOME/Go"
	export PATH="$PATH:/usr/local/go/bin:$GOPATH/bin"


ghcli: ## GitHub CLI
	sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-key C99B11DEB97541F0
	sudo apt-add-repository https://cli.github.com/packages
	sudo apt update
	sudo apt install gh

rust: ## Rust
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
	echo -e "source ${HOME}/.cargo/env" >> ${HOME}/.zshrc

	# cargo packages
	cargo install watchexec-cli

php: ## PHP8/Symfony, Apache
	sudo apt-get install apache2 -y

	# PHP8 Install
	sudo apt-get update -y
	sudo apt-get install -y php

	# Extension
	sudo apt-get install -y \
		php8.1-mysql \
		php8.1-curl \
		php8.1-json \
		php8.1-cgi \
		php8.1-xsl \
		php8.1-apcu \
		php8.1-zip \
		php8.1-gd \
		php8.1-bcmath \
		php8.1-xml \
		php8.1-mbstring \
		php8.1-intl \
		php-odbc \
		php-pgsql
		php-zip
	# PHP Unit testing
	wget -O home/phpunit https://phar.phpunit.de/phpunit-8.phar
	chmod +x phpunit

	# PsySH
	wget https://psysh.org/psysh
	chmod +x psysh

	# Composer install
	curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer -y

	# XDEBUG
	sudo apt-get install php8-xdebug -y

	# Symfony
	wget https://get.symfony.com/cli/installer -O - | bash


python3: ## Python,Poetry & Dependencies
	sudo apt-get install -y \
		curl \
		python3-pip \
		python3-venv \
		python3-dev \
		thefuck

	# https://powerline.readthedocs.io/en/latest/installation.html#generic-requirements
	pip3 install \
		powerline-status \
		virtualenv \
		bpython \
		ipdb \
		icecream \
		httpie \
		faker \
		litecli \
		python3-pydrive \
	--upgrade setuptools

	python3 -m pip install --user pipx pylint black pipenv bandit mypy flake8

	# Poetry dependency managment
	curl -sSL https://install.python-poetry.org | python3 -
	echo 'export PATH="${HOME}/.poetry/bin:${PATH}"' >> ~/.exports

	# Python version manager
	git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.8.0
	git clone https://github.com/pyenv/pyenv.git ~/.pyenv

	echo '. ${HOME}/.asdf/asdf.sh' >> ~/.zshrc
	echo '. ${HOME}/.asdf/completions/asdf.bash' >> ~/.zshrc

vscode: ## VS Code - Linux
	sudo snap install code --classic

nginx: ## Nginx
	sudo add-apt-repository ppa:nginx/stable -y
	sudo apt-get install nginx -y

node: ## NodeJS & packages
	curl -sL https://deb.nodesource.com/setup_18.x | sudo -E bash -
	sudo apt-get install -y nodejs

	# NPM
	mkdir ~/.npm-packages
	npm config set prefix ~/.npm-packages
	npm install -g npm@latest

	sudo chown -R $USER ~/.npm-packages
	sudo chown -R $USER /usr/local/lib/node_modules

	# Yarn
	curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
	echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
	sudo apt update && apt-get install yarn

	# node version manager
	curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash

	# Node packages
	npm install -g $(shell cat install/npmfile)

ohmyzsh: ## Install zsh, oh-my-zsh & plugins
	@if [ ! -z "$(which zsh --version)" ]; then \
		echo "Installing zsh"; \
		sudo apt-get install -y zsh \
		sudo chsh -s $(which zsh); \
	fi

	sh -c "$$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
	
	@for file in $(ZSH_PLUGINS); do \
		repo=$$(basename $$file); \
		dir=~/.oh-my-zsh/custom/plugins/$$repo; \
		if [ ! -d $$dir ]; then \
			git clone $$file $$dir; \
		fi; \
	done


latex: ## Install Latex & Pandoc
	sudo apt-get install -y texlive pandoc

watchman: ## Install Watchman
	cd ~
	git clone https://github.com/facebook/watchman.git -b v4.9.0 --depth 1
	cd watchman
	./autogen.sh
	./configure --enable-lenient
	make
	sudo make install

test: ## Test Makefile with Docker
	docker build -t dotfiles .
	docker run -it --name dotfiles -d dotfiles /bin/bash; \
	docker exec -it dotfiles sh -c "cd dotfiles; make install"
	docker rm -f dotfiles

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
	| sort \
	| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.DEFAULT_GOAL := help
