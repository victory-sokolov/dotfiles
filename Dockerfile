FROM ubuntu:20.04
MAINTAINER Viktor Sokolov

ENV USERNAME=viktor
ENV PASSWORD=qwerty

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    make \
    git \
    vim \
    sudo

WORKDIR dotfiles
# Creating a new sudo user
RUN useradd -ms /bin/bash ${USERNAME}
RUN echo "root:${PASSWORD}" | chpasswd
RUN echo "${USERNAME}:${PASSWORD}" | chpasswd
RUN echo "${USERNAME}  ALL=(ALL:ALL) NOPASSWD: ALL" > /etc/sudoers
RUN chown -R ${USERNAME} /dotfiles

USER ${USERNAME}
ARG CACHEBUST=1
RUN git clone https://github.com/victory-sokolov/dotfiles /dotfiles

CMD ["/bin/bash"]