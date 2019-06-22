#!/bin/bash

info() {
	printf '\033[32m '"$1"' %s\033[m\n'
}

base_settings() {

	version=$(lsb_release -r -s | grep -Eo '^[0-9]{2}')

	if [ "$version" -gt 18 ]; then

		gsettings set org.gnome.shell.extensions.dash-to-dock click-action 'minimize'

	else
		# Make hide feature available
		gsettings set org.compiz.unityshell:/org/compiz/profiles/unity/plugins/unityshell/ launcher-minimize-window true

		# Set icons size to 38
		dconf write /org/compiz/profiles/unity/plugins/unityshell/icon-size 38

	fi

	#Launcher at the bottom
	#gsettings set com.canonical.Unity.Launcher launcher-position Bottom

	# Use local time same way Window does
	timedatectl set-local-rtc 1 --adjust-system-clock

	# Battery percentage
	gsettings set org.gnome.desktop.interface show-battery-percentage true

	# -- Templates --

	# Libreoffice write available from right click
	touch ~/Templates/New\ Document.odt

	# New Text Document
	touch ~/Templates/Text\ Document.txt

	# Base HTML File
	wget https://www.dropbox.com/s/bqcji695g02eje1/index.html?dl=0 -O ~/Templates/index.html

	# Add favoirtes to taskbar
	# gsettings set org.gnome.shell favorite-apps
	# "['application://ubiquity.desktop', 'application://org.gnome.Nautilus.desktop',
	#    'application://org.gnome.Software.desktop', 'application://unity-control-center.desktop', 'unity://running-apps', 'unity://expo-icon', 'unity://devices','application://gnome-terminal.desktop',
	#    'application://vscode_vscode.desktop',
	# ]"

	# Remove software & packages
	sudo apt purge thunderbird -y

}

tools() {

	tools=(
		ubuntu-restricted-extras
		snapd
		gedit-plugins
		vlc browser-plugin-vlc
		slack
		chromium-browser
		gnome-tweak-tool
		dos2unix # converts the line endings from DOS/Windows style to Unix style
		tree # Tree folder structure
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
	)

	zsh_plugins=(
		https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
		https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
		https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-completions
	)

	# spotify
	snap install spotify -y

	# vlc
	sudo snap install vlc -y

	# Postman
	sudo snap install postman -y

	# Install Dropbox
	cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -

	# Grub customizer
	sudo add-apt-repository ppa:danielrichter2007/grub-customizer -y

	# Pulse audio control
	#sudo apt install pavucontrol paman -y

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
	sudo dpkg -i google-chrome-stable_current_amd64.deb && rm google.deb

	# NGinx server
	sudo add-apt-repository ppa:nginx/stable -y

	# Stacer system monitoring
	wget https://github.com/oguzhaninan/Stacer/releases/download/v1.1.0/stacer_1.1.0_amd64.deb -O stacer.deb
	dpkg --install stacer.deb
	rm stacer.deb

	# Download color schemes
	#git clone https://github.com/mbadolato/iTerm2-Color-Schemes && unzip nerd-fonts.zip

	info "Updating system..."

	sudo apt-get update -y

	info "Installing various software..."

	for package in "${tools[@]}"; do
		sudo apt install ${package} -y
	done

	info "Installing OhMyZsh and Plugins..."
	sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" -y
	git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k
	# set zsh as default shell
	sudo chsh -s $(which zsh)

	for plug in "${zsh_plugins[@]}"; do
		git clone ${plug}
	done

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
	git clone https://github.com/facebook/watchman.git && cd watchman
	git checkout v4.9.0 # the latest stable release
	./autogen.sh
	./configure
	make
	sudo make install

}

php() {

	info 'Installing PHP Tools...'

	# PHP7 CLI Install
	sudo apt install php7.0-cli -y

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

main() {

	# dotfiles directory
	dir=~/dotfiles

	# files to symlink
	files="vim/.vimrc zsh/.zshrc tmux.conf .fonts zsh/.inputrc zsh/.exports"

	# MENU
	PS3="Choose Instalation option: "
	menu=("Install Dotfiles" "Quit")

	NC='\033[0m'
	Purple='\033[0;35m'
	Yellow='\033[0;33m'
	Blue='\033[0;34m'

	echo -e "${Purple} Dotfiles Instalation ${NC}"
	echo "==================="

	select opt in "${menu[@]}"; do
		case $opt in
		"Install Dotfiles")
			echo -e "${Green} Installing dotfiles...${NC}"
			base_settings
			tools
			python
			php
			java
			ruby

			# symlink dotfiles
			info "Creating symlinks..."
			for file in $files; do
				ln -s $dir/$file ~/.$file
			done

			break
			;;
		"Quit")
			exit
			break
			;;

		*) echo "Invalid option $REPLY" ;;
		esac
	done

	echo -e "${Blue}Installation completed! ${NC}"

	sudo apt autoremove -y
	sudo apt autoclean
	sudo apt clean
}

main
