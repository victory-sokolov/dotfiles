#!/bin/bash

tools=(
	aptitude
	build-essential # C, C++ compiler, tools
	code
	csvtool
	curl
	dos2unix # converts the line endings from DOS/Windows style to Unix style
	filemanager-actions
	flameshot
	fonts-powerline
	gedit-plugins
	gnome-tweak-tool
	grub-customizer
	imagemagick
	jq # json processor
	libtool
	make
	nautilus-dropbox
	nginx
	npm
	net-tools
	postgresql postgresql-contrib
	ruby-full
	software-properties-common
	screenfetch # terminal info about system
	snapd
	sqlite3 libsqlite3-dev
	tesseract-ocr-all
	texlive # Latex
	tmux
	tree
	ubuntu-restricted-extras
	vim
	vlc browser-plugin-vlc
	wine
	xbindkeys
	xclip # clipboard manipulation
	youtube-dl
	zeal # offline documentation
	zsh
)

snap_tools=(
	spotify
	postman
	slack --classic
)

zsh_plugins=(
	https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
	https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
	https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-completions
	https://github.com/lukechilds/zsh-nvm ~/.oh-my-zsh/custom/plugins/zsh-nvm
	https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/themes/powerlevel9k
)

installation() {


	# Grub customizer
	sudo add-apt-repository ppa:danielrichter2007/grub-customizer -y

	# Google Drive
	# sudo add-apt-repository ppa:alessandro-strada/ppa
	# sudo apt install google-drive-ocamlfuse -y

	# Install vscode
	wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
	sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"

	# sync extension for vs code
	code --install-extension shan.code-settings-sync

	# install albert
	wget https://download.opensuse.org/repositories/home:/manuelschneid3r/xUbuntu_19.04/amd64/albert_0.16.1_amd64.deb -O albert.deb
	sudo dpkg -i albert.deb
	rm albert.deb

	# install nerd fonts
	# cd ~/.fonts
	# git clone https://github.com/ryanoasis/nerd-fonts
	# cd nerd-fonts
	# ./install.sh
	# fc-cache -fv

	# Install Chrome
	wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O google.deb
	sudo dpkg -i google.deb
	rm google.deb

	# Nginx server
	sudo add-apt-repository ppa:nginx/stable -y

	# Stacer system monitoring
	wget https://github.com/oguzhaninan/Stacer/releases/download/v1.1.0/stacer_1.1.0_amd64.deb -O stacer.deb
	sudo dpkg --install stacer.deb
	rm stacer.deb

	# RescueTime
	wget https://www.rescuetime.com/installers/rescuetime_current_amd64.deb -O rescuetime.deb
	sudo dpkg --install rescuetime.deb
	rm rescuetime.deb

	# Install watchman
	# https://facebook.github.io/watchman/docs/install.html
	cd ~ && git clone https://github.com/facebook/watchman.git
	cd ~/watchman
	git checkout v4.9.0 # the latest stable release
	sudo ./autogen.sh
	./configure
	make
	sudo make install

	# Docker
	sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
	sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable" -y
	sudo apt update
	sudo apt install docker-ce -y
	# execute docker without sudo
	sudo usermod -aG docker ${USER}
	su - ${USER}
	id -nG

}

ruby() {
	gems=(
		colorls # colorised with folder output of ls command
		cloudapp_api
	)

	for gems in {gem[@]}; do
		sudo gem install ${gem} -y
	done

}

php() {

	info 'Installing PHP Tools...'

	sudo apt-get install apache2
	# set php default directory
	PHP_DIR="/home/viktor/Dropbox/Code/PHP"


	# PHP7 CLI Install
	sudo apt install -y php7.3 \
		php7.3-cli \
		libapache2-mod-php7.3 \
		libaprutil1-dbd-sqlite3 \
		php7.3-common \
		php7.3-json \
		php7.3-opcache \
		php7.3-readline \
		php-pear \
		php7.3-curl \
		php7.3-dev \
		php7.3-gd \
		php7.3-mbstring \
		php7.3-zip \
		php7.3-mysql \
		php7.3-xml


	# set default php version
	sudo update-alternatives --set php /usr/bin/php7.3

	# PHP Unit testing
	wget -O phpunit https://phar.phpunit.de/phpunit-8.phar
	chmod +x phpunit

	# Composer install
	curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer -y

	# XDEBUG
	sudo apt-get install php-xdebug -y

	# WordPress CLI
	curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
	chmod +x wp-cli.phar
	sudo mv wp-cli.phar /usr/local/bin/wp -yes && rm wp-cli.phar

	systemctl restart apache2


}

java() {

	info 'Installing JAVA Tools...'

	# OPenJDK8
	sudo apt-get update
	sudo apt-get install openjdk-8-jdk -y

	# Intellij IDEA
	sudo snap install intellij-idea-community --classic
}

python() {

	info 'Installing Python Tools...'

	# Install Geckodriver for Selenium
	wget https://github.com/mozilla/geckodriver/releases/download/v0.23.0/geckodriver-v0.23.0-linux64.tar.gz -O geckodriver
	# Extract
	tar -xvzf geckodriver*
	# Make it executable
	chmod +x geckodriver
	sudo mv geckodriver /usr/local/bin/

	sudo apt install -y \
		python3-pip \
		python-virtualenv \
		python3-venv \
		pylint \
		thefuck \
		howdoi

	# https://powerline.readthedocs.io/en/latest/installation.html#generic-requirements
	pip3 install powerline-status

}
