GITHUB=src/github.com/masasam/dotfiles

init: ## Initial deploy dotfiles
	ln -vsf ${PWD}/.zshrc   ${HOME}/.zshrc
	ln -vsf ${PWD}/.vimrc   ${HOME}/.vimrc
	ln -vsf ${PWD}/.bashrc   ${HOME}/.bashrc
	ln -vsf ${PWD}/.gitconfig   ${HOME}/.gitconfig
	ln -vsf ${PWD}/.gitignore   ${HOME}/.gitignore
	ln -vsf ${PWD}/.npmrc   ${HOME}/.npmrc
	ln -vsf ${PWD}/.tern-config   ${HOME}/.tern-config
	ln -vsf ${PWD}/.tmux.conf   ${HOME}/.tmux.conf
	ln -vsf ${PWD}/.screenrc   ${HOME}/.screenrc
	ln -vsf ${PWD}/.xinitrc   ${HOME}/.xinitrc
	ln -vsf ${PWD}/.Xresources   ${HOME}/.Xresources
	ln -vsf ${PWD}/.aspell.conf   ${HOME}/.aspell.conf
	mkdir -p ${HOME}/.config
	ln -vsf ${HOME}/Dropbox/zsh/hub   ${HOME}/.config/hub
	mkdir -p ${HOME}/.docker
	ln -vsf ${HOME}/Dropbox/docker/config.json   ${HOME}/.docker/config.json
	ln -vsf ${PWD}/.config/screenkey.json ${HOME}/.config/screenkey.json
	mkdir -p ${HOME}/.config/psd
	ln -vsf ${PWD}/.config/psd/psd.conf   ${HOME}/.config/psd/psd.conf
	mkdir -p ${HOME}/.config/gtk-3.0
	ln -vsf ${PWD}/.config/gtk-3.0/bookmarks   ${HOME}/.config/gtk-3.0/bookmarks
	sudo ln -vsf ${PWD}/etc/pacman.conf   /etc/pacman.conf
	sudo ln -vsf ${PWD}/etc/dnsmasq/resolv.dnsmasq.conf   /etc/resolv.dnsmasq.conf
	sudo ln -vsf ${PWD}/etc/dnsmasq/dnsmasq.conf   /etc/dnsmasq.conf
	sudo ln -vsf ${PWD}/etc/systemd/logind.conf   /etc/systemd/logind.conf
	sudo ln -vsf ${PWD}/etc/systemd/system/powertop.service   /etc/systemd/system/powertop.service
	sudo mkdir -p /etc/NetworkManager
	sudo ln -vsf ${PWD}/etc/NetworkManager/NetworkManager.conf /etc/NetworkManager/NetworkManager.conf
	sudo mkdir -p /etc/libreoffice
	sudo ln -vsf ${PWD}/etc/libreoffice/sofficerc /etc/libreoffice/sofficerc
	mkdir -p ${HOME}/.config/termite
	ln -vsf ${PWD}/.config/termite/config   ${HOME}/.config/termite/config
	mkdir -p ${HOME}/.config/nvim
	ln -vsf ${PWD}/.config/nvim/init.vim   ${HOME}/.config/nvim/init.vim
	ln -vsf ${PWD}/.config/nvim/installer.sh   ${HOME}/.config/nvim/installer.sh
	test -L ${HOME}/.peco || rm -rf ${HOME}/.peco
	ln -vsfn ${PWD}/.peco   ${HOME}/.peco
	test -L ${HOME}/.emacs.d || rm -rf ${HOME}/.emacs.d
	ln -vsfn ${PWD}/.emacs.d   ${HOME}/.emacs.d
	test -L ${HOME}/.ssh || rm -rf ${HOME}/.ssh
	ln -vsfn ${HOME}/Dropbox/ssh   ${HOME}/.ssh
	mkdir -p ${HOME}/.local/share
	test -L ${HOME}/.local/share/keyrings || rm -rf ${HOME}/.local/share/keyrings
	ln -vsfn ${HOME}/Dropbox/passwd/keyrings   ${HOME}/.local/share/keyrings
	test -L ${HOME}/.sylpheed-2.0 || rm -rf ${HOME}/.sylpheed-2.0
	ln -vsfn ${HOME}/Dropbox/sylpheed/.sylpheed-2.0   ${HOME}/.sylpheed-2.0
	test -L ${HOME}/.mozc || rm -rf ${HOME}/.mozc
	ln -vsfn ${HOME}/Dropbox/mozc/.mozc   ${HOME}/.mozc
	chmod 600   ${HOME}/.ssh/id_rsa

install: ## Install arch linux packages using pacman
	sudo pacman -S go zsh git vim dropbox nautilus-dropbox tmux keychain bashdb \
	zsh-completions gnome-tweak-tool xsel emacs evince unrar seahorse hugo mpv \
	archlinux-wallpaper inkscape file-roller xclip atool debootstrap valgrind \
	the_silver_searcher powertop cifs-utils gvfs gvfs-smb libreoffice-fresh-ja \
	gnome-keyring cups-pdf mcomix openssh firefox firefox-i18n-ja gimp strace \
	otf-ipafont pkgfile baobab dconf-editor rsync nodejs debian-archive-keyring \
	nmap poppler-data rtmpdump ffmpeg asciidoc sbcl docker aspell aspell-en ack \
	gdb ripgrep hub wmctrl pwgen linux-docs ansible htop mariadb-clients tcpdump \
	arch-install-scripts termite neovim pandoc jq sylpheed pkgstats python-pip \
	texlive-langjapanese yarn texlive-latexextra ctags hdparm eog noto-fonts-cjk \
	arc-gtk-theme networkmanager npm typescript chromium llvm llvm-libs lldb php \
	zsh-syntax-highlighting xorg-apps shellcheck bash-completion mathjax expect \
	dnsmasq cscope lsof postgresql-libs pdfgrep gnu-netcat urxvt-perls cmatrix \
	curl docker-compose parallel alsa-utils mlocate traceroute rust-racer jhead \
	noto-fonts-emoji rust cargo rustup rustfmt gpaste nethogs optipng jpegoptim \
	gauche screen ipcalc slack-desktop tig aws-cli elixir phantomjs geckodriver \
	whois
	sudo pkgfile --update

