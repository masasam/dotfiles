init: ## Initial deploy dotfiles
	ln -vsf ${PWD}/.lesskey   ${HOME}/.lesskey
	ln -vsf ${PWD}/.zshrc   ${HOME}/.zshrc
	ln -vsf ${PWD}/.vimrc   ${HOME}/.vimrc
	ln -vsf ${PWD}/.bashrc   ${HOME}/.bashrc
	ln -vsf ${PWD}/.gitconfig   ${HOME}/.gitconfig
	ln -vsf ${PWD}/.gitignore   ${HOME}/.gitignore
	ln -vsf ${PWD}/.npmrc   ${HOME}/.npmrc
	ln -vsf ${PWD}/.myclirc   ${HOME}/.myclirc
	ln -vsf ${PWD}/.tern-config   ${HOME}/.tern-config
	ln -vsf ${PWD}/.tmux.conf   ${HOME}/.tmux.conf
	ln -vsf ${PWD}/.screenrc   ${HOME}/.screenrc
	ln -vsf ${PWD}/.xinitrc   ${HOME}/.xinitrc
	ln -vsf ${PWD}/.Xresources   ${HOME}/.Xresources
	ln -vsf ${PWD}/.aspell.conf   ${HOME}/.aspell.conf
	mkdir -p ${HOME}/.config
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
	test -L ${HOME}/.emacs.d || rm -rf ${HOME}/.emacs.d
	ln -vsfn ${PWD}/.emacs.d   ${HOME}/.emacs.d
	lesskey

initdropbox: ## Initial deploy dotfiles using dropbox
	ln -vsf ${HOME}/Dropbox/mutt/.muttrc   ${HOME}/.muttrc
	test -L ${HOME}/.mutt || rm -rf ${HOME}/.mutt
	ln -vsfn ${HOME}/Dropbox/mutt/.mutt   ${HOME}/.mutt
	mkdir -p ${HOME}/.config
	ln -vsf ${HOME}/Dropbox/zsh/hub   ${HOME}/.config/hub
	mkdir -p ${HOME}/.docker
	ln -vsf ${HOME}/Dropbox/docker/config.json   ${HOME}/.docker/config.json
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
	curl docker-compose parallel alsa-utils mlocate traceroute jhead whois ruby \
	noto-fonts-emoji gpaste nethogs optipng jpegoptim elixir geckodriver ipcalc \
	gauche screen slack-desktop tig mosh fzf tree httpie w3m mutt
	sudo pkgfile --update

update: ## Update arch linux packages and save packages cache 3 generations
	yaourt -Syua; paccache -ruk0

aur: ## Install arch linux AUR packages using yaourt
	yaourt chrome-gnome-shell-git
	yaourt direnv
	yaourt git-secrets
	yaourt google-cloud-sdk
	yaourt ibus-mozc
	yaourt man-pages-ja
	yaourt mozc
	yaourt nkf
	yaourt peek
	yaourt profile-sync-daemon
	yaourt quicklisp
	yaourt screenkey
	yaourt ttf-cica
	yaourt ttf-myrica
	yaourt ttf-ricty
	yaourt yum

caskinstall: ## Install emacs cask package manager
	curl -fsSL https://raw.githubusercontent.com/cask/cask/master/go | python

melpa: ## Install emacs packages from MELPA using cask package manager
	export PATH="$HOME/.cask/bin:$PATH"
	cd ${HOME}/.emacs.d/; cask upgrade;cask install

melpaupdate: ## Update emacs packages and backup 6 generations packages
	export PATH="$HOME/.cask/bin:$PATH"
	mkdir -p ${HOME}/Dropbox/emacs/cask
	if [ `ls -rt ${HOME}/Dropbox/emacs/cask | head | wc -l` -gt 5 ];\
	then \
	rm -rf ${HOME}/Dropbox/emacs/cask/`ls -rt ${HOME}/Dropbox/emacs/cask \
	| head -n 1`;\
	tar cfz ${HOME}/Dropbox/emacs/cask/`date '+%Y%m%d%H%M%S'`.tar.gz -C ${HOME}/.emacs.d .cask;\
	cd ${HOME}/.emacs.d/;\
	cask upgrade;\
	cask update;\
	else \
	tar cfz ${HOME}/Dropbox/emacs/cask/`date '+%Y%m%d%H%M%S'`.tar.gz -C ${HOME}/.emacs.d .cask;\
	cd ${HOME}/.emacs.d/;\
	cask upgrade;\
	cask update;\
	fi

