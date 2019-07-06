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
	postgresql postgresql-contrib
	ruby-full
	screenfetch # terminal info about system
	snapd
	sqlite3 libsqlite3-dev
	silversearcher-ag
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
 	todoist-thibaut
)

zsh_plugins=(
	https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
	https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
	https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-completions
	https://github.com/lukechilds/zsh-nvm ~/.oh-my-zsh/custom/plugins/zsh-nvm
)

installation() {

	# Grub customizer
	sudo add-apt-repository ppa:danielrichter2007/grub-customizer -y

	# Firefox Portable 49
	# wget -O Firefox49Portable http://ftp.mozilla.org/pub/firefox/releases/49.0/linux-x86_64/en-US/firefox-49.0.tar.bz2 && tar xvjf Firefox49Portable && rm Firefox49Portable && mv firefox Firefox49

	# Google Drive
	# sudo add-apt-repository ppa:alessandro-strada/ppa
	# sudo apt install google-drive-ocamlfuse -y

	# Install vscode
	wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
	sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"


	# install albert
	# https://software.opensuse.org/download.html?project=home:manuelschneid3r&package=albert
	wget https://download.opensuse.org/repositories/home:/manuelschneid3r/xUbuntu_19.04/amd64/albert_0.16.1_amd64.deb -O albert.deb && sudo dpkg -i albert.deb
	rm albert.deb


	# install nerd fonts
	mkdir -p ~/.fonts
	if [! -d "~/.fonts/nerd-fonts"]; then
		git clone https://github.com/ryanoasis/nerd-fonts ~/.fonts
		cd nerd-fonts
		./install.sh
		fc-cache -fv
	fi


	# Install Chrome
	wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O google.deb && sudo dpkg -i google.deb
	rm google.deb

	# Nginx server
	sudo add-apt-repository ppa:nginx/stable -y

	# Stacer system monitoring
	wget https://github.com/oguzhaninan/Stacer/releases/download/v1.1.0/stacer_1.1.0_amd64.deb -O stacer.deb && sudo dpkg --install stacer.deb
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

	# Download color schemes
	#git clone https://github.com/mbadolato/iTerm2-Color-Schemes && unzip nerd-fonts.zip

}


ruby() {
	gems=(
		colorls # colorised with folder output of ls command
	)

	for gems in {gem[@]}; do
		sudo gem install ${gem} -y
	done

}

php() {

	info 'Installing PHP Tools...'

	# PHP7 CLI Install
	sudo apt install php7.2-cli -y

	# Composer install
	curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer -y

	# XAMPP
	wget https://www.apachefriends.org/xampp-files/5.6.20/xampp-linux-x64-5.6.20-0-installer.run -O ~/xampp.run
	chmod +x ~/xampp.run
	# sudo ~/xampp.run

	# PHP Extensions
	sudo apt install php-zip -y

	# Laravel
	composer global require laravel/installer

	# XDEBUG
	sudo apt-get install php-xdebug -y

	# WordPress CLI
	curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
	chmod +x wp-cli.phar
	sudo mv wp-cli.phar /usr/local/bin/wp -yes && rm wp-cli.phar

	# Download WordPress
	# curl -O https://wordpress.org/latest.tar.gz && tar xzvf latest.tar.gz

}

java() {

	info 'Installing JAVA Tools...'

	# OpenJDK8
	sudo apt-get install openjdk-8-jdk -y
	# Setting java PATH - https://www.digitalocean.com/community/tutorials/how-to-install-java-with-apt-on-ubuntu-16-04
	# JDK 12

	# Intellij IDEA
 	sudo snap install intellij-idea-community --classic
}

python() {

	info 'Installing Python Tools...'

	# Install Geckodriver for Selenium
	wget https://github.com/mozilla/geckodriver/releases/download/v0.23.0/geckodriver-v0.23.0-linux64.tar.gz -O geckodriver
	tar -xvzf geckodriver*
	chmod +x geckodriver
	sudo mv geckodriver /usr/local/bin/

	# Chrome Driver
	wget https://chromedriver.storage.googleapis.com/75.0.3770.90/chromedriver_linux64.zip -O ~/chromedriver.zip
	unzip ~/chromedriver.zip
	sudo rm chromedriver.zip
	sudo mv chromedriver /usr/local/bin

	sudo apt install -y \
		python3-pip \
		python-virtualenv \
		python3-venv \
		pylint \
		thefuck \
		howdoi \

	# https://powerline.readthedocs.io/en/latest/installation.html#generic-requirements
	pip3 install powerline-status

}

# Install necessery things for Virtual Machine
vm_env() {

	# vscode
	wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
	sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"

	python

}
