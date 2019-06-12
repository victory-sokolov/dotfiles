
#Package managment
alias update="sudo apt-get update && sudo apt-get upgrade"
alias install="sudo apt-get install"
alias remove="sudo apt-get remove"

# Print each PATH entry on a separate line
alias path="echo -e ${PATH//:/\\n}"

# Directory traversal
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias ~="cd ~"
alias -- -="cd -"
alias go="cd "$@" && ls"

alias cls="clear"
alias grep="grep --color=auto "

alias q="exit"

# Empty trash.
alias empty-trash="rm -rf ~/.local/share/Trash/files/*"

# copy file interactive
alias cp="cp -i"

# move file interactive
alias mv="mv -i"

# remove file interactive
alias rm='rm -i -v'

alias time="date +%T"
alias date="date +%D"

# untar
alias untar="tar xvf"

alias db="cd ~/Dropbox"
alias dev="cd /home/viktor/Dropbox/Code/Code Files/"

# vhosts
alias hosts="sudo vim /etc/hosts"

# check for updates
alias update="sudo apt-get update && sudo apt-get upgrade && sudo apt autoremove -y"
alias install="sudo apt-get install"

# quick edit
alias zshrc="vim ~/.zshrc"
alias bashrc="vim ~/.bashrc"
alias vimrc="vim ~/.vimrc"

# quick reload
alias reload="source ~/.zprofile"

#Youtube dll
alias ytmp3="youtube-dl --extract-audio --audio-format mp3"

# vim
alias vi="vim"

#Start XAMPP Server
alias xmp="sudo /opt/lampp/lampp start && firefox http://localhost"

#Stop xampp
alias xmp-stop="sudo /opt/lampp/lampp stop"

#Alias for build in php server
alias php-server="php -S localhost:8000 & xdg-open http://localhost:8000"

#Shortcut for editing zsh file
alias zshedit="sudo nano .zshrc"

# Get crypto prices
alias crypto="curl rate.sx"

# Network
alias my-ip="curl https://ipinfo.io/ip"

# linux version
alias release="lsb_release -a"

# Clipboard
alias pbcopy='xclip -selection clipboard'
alias pbpaste='xclip -selection clipboard -o'