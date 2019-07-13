version=$(lsb_release -r -s | grep -Eo '^[0-9]{2}')

# Make hide feature available
if [ "$version" -gt 18 ]; then
  gsettings set org.compiz.unityshell:/org/compiz/profiles/unity/plugins/unityshell/launcher-minimize-window true
else
    gsettings set org.gnome.shell.extensions.dash-to-dock click-action 'minimize'
    # Set icons size to 38
    dconf write /org/compiz/profiles/unity/plugins/unityshell/icon-size 38
fi

# ALT + SHIFT change language
gsettings set org.gnome.desktop.input-sources xkb-options "['grp:alt_shift_toggle']"

# set transparency for dock
gsettings set org.gnome.shell.extensions.dash-to-dock transparency-mode 'FIXED'
gsettings set org.gnome.shell.extensions.dash-to-dock background-opacity 0.7

# Use local time
timedatectl set-local-rtc 1 --adjust-system-clock

# Battery percentage
gsettings set org.gnome.desktop.interface show-battery-percentage true