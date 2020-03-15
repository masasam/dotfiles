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

RUN useradd -m -G wheel -s /bin/bash ${USERNAME}
RUN echo "root:${PASSWORD}" | chpasswd
RUN echo "${USERNAME}:${PASSWORD}" | chpasswd
RUN echo '%wheel ALL=(ALL) ALL' | sudo EDITOR='tee -a' visudo

RUN pacman -Syy
RUN pacman -S xdg-user-dirs --noconfirm
RUN pacman -S git --noconfirm
RUN pacman -S go --noconfirm

ENV HOME /home/${USERNAME}
WORKDIR /home/${USERNAME}
USER ${USERNAME}
RUN LANG=C xdg-user-dirs-update --force
RUN mkdir -p /home/${USERNAME}/src/github.com && cd /home/${USERNAME}/src/github.com && git clone https://aur.archlinux.org/yay.git && cd /home/${USERNAME}/src/github.com/yay && makepkg -si
RUN mkdir -p /home/${USERNAME}/src/github.com/masasam && cd /home/${USERNAME}/src/github.com/masasam && git clone https://github.com/masasam/dotfiles
