FROM ubuntu:20.04

MAINTAINER Viktor Sokolov

RUN apt-get update && apt-get install git sudo zsh -y

# Creating a new sudo user
RUN useradd user
RUN usermod -aG sudo tester
RUN echo "user  ALL=(ALL:ALL) NOPASSWD: ALL" > /etc/sudoers

# Add dotfiles to container
ADD . /home/user/dotfiles
RUN chown -R user:user /home/user

USER user
WORKDIR /home/user/dotfiles

RUN ./install

CMD ["/bin/bash"]