FROM archlinux:latest

ARG USERNAME=masa
ARG PASSWORD=hogehoge
ARG HOSTNAME=thinkpad
ARG REPOSITORY=/home/${USERNAME}/src/github.com/masasam

ENV HOME /home/${USERNAME}

RUN pacman -Syu --noconfirm
RUN pacman -S base base-devel --noconfirm

RUN echo ${HOSTNAME} > /etc/hostname
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
	mkdir -p ${REPOSITORY}

USER ${USERNAME}
WORKDIR /tmp
RUN wget https://github.com/Jguer/yay/releases/download/v12.5.2/yay_12.5.2_x86_64.tar.gz &&\
	tar xzvf yay_12.5.2_x86_64.tar.gz
USER root
RUN cp /tmp/yay_12.5.2_x86_64/yay /usr/bin/yay
USER ${USERNAME}
WORKDIR ${REPOSITORY}
RUN git clone https://github.com/masasam/dotfiles
