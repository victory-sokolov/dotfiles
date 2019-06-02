#!bin/bash


function base_settings {

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
	"['application://fslack_slack.desktop', 'application://ubiquity.desktop', 'application://org.gnome.Nautilus.desktop', 'application://firefox.desktop',
     'application://org.gnome.Software.desktop', 'application://unity-control-center.desktop', 'unity://running-apps', 'unity://expo-icon', 'unity://devices','application://gnome-terminal.desktop',
     'application://vscode_vscode.desktop',
	]"
}

function base_install {

    #Browsers
    sudo apt-get install chromium-browser -y
    sudo apt-get install firefox -y && sudo apt-get clean

    # Codecs & Fonts
    sudo apt install ubuntu-restricted-extras -y

    # VLC Player
    sudo apt-get install vlc browser-plugin-vlc -y

    # Numix icons
    yes | sudo apt-add-repository ppa:numix/ppa
    sudo apt-get update
    sudo apt-get install numix-icon-theme-circle -y

    # Install Dropbox
    cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -


    #Slack
	sudo snap install slack --classic -y
	sudo apt-get update
	sudo apt-get upgrade -y

    sudo apt install snapd -y

    #Spotify
	snap install spotify -y

    # Gnome panel
	sudo apt-get install gnome-panel -y

	#Gedit plugins
	sudo apt-get install gedit-plugins -y

	#Grub customizer
	yes | sudo add-apt-repository ppa:danielrichter2007/grub-customizer
	sudo apt-get update
	sudo apt-get install grub-customizer -y

	#Tweak Tool
	#sudo apt-get install unity-tweak-tool -y
	sudo apt install gnome-tweak-tool -y


    #Pulse audio control
	sudo apt-get update && sudo apt-get install pavucontrol paman -y

    #Firefox Portable 49
	wget -O Firefox49Portable http://ftp.mozilla.org/pub/firefox/releases/49.0/linux-x86_64/en-US/firefox-49.0.tar.bz2 && tar xvjf Firefox49Portable && rm Firefox49Portable && mv firefox Firefox49

    # Google Drive
    sudo add-apt-repository ppa:alessandro-strada/ppa
    sudo apt-get update -y
    sudo apt-get install google-drive-ocamlfuse -y

}

function cli_tools {

    CLI_TOOLS=(
        dos2unix  # converts the line endings from DOS/Windows style to Unix style
        tree      #Tree folder structure
        youtube-dl
        vim
        curl
        tmux
        wine
        npm
        git
        texlive #Latex
        gedit-plugins
        postman # The popular Postman Client for API testing
        pipenv # python pipenv
        # Databases
        postgres
        mongo
        elasticsearch

    )


}


function dev_tools {

    # C, C++ compiler, tools
	sudo apt-get install build-essential -y

	#Node JS
	sudo npm cache clean -f
	sudo npm install -g n
	sudo n stable
  	sudo n latest

    #Install ZSH
    sudo apt install zsh
    sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"


	#Python PIP manager
	sudo apt install python-pip -y
	#Update to lates version
	#pip install --upgrade pip

	#R statistic
	sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
	sudo add-apt-repository 'deb [arch=amd64,i386] https://cran.rstudio.com/bin/linux/ubuntu xenial/'
	sudo apt-get update
	sudo apt-get install r-base -y

    # Docker
    sudo add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) \
    stable"
    sudo apt-get update -y
    sudo apt-get install docker-ce -y


}


function php_tools {

	#PHP7 CLI Install
	sudo apt-get install php7.0-cli -y

	#Composer install
	curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer -y

	#XAMPP
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


function java_tools {

	#JDK
	yes | sudo add-apt-repository ppa:webupd8team/java
	sudo apt-get install oracle-java8-installer
	sudo update-alternatives --config java
	#Setting java PATH - https://www.digitalocean.com/community/tutorials/how-to-install-java-with-apt-get-on-ubuntu-16-04

}


python_tools {

    #Install Geckodriver for Selenium
    wget -O geckodriver get https://github.com/mozilla/geckodriver/releases/download/v0.23.0/geckodriver-v0.23.0-linux64.tar.gz
    # Extract
    tar -xvzf geckodriver*
    # Make it executable
    chmod +x geckodriver
    sudo mv geckodriver /usr/local/bin/

}

