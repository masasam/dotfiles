# How to test Makefile
# 1.Build this Dockerfile
#   docker build -t dotfiles /home/masa/src/github.com/masasam/dotfiles
# 2.Run docker run and execute the following command in the docker container
#   docker run -t -i -v /home/masa/Dropbox:/home/masa/Dropbox:cached --name arch dotfiles /bin/bash
#   cd /home/masa/src/github.com/masasam/dotfiles
#   make install
#   make init

FROM base/archlinux:latest

ARG USERNAME=masa
ARG PASSWORD=hogehoge

ENV HOME /home/masa

RUN pacman -Syu --noconfirm
RUN pacman -S base base-devel --noconfirm

RUN echo thinkpad > /etc/hostname
RUN ln -fs /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
RUN echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen && echo 'ja_JP.UTF-8 UTF-8' >> /etc/locale.gen
RUN locale-gen
RUN export LANG=C
RUN echo LANG=ja_JP.UTF-8 > /etc/locale.conf

RUN useradd -m -G wheel -s /bin/bash ${USERNAME}
RUN echo "root:${PASSWORD}" | chpasswd
RUN echo "${USERNAME}:${PASSWORD}" | chpasswd
RUN echo '%wheel ALL=(ALL) ALL' >> /etc/sudoers

RUN echo -e '[archlinuxfr]\nSigLevel = Never\nServer = http://repo.archlinux.fr/$arch\n' >> /etc/pacman.conf
RUN pacman -Syy
RUN pacman -S yaourt --noconfirm
RUN pacman --sync --refresh --noconfirm yaourt
RUN yaourt -Syua --noconfirm
RUN pacman -S xdg-user-dirs --noconfirm
RUN pacman -S git --noconfirm

RUN su - ${USERNAME}
RUN LANG=C xdg-user-dirs-update --force
RUN mkdir -p /home/masa/src/github.com/masasam && cd /home/masa/src/github.com/masasam && git clone git://github.com/masasam/dotfiles
