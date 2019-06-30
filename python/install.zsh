#!/bin/zsh

#Install python packages from file

while read -r line; do
    sudo pip3 install "$line"
done < "packages.txt"


# for element in ${py_packages[@]}
# do
#     sudo pip install $element
# done

