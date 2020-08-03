FROM debian:jessie-slim
MAINTAINER Viktor Sokolov

ENV USERNAME=viktor

RUN apt-get update && apt-get install -y --no-install-recommends \
    git

# Creating a new sudo user
RUN useradd ${USERNAME}
RUN usermod -aG sudo ${USERNAME}
RUN echo "${USERNAME}  ALL=(ALL:ALL) NOPASSWD: ALL" > /etc/sudoers
RUN chown -R user:${USERNAME} /home/${USERNAME}

USER ${USERNAME}
WORKDIR /home/${USERNAME}
    
# download dotfiles
RUN git clone https://github.com/victory-sokolov/dotfiles

# CMD ["/bin/bash"]