FROM ubuntu:24.10

ENV USERNAME=viktor
ENV REPOSITORY=victory-sokolov/dotfiles
ENV DEBIAN_FRONTEND=noninteractive

RUN echo "Acquire::http::Pipeline-Depth 0;" > /etc/apt/apt.conf.d/99custom && \
    echo "Acquire::http::No-Cache true;" >> /etc/apt/apt.conf.d/99custom && \
    echo "Acquire::BrokenProxy    true;" >> /etc/apt/apt.conf.d/99custom

RUN apt-get clean \
    && apt-get update && apt-get install -y --fix-missing \
    make \
    git \
    vim

WORKDIR /dotfiles

RUN git clone https://github.com/${REPOSITORY}.git

CMD ["/bin/bash"]
