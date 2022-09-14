FROM ubuntu:20.04

ENV USERNAME=viktor
ENV PASSWORD=qwerty
ENV REPOSITORY=victory-sokolov/dotfiles
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    make \
    git \
    vim \
    sudo


WORKDIR /home/${USERNAME}

# Creating a new sudo user
RUN useradd -ms /bin/bash ${USERNAME}
RUN echo "root:${PASSWORD}" | chpasswd
RUN echo "${USERNAME}:${PASSWORD}" | chpasswd
RUN echo "${USERNAME}  ALL=(ALL:ALL) NOPASSWD: ALL" > /etc/sudoers
RUN chown -R ${USERNAME} /home/${USERNAME}

USER ${USERNAME}

RUN sudo git clone https://github.com/victory-sokolov/dotfiles.git /dotfiles
ADD https://api.github.com/repos/${REPOSITORY}/git/refs/heads/master version.json
RUN git clone -b master https://github.com/${REPOSITORY}

CMD ["/bin/bash"]