melpacleanup: ## Cleaninstall emacs packages (When emacs version up, always execute)
	export PATH="$HOME/.cask/bin:$PATH"
	rm -rf ${HOME}/.emacs.d/.cask; caskinstall

pipinstall: ## Install python packages
	mkdir -p ${HOME}/.local
	pip install --user virtualenv
	pip install --user virtualenvwrapper
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
	pip install --user scrapy
	pip install --user mycli
	pip install --user pgcli
	pip install --user pip-review
	pip install --user yapf
	pip install --user pydoc_utils
	pip install --user rope
	pip install --user importmagic
	pip install --user awscli
	pip install --user progressbar2
	pip install --user ranger-fm

pipbackup: ## Backup python packages
	mkdir -p ${PWD}/archlinux
	pip freeze > ${PWD}/archlinux/requirements.txt

piprecover: ## Recover python packages
	mkdir -p ${PWD}/archlinux
	pip install --user -r ${PWD}/archlinux/requirements.txt

pipupdate: ## Update python packages
	pip-review --user | cut -d = -f 1 | xargs pip install -U --user

goinstall: ## Install go packages
	export GOPATH=${HOME}
	export PATH="$PATH:$GOPATH/bin"
	mkdir -p ${HOME}/{bin,src}
	go get -u -v github.com/nsf/gocode
	go get -u -v github.com/rogpeppe/godef
	go get -u -v golang.org/x/tools/cmd/goimports
	go get -u -v golang.org/x/tools/cmd/godoc
	go get -u -v github.com/josharian/impl
	go get -u -v github.com/jstemmer/gotags
	go get -u -v github.com/golang/dep/cmd/dep
	go get -u -v github.com/pressly/goose/cmd/goose
	go get -u -v github.com/motemen/ghq

nodeinstall: ## Install node packages
	mkdir -p ${HOME}/.node_modules
	export npm_config_prefix=${HOME}/.node_modules
	yarn global add npm
	yarn global add tern
	yarn global add jshint
	yarn global add eslint
	yarn global add babel-eslint
	yarn global add eslint-plugin-react

rubygems: ## Install rubygems packages
	mkdir -p ${HOME}/.gem/
	gem install --user-install bundle
	gem install --user-install jekyll
	gem install --user-install pry
	gem install --user-install github-markup
	gem install --user-install tw

rustinstall: ## Install rust and rust packages
	mkdir -p ${HOME}/.cargo
	export PATH="$HOME/.cargo/bin:$PATH"
	curl -sSf https://sh.rustup.rs | sh
	cargo install rustfmt
	cargo install racer
	cargo install cargo-update
	cargo install cargo-script
	cargo install cargo-edit
	rustup component add rust-src

rustupdate: ## Update rust packages
	cargo install-update -a

gnuglobal: ## Install gnu global
	mkdir -p ${HOME}/.local
	pip install --user pygments
	yaourt global

backup: ## Backup arch linux packages
	mkdir -p ${PWD}/archlinux
	pacman -Qqen > ${PWD}/archlinux/pacmanlist
	pacman -Qnq > ${PWD}/archlinux/allpacmanlist
	pacman -Qqem > ${PWD}/archlinux/yaourtlist

recover: ## Recover arch linux packages from backup
	sudo pacman -S --needed `cat ${PWD}/archlinux/pacmanlist`
	yaourt -S --needed $(DOY) `cat ${PWD}/archlinux/yaourtlist`

neoviminit: ## Init neovim dein
	bash ${HOME}/.config/nvim/installer.sh ${HOME}/.config/nvim

dockerinit: ## Docker initial setup
	sudo usermod -aG docker ${USER}
	sudo systemctl enable docker.service
	sudo systemctl start docker.service
	sudo systemctl stop docker.service
	sudo systemctl disable docker.service
	sudo ln -vsf ${PWD}/etc/docker/daemon.json   /etc/docker/daemon.json
	sudo systemctl start docker.service

