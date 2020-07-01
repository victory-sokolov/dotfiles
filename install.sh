#!/bin/bash

tools=(
	at # schedule future tasks
	aptitude
	autojump
	build-essential # C, C++ compiler, tools
	csvtool
	curl
	dos2unix # converts the line endings from DOS/Windows style to Unix style
	filemanager-actions
	flameshot
	fonts-powerline
	silversearcher-ag
	gedit-plugins
	gnome-tweak-tool
	grub-customizer
	imagemagick
	jq # json processor
	libtool
	inotifywait
	make
	mycli
	nautilus-dropbox
	nginx
	nghttp2-client
	neovim
	neofetch
	net-tools
	pandoc
	postgresql postgresql-contrib
	pdftk # join, shuffle, select for pdf files
	pwgen # random password generator
	preload # speed up app boot time
	openssh-server
	openssh-client
	software-properties-common
	screenfetch # terminal info about system
	snapd
	sqlite3 libsqlite3-dev
	texlive # Latex
	tmux
	tree
	ubuntu-restricted-extras
	vim
	vlc browser-plugin-vlc
	wine
	xbindkeys
	xclip # clipboard manipulation
	zeal # offline documentation
	zsh
)

snap_tools=(
    vscode --classic
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
	https://github.com/MichaelAquilina/zsh-autoswitch-virtualenv.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/autoswitch_virtualenv
    https://github.com/Tarrasch/zsh-autoenv ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-autoenv
)

installation() {


	# Grub customizer
	sudo add-apt-repository ppa:danielrichter2007/grub-customizer -y

	# Google Drive
	# sudo add-apt-repository ppa:alessandro-strada/ppa
	# sudo apt install google-drive-ocamlfuse -y

	# install albert
	wget https://download.opensuse.org/repositories/home:/manuelschneid3r/xUbuntu_19.04/amd64/albert_0.16.1_amd64.deb -O albert.deb
	sudo dpkg -i albert.deb
	rm albert.deb


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


	# YouTube-DLL
	sudo wget http://yt-dl.org/downloads/latest/youtube-dl -O /usr/local/bin/youtube-dl
	sudo chmod a+rx /usr/local/bin/youtube-dl

}

function ruby() {

    sudo apt-get install ruby-full -y

	gems=(
		colorls # colorised with folder output of ls command
		cloudapp_api
	)

	for gems in {gem[@]}; do
		sudo gem install ${gem} -y
	done

}

function docker() {
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
}


function php() {

	info 'Installing PHP Tools...'

	sudo apt-get install apache2 -y
	# set php default directory
	PHP_DIR="/home/viktor/Dropbox/Code/PHP"


	# PHP7 CLI Install
	sudo add-apt-repository ppa:ondrej/php -yes
	sudo apt-get update
	sudo apt-get install -y php7.4
	# sudo apt-cache search php7*

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

function java() {

	info 'Installing JAVA Tools...'

	# OPenJDK8
	sudo apt-get update
	sudo apt-get install openjdk-8-jdk -y

	# Intellij IDEA
	sudo snap install intellij-idea-community --classic
}

function go() {
    sudo snap install --classic go

    # Packages
    go get -u github.com/odeke-em/drive/cmd/drive
}

function python() {

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
	pip3 install -y \
		powerline-status \
		--upgrade setuptools 
}
