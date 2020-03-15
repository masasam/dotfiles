# How to test Makefile
# 1.Build this Dockerfile
#   docker build -t dotfiles /home/${USER}/src/github.com/masasam/dotfiles
# 2.Run 'docker run' mounting the backup directory
#   docker run -t -i -v /home/${USER}/backup:/home/${USER}/backup:cached --name arch dotfiles /bin/bash
# 3.Execute the following command in the docker container
#   cd /home/${USER}/src/github.com/masasam/dotfiles
#   make install
#   make init

FROM archlinux:latest

ARG USERNAME=masa
ARG PASSWORD=hogehoge

ENV HOME /home/${USERNAME}

RUN pacman -Syu --noconfirm
RUN pacman -S base base-devel --noconfirm

RUN echo thinkpad > /etc/hostname
RUN echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen
RUN locale-gen
RUN export LANG=C
RUN echo LANG=ja_JP.UTF-8 > /etc/locale.conf

RUN useradd -m -r -G wheel -s /bin/bash ${USERNAME}
RUN echo "root:${PASSWORD}" | chpasswd
RUN echo "${USERNAME}:${PASSWORD}" | chpasswd
RUN echo '%wheel ALL=(ALL) ALL' | EDITOR='tee -a' visudo

RUN pacman -Syy
RUN pacman -S xdg-user-dirs --noconfirm
RUN pacman -S git --noconfirm
RUN pacman -S go --noconfirm
RUN pacman -S wget --noconfirm

ENV HOME /home/${USERNAME}
WORKDIR /home/${USERNAME}
USER ${USERNAME}
RUN LANG=C xdg-user-dirs-update --force &&\
	mkdir -p /home/${USERNAME}/src/github.com &&\
	mkdir -p /home/${USERNAME}/src/github.com/masasam

USER ${USERNAME}
WORKDIR /tmp
RUN wget https://github.com/Jguer/yay/releases/download/v9.4.6/yay_9.4.6_x86_64.tar.gz &&\
	tar xzvf yay_9.4.6_x86_64.tar.gz
USER root
RUN cp /tmp/yay_9.4.6_x86_64/yay /usr/bin/yay
USER ${USERNAME}
WORKDIR /home/${USERNAME}/src/github.com/masasam
RUN git clone https://github.com/masasam/dotfiles
