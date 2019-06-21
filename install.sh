#!bin/bash

info() {
	printf '\033[32m '"$1"' %s\033[m\n'
}

base_settings() {

	version=$(lsb_release -r -s | grep -Eo '^[0-9]{2}')

	if [ "$version" -gt 18 ]; then

		gsettings set org.gnome.shell.extensions.dash-to-dock click-action 'minimize'

	else
		# Make hide feature available
		gsettings set org.compiz.unityshell:/org/compiz/profiles/unity/plugins/unityshell/ 	launcher-minimize-window true

		# Set icons size to 38
		dconf write /org/compiz/profiles/unity/plugins/unityshell/icon-size 38

	fi

	#Launcher at the bottom
	#gsettings set com.canonical.Unity.Launcher launcher-position Bottom

	# Use local time same way Window does
	timedatectl set-local-rtc 1 --adjust-system-clock

	# Battery percentage
	gsettings set org.gnome.desktop.interface show-battery-percentage true

	#Libreoffice write available from right click
	touch ./Templates/New\ Document.odt

  # Add favoirtes to taskbar
	# gsettings set org.gnome.shell favorite-apps
	# "['application://ubiquity.desktop', 'application://org.gnome.Nautilus.desktop',
  #    'application://org.gnome.Software.desktop', 'application://unity-control-center.desktop', 'unity://running-apps', 'unity://expo-icon', 'unity://devices','application://gnome-terminal.desktop',
  #    'application://vscode_vscode.desktop',
	# ]"

	# Remove software & packages
	sudo apt-get purge thunderbird -y

}

base_install() {

	info 'Basic packages installation...'

	sudo \
		apt-get install -y \
		chromium-browser \
		ubuntu-restricted-extras \
		vlc browser-plugin-vlc \
		snapd \
		spotify \
		gnome-panel \
		slack \
		gedit-plugins \
		gnome-tweak-tool \

  # Install Dropbox
  cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -

	# Grub customizer
	sudo add-apt-repository ppa:danielrichter2007/grub-customizer -y
	sudo apt-get install grub-customizer -y

  # Pulse audio control
	#sudo apt-get update && sudo apt-get install pavucontrol paman -y

  # Firefox Portable 49
	wget -O Firefox49Portable http://ftp.mozilla.org/pub/firefox/releases/49.0/linux-x86_64/en-US/firefox-49.0.tar.bz2 && tar xvjf Firefox49Portable && rm Firefox49Portable && mv firefox Firefox49

	# Google Drive
	# sudo add-apt-repository ppa:alessandro-strada/ppa
	# sudo apt-get update -y
	# sudo apt-get install google-drive-ocamlfuse -y

}

tools() {

  tools=(
		dos2unix  # converts the line endings from DOS/Windows style to Unix style
		tree      # Tree folder structure
		youtube-dl
		vim
		curl
		tmux
		wine
		npm
		texlive # Latex
		gedit-plugins
		postman
		postgres
		mongo
		elasticsearch
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
  )

	info 'installing cli tools...'

	for package in {tools[@]}
	do
	  sudo apt-get install -y package
	done

	# Install vscode
	wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
	sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
	sudo apt install code -y

	# Install Docker
	sudo add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
    (lsb_release -cs) stable"
	sudo apt-get install docker-ce

	# install flux
	sudo add-apt-repository ppa:nathan-renniewaldock/flux
	sudo apt-get update
	sudo apt-get install fluxgui

	# install albert
	sudo sh -c "echo 'deb http://download.opensuse.org/repositories/home:/manuelschneid3r/xUbuntu_19.04/ /' > /etc/apt/sources.list.d/home:manuelschneid3r.list"
	sudo apt-get update
	sudo apt-get install albert -y

	sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" -y
	git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k
	# set zsh as default shell
	sudo chsh -s $(which zsh)

	# install nerd fonts
	cd ~/.fonts
	git clone https://github.com/ryanoasis/nerd-fonts
	cd nerd-fonts
	./install.sh
	fc-cache -fv


	# Install Chrome
	wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O google.deb
	sudo dpkg -i google-chrome-stable_current_amd64.deb && rm google.deb

	# Install watchman
	# https://facebook.github.io/watchman/docs/install.html
	git clone https://github.com/facebook/watchman.git
	cd watchman
	sudo git checkout v4.9.0  # the latest stable release
	sudo s./autogen.sh
	./configure
	make
	sudo make install

	# NGinx server
	sudo add-apt-repository ppa:nginx/stable
	sudo apt-get update
	sudo apt-get install nginx

	# Download color schemes
	#git clone https://github.com/mbadolato/iTerm2-Color-Schemes && unzip nerd-fonts.zip

}


# R statistic
# sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
# sudo add-apt-repository 'deb [arch=amd64,i386] https://cran.rstudio.com/bin/linux/ubuntu xenial/'
# sudo apt-get update
# sudo apt-get install r-base -y


ruby_gems(){
	gems = (
		colorls # colorised with folder output of ls command
	)

	for gems in {gem[@]}
	do
		sudo gem install -y gem
	done

}

php() {

	info 'Installing PHP Tools...'

	# PHP7 CLI Install
	sudo apt-get install php7.0-cli -y

	# Composer install
	curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer -y

	# XAMPP
	wget https://www.apachefriends.org/xampp-files/5.6.20/xampp-linux-x64-5.6.20-0-installer.run
	chmod +x xampp-linux-x64-5.6.20-0-installer.run
	sudo ./xampp-linux-x64-5.6.20-0-installer.run

	# PHP Extensions
	sudo apt-get install php-zip -yes

	# Laravel
	composer global require laravel/installer

	# XDEBUG
	sudo apt-get install php5-dev

	# WordPress CLI
	curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
	chmod +x wp-cli.phar
	sudo mv wp-cli.phar /usr/local/bin/wp -yes

	# Download WordPress
	wp core download --path=project_name

}


java() {

	info 'Installing JAVA Tools...'

	# JDK8
	sudo add-apt-repository ppa:webupd8team/java -y
	sudo apt-get install oracle-java8-installer
	sudo update-alternatives --config java
	# Setting java PATH - https://www.digitalocean.com/community/tutorials/how-to-install-java-with-apt-get-on-ubuntu-16-04
	# JDK 12
}


python() {

		info 'Installing Python Tools...'

    # Install Geckodriver for Selenium
    wget -O geckodriver get https://github.com/mozilla/geckodriver/releases/download/v0.23.0/geckodriver-v0.23.0-linux64.tar.gz
    # Extract
    tar -xvzf geckodriver*
    # Make it executable
    chmod +x geckodriver
    sudo mv geckodriver /usr/local/bin/


	sudo apt-get install -y \
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

	python()

}

main() {

	# dotfiles directory
	dir=~/dotfiles

	# files to symlink
	files="vim/.vimrc zsh/.zshrc"

	# symlink dotfiles
	for file in $files; do
		echo "Creating symlinks..."
		ln -s $dir/$file ~/.$file
	done

	sudo apt-get autoremove
	sudo apt-get autoclean
	sudo apt-get clean
}