mariadbinit: # Mariadb initial setup
	sudo mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
	sudo systemctl start mariadb.service
	mysql_secure_installation

psdinit: ## Profile-Sync-Daemon initial setup
	echo "${USER} ALL=(ALL) NOPASSWD: /usr/bin/psd-overlay-helper" | sudo EDITOR='tee -a' visudo
	systemctl --user enable psd.service

powertopinit: ## Powertop initial setup (Warning take a long time)
	sudo powertop --calibrate
	sudo systemctl enable powertop

gnupg: ## Import gnupg secret-key
	gpg --allow-secret-key-import --import ~/Dropbox/passwd/privkey.asc

terminal-slack: ## Install and init terminal-slack
	git clone https://github.com/evanyeung/terminal-slack.git
	cd ${HOME}/src/github.com/evanyeung/terminal-slack
	yarn install
	sudo ln -vsf ${HOME}/Dropbox/slack/slack-emacs   /usr/local/bin/slack-emacs
	sudo chmod a+x   /usr/local/bin/slack-emacs

test: ## Test this Makefile using docker
	docker build -t dotfiles ${PWD}
	docker run -v /home/${USER}/Dropbox:${HOME}/Dropbox:cached --name makefiletest -d dotfiles
	@echo "========== make install =========="
	docker exec makefiletest sh -c "cd ${PWD}; make install"
	@echo "========== make init =========="
	docker exec makefiletest sh -c "cd ${PWD}; make init"
	@echo "========== make initdropbox =========="
	docker exec makefiletest sh -c "cd ${PWD}; make initdropbox"
	@echo "========== make caskinstall =========="
	docker exec makefiletest sh -c "cd ${PWD}; make caskinstall"
	@echo "========== make melpa =========="
	docker exec makefiletest sh -c "cd ${PWD}; make melpa"
	@echo "========== make aur =========="
	docker exec makefiletest sh -c "cd ${PWD}; make aur"
	@echo "========== make pipinstall =========="
	docker exec makefiletest sh -c "cd ${PWD}; make pipinstall"
	@echo "========== make goinstall =========="
	docker exec makefiletest sh -c "cd ${PWD}; make goinstall"
	@echo "========== make nodeinstall =========="
	docker exec makefiletest sh -c "cd ${PWD}; make nodeinstall"
	@echo "========== make rubygems =========="
	docker exec makefiletest sh -c "cd ${PWD}; make rubygems"
	@echo "========== make rustinstall =========="
	docker exec makefiletest sh -c "cd ${PWD}; make rustinstall"

testsimple: ## Test this Makefile using docker without Dropbox
	docker build -t dotfiles ${PWD}
	docker run --name makefiletest -d dotfiles
	@echo "========== make install =========="
	docker exec makefiletest sh -c "cd ${PWD}; make install"
	@echo "========== make init =========="
	docker exec makefiletest sh -c "cd ${PWD}; make init"
	@echo "========== make caskinstall =========="
	docker exec makefiletest sh -c "cd ${PWD}; make caskinstall"
	@echo "========== make melpa =========="
	docker exec makefiletest sh -c "cd ${PWD}; make melpa"
	@echo "========== make aur =========="
	docker exec makefiletest sh -c "cd ${PWD}; make aur"
	@echo "========== make pipinstall =========="
	docker exec makefiletest sh -c "cd ${PWD}; make pipinstall"
	@echo "========== make goinstall =========="
	docker exec makefiletest sh -c "cd ${PWD}; make goinstall"
	@echo "========== make nodeinstall =========="
	docker exec makefiletest sh -c "cd ${PWD}; make nodeinstall"
	@echo "========== make rubygems =========="
	docker exec makefiletest sh -c "cd ${PWD}; make rubygems"
	@echo "========== make rustinstall =========="
	docker exec makefiletest sh -c "cd ${PWD}; make rustinstall"

allinstall: install init initdropbox aur caskinstall melpa pipinstall goinstall nodeinstall rubygems rustinstall gnuglobal

allinit: neoviminit dockerinit mariadbinit psdinit

allupdate: update melpaupdate pipupdate rustupdate goinstall

allbackup: backup pipbackup

.PHONY: allinstall allinit allupdate allbackup

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
	| sort \
	| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.DEFAULT_GOAL := help
