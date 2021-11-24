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
	ln -vsf ${PWD}/.sqliterc ${HOME}/.sqliterc

install: clitools docker mysql nginx node php python ruby code zsh init

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
		ffmpeg \
		fdupes \ # search dublicate files
		silversearcher-ag \
		shellcheck \
		imagemagick \
		jq \
		libtool \
		libbz2-dev \
		libssl-dev \
		inotify-tools \
		nghttp2-client \
		neovim \
		neofetch \
		net-tools \
		ncdu \ # navigatable overview of file space
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
		tree \
		traceroute \
		vim \
		xbindkeys \
		xclip

	# install bat cat replacment with syntax hightlight
	wget https://github.com/sharkdp/bat/releases/download/v0.18.2/bat-musl_0.18.2_amd64.deb
	sudo dpkg -i bat-musl_0.18.2_amd64.deb

	# Better Git diff tool
	wget https://github.com/dandavison/delta/releases/download/0.9.1/delta-0.9.1-aarch64-unknown-linux-gnu.tar.gz
	sudo tar -tvf delta-0.9.1-aarch64-unknown-linux-gnu.tar.gz

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
	sudo curl -L "https://github.com/docker/compose/releases/download/1.25.3/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
	sudo chmod +x /usr/local/bin/docker-compose

	# Docker Machine
	base=https://github.com/docker/machine/releases/download/v0.16.0
	curl -L $base/docker-machine-$(uname -s)-$(uname -m) >/tmp/docker-machine
	sudo mv /tmp/docker-machine /usr/local/bin/docker-machine
	sudo chmod +x /usr/local/bin/docker-machine


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

postgresql: ## PosgreSQL
	sudo apt-get update && sudo apt-get upgrade -y
	sudo apt-get install postgresql postgresql-contrib
	# Add the GPG key
	wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
	sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" >> /etc/apt/sources.list.d/pgdg.list'
	sudo apt-get update -y


mongodb: ## MongoDB
	wget -qO - https://www.mongodb.org/static/pgp/server-5.0.asc | sudo apt-key add -
	echo "deb https://repo.mongodb.org/apt/ubuntu $(lsb_release -sc)/mongodb-org/5.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-5.0.list

	sudo apt update -y
	sudo apt install -y mongodb-org
	sudo systemctl enable --now mongod


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

haskell: ## Install Haskell
  sudo apt-get install haskell-platform -y

ruby: ## Install ruby and gems
	sudo apt-get install ruby-full -y

	gems=(
		colorls
	)

	for gems in {gem[@]}; do
		sudo gem install ${gem} -y
	done

java: ## Java JDK8
	sudo apt-get update && apt-get install openjdk-8-jdk -y
	sudo apt-get install maven -y


dotnet ## C#, Net core
	sudo apt-get install -y \
		dotnet-sdk-5.0 \
		dotnet-runtime-5.0


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

php: ## PHP7.4/Symfony, Apache
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
		php7.4-bcmath \
		php7.4-xml \
		php7.4-mbstring \
		php7.4-intl \
		php7.4-odbc \

	# PHP Unit testing
	wget -O home/phpunit https://phar.phpunit.de/phpunit-8.phar
	chmod +x phpunit

	# PsySH
	wget https://psysh.org/psysh
	chmod +x psysh

	# Composer install
	curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer -y

	# XDEBUG
	sudo apt-get install php7.4-xdebug -y

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
		icecream \
		httpie \
		faker \
    --upgrade setuptools

	python3 -m pip install --user pipx pylint black pipenv bandit mypy flake8

	# Poetry dependency managment
	curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python3
	echo 'export PATH="${HOME}/.poetry/bin:${PATH}"' >> ~/.exports

	# Python version manager
	git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.8.0

	echo '. ${HOME}/.asdf/asdf.sh' >> ~/.zshrc
	echo '. ${HOME}/.asdf/completions/asdf.bash' >> ~/.zshrc

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


code: ## VS Code
	sudo snap install code --classic
	code --install-extension shan.code-settings-sync

nginx: ## Nginx
	sudo add-apt-repository ppa:nginx/stable -y
	sudo apt-get install nginx -y

node: ## NodeJS & packages
	curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
	sudo apt-get install -y nodejs

	# NPM
	npm install npm@latest -g
	mkdir ~/.npm-packages
	npm config set prefix ~/.npm-packages

  sudo chown -R $USER ~/.npm-packages
  sudo chown -R $USER /usr/local/lib/node_modules

	# symlink .npmrc
	ln -vsf ${PWD}/.npmrc ${HOME}/.npmrc

	# Yarn
	curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
	echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
	sudo apt update && apt-get install yarn

	# node version manager
	curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash

	# Node packages
	npm_scripts=(
		"trash-cli"
		"electron"
		"eslint"
		"uncss"
		"vtop"
		"localtunnel"
		"typescript"
		"ts-node"
		"webpack"
		"-pm2"
		"nodemon"
		"node-inspector"
		"terminalizer"
		"depcheck"
		"faker-cli"
		"npm-check-updates"
	)

	for element in "${npm_scripts[@]}"
	do
		npm install -g ${element}
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
	docker exec -it dotfiles sh -c "cd dotfiles; make python3"
	docker rm -f dotfiles

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
	| sort \
	| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'


.DEFAULT_GOAL := help
