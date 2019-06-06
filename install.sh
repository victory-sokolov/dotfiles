#!bin/bash

base_settings() {

    #Make hide feature available
	gsettings set org.compiz.unityshell:/org/compiz/profiles/unity/plugins/unityshell/ 	launcher-minimize-window true

	#Launcher at the bottom
	gsettings set com.canonical.Unity.Launcher launcher-position Bottom

	#Use local time same way Window does
	timedatectl set-local-rtc 1 --adjust-system-clock

	#Set icons size to 38
	dconf write /org/compiz/profiles/unity/plugins/unityshell/icon-size 38

	#Libreoffice write available from right click
	touch ./Templates/New\ Document.odt

    #Add favoirtes to taskbar
	gsettings set com.canonical.Unity.Launcher favorites
	"['application://ubiquity.desktop', 'application://org.gnome.Nautilus.desktop', 'application://firefox.desktop',
     'application://org.gnome.Software.desktop', 'application://unity-control-center.desktop', 'unity://running-apps', 'unity://expo-icon', 'unity://devices','application://gnome-terminal.desktop',
     'application://vscode_vscode.desktop',
	]"


}

base_install() {

    sudo \
	apt-get install -y \
			chromium-browser \
			firefox -y \
			ubuntu-restricted-extras \
			vlc browser-plugin-vlc \
			snapd \
			spotify \
			gnome-panel \
			slack \
			gedit-plugins \
			gnome-tweak-tool \

    # Numix icons
    sudo apt-add-repository ppa:numix/ppa -yes
    sudo apt-get install numix-icon-theme-circle -y

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
		docker-ce
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
        postman # Postman Client for API testing
        # Databases
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
		ruby

    )

	for package in ${tools[@]}
	do
	    sudo apt-get install -y $package
	done

	sudo add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable"

	sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
	git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k

}



# R statistic
# sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
# sudo add-apt-repository 'deb [arch=amd64,i386] https://cran.rstudio.com/bin/linux/ubuntu xenial/'
# sudo apt-get update
# sudo apt-get install r-base -y


php_tools() {

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

	# NGinx server
	sudo add-apt-repository ppa:nginx/stable
	sudo apt-get update
	sudo apt-get install nginx

	# XDEBUG
	sudo apt-get install php5-dev

	# WordPress CLI
	curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
	chmod +x wp-cli.phar
	sudo mv wp-cli.phar /usr/local/bin/wp -yes

	# Download WordPress
	wp core download --path=project_name

}


install_java() {

	# JDK8
	sudo add-apt-repository ppa:webupd8team/java -y
	sudo apt-get install oracle-java8-installer
	sudo update-alternatives --config java
	# Setting java PATH - https://www.digitalocean.com/community/tutorials/how-to-install-java-with-apt-get-on-ubuntu-16-04

}


install_python() {

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


}


main() {



	sudo apt-get autoremove
	sudo apt-get autoclean
	sudo apt-get clean
}