init: ## Symlink files
	ln -vsf ${PWD}/zsh/.zshrc ${HOME}/.zshrc
	ln -vsf ${PWD}/zsh/.aliases ${HOME}/.aliases
	ln -vsf ${PWD}/zsh/.functions ${HOME}/.functions
	ln -vsf ${PWD}/zsh/.exports ${HOME}/.exports
	ln -vsf ${PWD}/zsh/.inputrc ${HOME}/.inputrc
	ln -vsf ${PWD}/vim/.vimrc ${HOME}/.vimrc
	ln -vsf ${PWD}/.tmux.conf ${HOME}/.tmux.conf
	# Git
	ln -vsf ${PWD}/git/.gitconfig ${HOME}/.gitconfig
	ln -vsf ${PWD}/git/.gitignore_global ${HOME}/.gitignore_global


install: clitools docker mysql nginx node php python ruby code zsh init

android: ## Install Android sdk and tools
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
		ubuntu-restricted-extras \
		filemanager-actions \
		flameshot \
		gnome-tweak-tool \
		nautilus-dropbox \
		vlc \
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
	sudo apt-get install -y \
	   at \
	   aptitude \
	   autojump \
	   build-essential \
	   cmake \
	   csvtool \
	   curl \
	   dos2unix \
	   fonts-powerline \
	   silversearcher-ag \
	   imagemagick \
	   jq \
	   libtool\
	   inotify-tools \
	   nghttp2-client \
	   neovim \
	   neofetch \
	   net-tools \
	   pkg-config \
	   pandoc \
	   pdftk \
	   pwgen \
	   preload \
	   powerline \
	   openssh-server \
	   openssh-client \
	   software-properties-common \
	   sqlite3 libsqlite3-dev \
	   texlive \
	   tmux \
	   tree \
	   vim \
	   wine \
	   xbindkeys \
	   xclip


docker: ## Install Docker

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
	sudo apt-get install maven -y
	sudo snap install intellij-idea-community --classic

go: ## Install Go lang
	sudo apt-get install golang-go

	export GOPATH="$HOME/Go"
	export PATH="$PATH:/usr/local/go/bin:$GOPATH/bin"


ghcli: ## GitHub CLI
	sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-key C99B11DEB97541F0
	sudo apt-add-repository https://cli.github.com/packages
	sudo apt update
	sudo apt install gh

rust:
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

php: ## Install PHP7.4/Symfony, Apache
	sudo apt-get install apache2 -y

	# PHP7 Install
	sudo add-apt-repository ppa:ondrej/php -y
	sudo apt-get update -y
	sudo apt-get install -y php7.4

	# Extension
	sudo apt-get install -y \
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
	wget -O home/phpunit https://phar.phpunit.de/phpunit-8.phar
	chmod +x phpunit

	# PsySH
	wget https://psysh.org/psysh
	chmod +x psysh

	# Composer install
	curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer -y

	# XDEBUG
	sudo apt-get install php-xdebug -y

	# Symfony
	wget https://get.symfony.com/cli/installer -O - | bash


python3: ## Install Python,Poetry & Dependencies
	sudo apt-get install -y \
		curl \
		python3-pip \
		python3-venv \
		pylint \
		thefuck 

	# https://powerline.readthedocs.io/en/latest/installation.html#generic-requirements
	pip3 install \
		powerline-status \
		virtualenv \
		--upgrade setuptools

	# Poetry dependency managment
	curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python3

	export PATH="${HOME}/.poetry/bin:${PATH}"


opencv: ## Build OpenCV from source
	sudo apt-get update && sudo apt-get upgrade

	sudo apt-get install \
		build-essential \
		cmake \
		git \
		libgtk2.0-dev \ 
		pkg-config \
		libavcodec-dev l \
		libjpeg-dev \
		libpng-dev \
		libtiff5-dev \
		libjasper-dev \
		libdc1394-22-dev \
		libeigen3-dev li

	# Download OpenCV source
	cd opt/
	git clone https://github.com/Itseez/opencv.git
	git clone https://github.com/Itseez/opencv_contrib.git

	# Build & Install OpenCV
	cd opencv 
	mkdir release
	cd release

	cmake \ 
		-D BUILD_TIFF=ON \
		-D WITH_CUDA=OFF \
		-D ENABLE_AVX=OFF \
		-D WITH_OPENGL=OFF \
		-D WITH_OPENCL=OFF \
		-D WITH_IPP=OFF \
		-D WITH_TBB=ON \
		-D BUILD_TBB=ON \
		-D WITH_EIGEN=OFF \
		-D WITH_V4L=OFF \
		-D WITH_VTK=OFF \
		-D BUILD_TESTS=OFF \
		-D BUILD_PERF_TESTS=OFF \
		-D OPENCV_GENERATE_PKGCONFIG=ON \
		-D CMAKE_BUILD_TYPE=RELEASE \
		-D CMAKE_INSTALL_PREFIX=/usr/local \
		-D OPENCV_EXTRA_MODULES_PATH=/opt/opencv_contrib/modules /opt/opencv/

	 make -j4
	 make install
	 ldconfig

	 # Set OpenCV file path
	 sudo cp /usr/local/lib/pkgconfig/opencv4.pc  /usr/lib/x86_64-linux-gnu/pkgconfig/opencv.pc


code: ## Install VS Code editor
	sudo snap install code --classic
	code --install-extension shan.code-settings-sync

nginx: ## Install nginx
	sudo add-apt-repository ppa:nginx/stable -y
	sudo apt-get install nginx

node: ## Install NodeJS & packages
	curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
	sudo apt-get install -y nodejs
	sudo npm install npm@latest -g

	# Yarn
	curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
	echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
	sudo apt update && sudo apt install yarn

	# node version manager
	curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash

	# Node packages
	npm_scripts=(
		"-g trash-cli"
		"-g electron"
		"-g gulp-cli"
		"-g browser-sync"
		"-g express"
		"-g eslint"
		"-g uncss"
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

ohmyzsh: ## Install zsh,oh-my-zsh & plugins
	sudo apt-get install -y zsh
	sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
	sudo chsh -s $(which zsh)
	
	# Install plugins
	zsh_plugins=(
		https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
		https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
		https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-completions
		https://github.com/lukechilds/zsh-nvm ~/.oh-my-zsh/custom/plugins/zsh-nvm
		https://github.com/bhilburn/powerlevel9k.git ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/themes/powerlevel9k
		https://github.com/MichaelAquilina/zsh-you-should-use.git $ZSH_CUSTOM/plugins/you-should-use
		# https://github.com/MichaelAquilina/zsh-autoswitch-virtualenv.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/autoswitch_virtualenv
		# https://github.com/Tarrasch/zsh-autoenv ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-autoenv
	)

	for plug in "${zsh_plugins[@]}"; do
		git clone ${plug}
	done

test: # Test Makefile with Docker
	docker build -t dotfiles .
	docker run -it --name dotfiles -d dotfiles /bin/bash; \
	docker exec -it dotfiles sh -c "cd dotfiles; make python3"
	docker rm -f dotfiles

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
	| sort \
	| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'


.DEFAULT_GOAL := help
