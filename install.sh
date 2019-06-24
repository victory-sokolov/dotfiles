#!/bin/bash

tools=(
	ubuntu-restricted-extras
	snapd
	nautilus-dropbox
	vlc browser-plugin-vlc
	slack
	chromium-browser
	gnome-tweak-tool
	dos2unix # converts the line endings from DOS/Windows style to Unix style
	tree
	youtube-dl
	vim
	curl
	tmux
	wine
	npm
	texlive # Latex
	gedit-plugins
	postman
	xclip # clipboard manipulation
	csvtool
	zsh
	build-essential # C, C++ compiler, tools
	zeal # offline documentation
	fonts-powerline
	make
	ruby-full
	nginx
	jq # json processor
	screenfetch # terminal info about system
	flameshot
	postgresql postgresql-contrib
	sqlite3 libsqlite3-dev
	grub-customizer
	code
	nginx
	docker-ce
	albert
	aptitude
	libtool
)

snap_tools=(
	spotify
	vlc
	postman
)

zsh_plugins=(
	https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
	https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
	https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-completions
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

	# Install Docker
	sudo add-apt-repository \
		"deb [arch=amd64] https://download.docker.com/linux/ubuntu \
    (lsb_release -cs) stable"

	# install flux
	# sudo add-apt-repository ppa:nathan-renniewaldock/flux -y
	# sudo apt install fluxgui

	# install albert
	sudo sh -c "echo 'deb http://download.opensuse.org/repositories/home:/manuelschneid3r/xUbuntu_19.04/ /' > /etc/apt/sources.list.d/home:manuelschneid3r.list"

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

	# NGinx server
	sudo add-apt-repository ppa:nginx/stable -y

	# Stacer system monitoring
	wget https://github.com/oguzhaninan/Stacer/releases/download/v1.1.0/stacer_1.1.0_amd64.deb -O stacer.deb
	sudo dpkg --install stacer.deb
	rm stacer.deb

	# Download color schemes
	#git clone https://github.com/mbadolato/iTerm2-Color-Schemes && unzip nerd-fonts.zip

}

# R statistic
# sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
# sudo add-apt-repository 'deb [arch=amd64,i386] https://cran.rstudio.com/bin/linux/ubuntu xenial/'
# sudo apt install r-base -y

ruby() {
	gems=(
		colorls # colorised with folder output of ls command
	)

	for gems in {gem[@]}; do
		sudo gem install -y
	done

	# Install watchman
	# https://facebook.github.io/watchman/docs/install.html
	git clone https://github.com/facebook/watchman.git
	cd ~/watchman
	git checkout v4.9.0 # the latest stable release
	sudo ./autogen.sh
	./configure
	make
	sudo make install

}

php() {

	info 'Installing PHP Tools...'

	# PHP7 CLI Install
	sudo apt install php7.2-cli -y

	# Composer install
	curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer -y

	# XAMPP
	wget https://www.apachefriends.org/xampp-files/5.6.20/xampp-linux-x64-5.6.20-0-installer.run
	chmod +x xampp-linux-x64-5.6.20-0-installer.run
	sudo ./xampp-linux-x64-5.6.20-0-installer.run -y

	# PHP Extensions
	sudo apt install php-zip -y

	# Laravel
	composer global require laravel/installer

	# XDEBUG
	sudo apt-get install php-xdebug -y

	# WordPress CLI
	curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
	chmod +x wp-cli.phar
	sudo mv wp-cli.phar /usr/local/bin/wp -yes

	# Download WordPress
	# curl -O https://wordpress.org/latest.tar.gz && tar xzvf latest.tar.gz

}

java() {

	info 'Installing JAVA Tools...'

	# JDK8
	sudo add-apt-repository ppa:webupd8team/java -y
	sudo apt install oracle-java8-installer -y
	sudo update-alternatives --config java -y
	# Setting java PATH - https://www.digitalocean.com/community/tutorials/how-to-install-java-with-apt-on-ubuntu-16-04
	# JDK 12
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
		python-pip \
		pipenv \
		pylint \
		thefuck \
		powerline-status # https://powerline.readthedocs.io/en/latest/installation.html#generic-requirements

}

# Install necessery things for Virtual Machine
vm_env() {

	# vscode
	wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
	sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"

	python

}