aur: ## Install AUR packages using yaourt
	yaourt chrome-gnome-shell-git
	yaourt ctop
	yaourt direnv
	yaourt ghq
	yaourt git-secrets
	yaourt google-cloud-sdk
	yaourt ibus-mozc
	yaourt man-pages-ja
	yaourt mozc
	yaourt nkf
	yaourt peco
	yaourt profile-sync-daemon
	yaourt quicklisp
	yaourt screenkey
	yaourt ttf-cica
	yaourt ttf-myrica
	yaourt ttf-ricty
	yaourt yum

backup: ## Backup archlinux packages
	mkdir -p ${HOME}/${GITHUB}/archlinux
	pacman -Qqen > ${HOME}/${GITHUB}/archlinux/pacmanlist
	pacman -Qnq > ${HOME}/${GITHUB}/archlinux/allpacmanlist
	pacman -Qqem > ${HOME}/${GITHUB}/archlinux/yaourtlist

rubygems: ## Install rubygems packages
	gem install --user-install bundle
	gem install --user-install jekyll
	gem install --user-install pry

npminit: ## Install node packages
	mkdir -p ${HOME}/.node_modules
	export npm_config_prefix=${HOME}/.node_modules
	yarn global add npm
	yarn global add tern
	yarn global add jshint
	yarn global add eslint
	yarn global add babel-eslint
	yarn global add eslint-plugin-react
	yarn global add casperjs

goinstall: ## Install go packages
	export GOPATH=${HOME}
	export PATH="$PATH:$GOPATH/bin"
	mkdir -p ${HOME}/{bin,src}
	go get -u github.com/nsf/gocode
	go get -u github.com/rogpeppe/godef
	go get -u golang.org/x/tools/cmd/goimports
	go get -u golang.org/x/tools/cmd/godoc
	go get -u github.com/josharian/impl
	go get -u github.com/jstemmer/gotags
	go get -u github.com/golang/dep/cmd/dep

pipinstall: ## Install pip packages
	mkdir -p ${HOME}/.virtualenvs
	pip install --user virtualenv
	pip install --user pipenv
	pip install --user seaborn
	pip install --user ipywidgets
	pip install --user scikit-learn
	pip install --user scipy
	pip install --user pandas
	pip install --user matplotlib
	pip install --user jupyter
	pip install --user neovim
	pip install --user pylint
	pip install --user jedi
	pip install --user autopep8
	pip install --user flake8
	pip install --user pyflakes
	pip install --user speedtest-cli
	pip install --user selenium
	pip install --user ansible-container

pipbackup: ## Backup pip packages
	mkdir -p ${HOME}/${GITHUB}/archlinux
	pip freeze > ${HOME}/${GITHUB}/archlinux/packages_requirements.txt

piprecover: ## Recover pip packages
	mkdir -p ${HOME}/${GITHUB}/archlinux
	pip install --user -r ${HOME}/${GITHUB}/archlinux/packages_requirements.txt

pipupdate: ## Update pip packages
	cat ${HOME}/${GITHUB}/archlinux/packages_requirements.txt | grep -v '^\-e' | cut -d = -f 1 | xargs pip install -U pip

gnuglobal: ## install gnu gloval
	pip install --user pygments
	yaourt global

cargoinstall: ## Install cargo packages
	cargo install cargo-script

recover: ## Recover from backup arch linux packages
	sudo pacman -S --needed `cat ${HOME}/${GITHUB}/archlinux/pacmanlist`
	yaourt -S --needed $(DOY) `cat ${HOME}/${GITHUB}/archlinux/yaourtlist`

dockerinit: ## Docker initial setup
	sudo usermod -aG docker ${USER}
	sudo systemctl enable docker.service
	sudo systemctl start docker.service
	sudo systemctl stop docker.service
	sudo systemctl disable docker.service
	sudo ln -vsf ${PWD}/etc/docker/daemon.json   /etc/docker/daemon.json
	sudo systemctl start docker.service

psdinit: ## Profile-Sync-Daemon initial setup
	echo "${USER} ALL=(ALL) NOPASSWD: /usr/bin/psd-overlay-helper" | sudo EDITOR='tee -a' visudo
	systemctl --user enable psd.service

powertopinit: ## Powertop initial setup (Warning take a long time)
	sudo powertop --calibrate
	sudo systemctl enable powertop

caskinit: ## Initial emacs cask
	curl -fsSL https://raw.githubusercontent.com/cask/cask/master/go | python

neoviminit: # Init neovim dein
	bash ${HOME}/.config/nvim/installer.sh ${HOME}/.config/nvim

updatedb: ## Update file datebase
	sudo updatedb

all: aur backup cask caskinit dockerinit goinstall init install cargoinstall npminit rubygems psdinit powertopinit recover updatedb neoviminit help pipinstall pipbackup piprecover pipupdate

.PHONY: all

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.DEFAULT_GOAL := help
