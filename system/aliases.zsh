
# Directory traversal
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias ~="cd ~"
alias -- -="cd -"
alias go="cd "$@" && ls"

alias cls="clear"
alias grep='grep --color=auto '

# copy file interactive
alias cp='cp -i'

# move file interactive
alias mv='mv -i'

# untar
alias untar='tar xvf'

alias db='cd ~/Dropbox'
alias dev='cd /home/viktor/Dropbox/Code/Code Files/'

# vhosts
alias hosts='sudo vim /etc/hosts'

# check for updates
alias update="sudo apt-get update && sudo apt-get upgrade && sudo apt autoremove -y"
alias install="sudo apt-get install"

# quick edit
alias zshrc="vim ~/.zshrc"
alias bashrc="vim ~/.bashrc"
alias vimrc="vim ~/.vimrc"

# quick reload
alias reload_zsh='source ~/.zprofile'

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
