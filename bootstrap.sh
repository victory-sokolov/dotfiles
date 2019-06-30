#!/bin/bash

# start time of the installation
start=`date +%s`

source ./install.sh

info() {
  printf '\033[32m '"$1"' %s\033[m\n'
}

settings() {

  version=$(lsb_release -r -s | grep -Eo '^[0-9]{2}')

  # Make hide feature available
  if [ "$version" -gt 18 ]; then
	gsettings set org.compiz.unityshell:/org/compiz/profiles/unity/plugins/unityshell/launcher-minimize-window true    
  else
    gsettings set org.gnome.shell.extensions.dash-to-dock click-action 'minimize'
    # Set icons size to 38
    dconf write /org/compiz/profiles/unity/plugins/unityshell/icon-size 38
  fi

  #Launcher at the bottom
  #gsettings set com.canonical.Unity.Launcher launcher-position Bottom

  # ALT + SHIFT change language
  gsettings set org.gnome.desktop.input-sources xkb-options "['grp:alt_shift_toggle']"

  # set transparency for dock
  gsettings set org.gnome.shell.extensions.dash-to-dock transparency-mode 'FIXED'
  gsettings set org.gnome.shell.extensions.dash-to-dock background-opacity 0.7

  # Use local time
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

  # Remove software & packages
  sudo apt purge thunderbird -y
  sudo apt purge gnome-screenshot -y

  # remove games
  sudo apt-get purge aisleriot gnome-sudoku gnome-mines gnome-mahjongg ace-of-penguins gnomine gbrainy cheese

}

software_installation() {

  info "Updating system..."
  sudo apt-get update && sudo apt-get upgrade -y
  sudo apt --fix-broken install -y

  info "Installing software..."
  installation

  for package in "${tools[@]}"; do
    sudo apt install ${package} -y
  done

  for package in "${snap_tools[@]}"; do
    sudo snap install ${package}
  done

  info "Installing OhMyZsh and Plugins..."
  sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" -y
  git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k
  # set zsh as default shell
  sudo chsh -s $(which zsh)


  for plug in "${zsh_plugins[@]}"; do
    git clone ${plug}
  done

  # sync extension for vs code
  code --install-extension shan.code-settings-sync

}

# Uninstalls packages installed via apt get and snap
uninstall() {

  echo -e "${Red}Removing apt packages${NC}"

  for i in "${tools[@]}"; do
    sudo apt purge ${i} -y
  done

  echo -e "${Red}Removing snap packages${NC}"

  for i in "${snap_tools[@]}"; do
    sudo snap remove ${i}
  done

  sudo apt autoremove -y
  sudo apt autoclean
  sudo apt clean
}

main() {

  # dotfiles directory
  dir=$HOME/dotfiles/

  # files to symlink
  files="vim/.vimrc zsh/.zshrc tmux.conf .fonts zsh/.inputrc zsh/.exports git/.gitconfig"

  # MENU
  PS3="Choose Instalation option: "
  menu=("Install Dotfiles" "Remove Dotfiles" "Quit")

  NC='\033[0m'
  Purple='\033[0;35m'
  Yellow='\033[0;33m'
  Blue='\033[0;34m'
  Red='\033[0;31m'

  echo -e "${Purple} Dotfiles Instalation ${NC}"
  echo "==================="

  select opt in "${menu[@]}"; do
    case $opt in
    "Install Dotfiles")
      echo -e "${Blue} Installing dotfiles...${NC}"
      settings
      software_installation
      python
      java
      ruby
      php
      $dir/node/package.zsh


      # symlink dotfiles
      info "Creating symlinks..."
      for file in $files; do
        ln -sf $dir/$file $HOME
      done

      echo -e "${Blue}Installation completed! ${NC}"

      break
      ;;
    "Remove Dotfiles")
      read -p "This will remove all installed packages. Are you sure? y/n : " yn
      case $yn in
      [Yy]*)
        uninstall
        break
        ;;
      [Nn]*) exit ;;
      *) echo "Please answer yes or no. Exiting" exit ;;
      esac
      break
      ;;
    "Quit")
      exit
      break
      ;;
    *) echo "Invalid option $REPLY" ;;
    esac
  done
  
  # end installation execution time
  end=`date +%s`
  runtime=$((end-start))
  info "Installation Run Time: $runtime"


}

main
