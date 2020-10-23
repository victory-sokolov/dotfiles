FROM debian:jessie-slim
MAINTAINER Viktor Sokolov

ENV USERNAME=viktor
ENV PASSWORD=qwerty

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    make \
    git \
    sudo

WORKDIR dotfiles
# Creating a new sudo user
RUN useradd -ms /bin/bash ${USERNAME}
RUN echo "root:${PASSWORD}" | chpasswd
RUN echo "${USERNAME}:${PASSWORD}" | chpasswd
RUN echo "${USERNAME}  ALL=(ALL:ALL) NOPASSWD: ALL" > /etc/sudoers
RUN chown -R ${USERNAME} /dotfiles

USER ${USERNAME}

RUN git clone https://github.com/victory-sokolov/dotfiles /dotfiles

CMD ["/bin/bash"]