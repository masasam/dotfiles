init: ## Initial deploy dotfiles
	ln -vsf ${PWD}/.lesskey   ${HOME}/.lesskey
	lesskey
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
	mkdir -p ${HOME}/.config/gtk-3.0
	ln -vsf ${PWD}/.config/gtk-3.0/bookmarks   ${HOME}/.config/gtk-3.0/bookmarks
	mkdir -p ${HOME}/.config/termite
	ln -vsf ${PWD}/.config/termite/config   ${HOME}/.config/termite/config

initroot: ## Initial deploy need root authority
	sudo ln -vsf ${PWD}/etc/pacman.conf   /etc/pacman.conf
	sudo ln -vsf ${PWD}/etc/dnsmasq/resolv.dnsmasq.conf   /etc/resolv.dnsmasq.conf
	sudo ln -vsf ${PWD}/etc/dnsmasq/dnsmasq.conf   /etc/dnsmasq.conf
	sudo ln -vsf ${PWD}/etc/systemd/logind.conf   /etc/systemd/logind.conf
	sudo ln -vsf ${PWD}/etc/systemd/system/powertop.service   /etc/systemd/system/powertop.service
	sudo mkdir -p /etc/NetworkManager
	sudo ln -vsf ${PWD}/etc/NetworkManager/NetworkManager.conf /etc/NetworkManager/NetworkManager.conf
	sudo mkdir -p /etc/libreoffice
	sudo ln -vsf ${PWD}/etc/libreoffice/sofficerc /etc/libreoffice/sofficerc

initdropbox: ## Initial deploy dotfiles using dropbox
	ln -vsf ${PWD}/.muttrc   ${HOME}/.muttrc
	mkdir -p ${HOME}/.mutt
	ln -vsf ${PWD}/.mutt/mailcap   ${HOME}/.mutt/mailcap
	ln -vsf ${PWD}/.mutt/certificates   ${HOME}/.mutt/certificates
	ln -vsf ${HOME}/Dropbox/mutt/aliases   ${HOME}/.mutt/aliases
	ln -vsf ${HOME}/Dropbox/mutt/signature   ${HOME}/.mutt/signature
	ln -vsf ${HOME}/Dropbox/mutt/.goobookrc   ${HOME}/.goobookrc
	mkdir -p ${HOME}/.config
	ln -vsf ${HOME}/Dropbox/zsh/hub   ${HOME}/.config/hub
	test -L ${HOME}/.ssh || rm -rf ${HOME}/.ssh
	ln -vsfn ${HOME}/Dropbox/ssh   ${HOME}/.ssh
	test -L ${HOME}/.config/ranger || rm -rf ${HOME}/.config/ranger
	ln -vsfn ${HOME}/Dropbox/ranger   ${HOME}/.config/ranger
	mkdir -p ${HOME}/.local/share
	test -L ${HOME}/.local/share/keyrings || rm -rf ${HOME}/.local/share/keyrings
	ln -vsfn ${HOME}/Dropbox/passwd/keyrings   ${HOME}/.local/share/keyrings
	test -L ${HOME}/.sylpheed-2.0 || rm -rf ${HOME}/.sylpheed-2.0
	ln -vsfn ${HOME}/Dropbox/sylpheed/.sylpheed-2.0   ${HOME}/.sylpheed-2.0
	chmod 600   ${HOME}/.ssh/id_rsa

install: ## Install arch linux packages using pacman
	sudo pacman -S go zsh git vim dropbox nautilus-dropbox tmux keychain bashdb \
	zsh-completions gnome-tweak-tool xsel emacs evince unrar seahorse hugo mpv \
	archlinux-wallpaper inkscape file-roller xclip atool debootstrap valgrind \
	the_silver_searcher powertop cifs-utils gvfs gvfs-smb libreoffice-fresh-ja \
	gnome-keyring cups-pdf mcomix openssh firefox firefox-i18n-ja gimp strace \
	otf-ipafont pkgfile baobab dconf-editor rsync nodejs debian-archive-keyring \
	nmap poppler-data rtmpdump ffmpeg asciidoc sbcl docker aspell aspell-en ack \
	gdb ripgrep hub wmctrl pwgen linux-docs ansible htop tcpdump slack-desktop \
	arch-install-scripts termite neovim pandoc jq sylpheed pkgstats python-pip \
	texlive-langjapanese yarn texlive-latexextra ctags hdparm eog noto-fonts-cjk \
	arc-gtk-theme networkmanager npm typescript chromium llvm llvm-libs lldb php \
	zsh-syntax-highlighting xorg-apps shellcheck bash-completion mathjax expect \
	dnsmasq cscope lsof postgresql-libs pdfgrep gnu-netcat urxvt-perls cmatrix \
	curl docker-compose parallel alsa-utils mlocate traceroute jhead whois ruby \
	noto-fonts-emoji gpaste nethogs optipng jpegoptim elixir geckodriver ipcalc \
	gauche screen tig mosh fzf tree httpie w3m neomutt highlight mediainfo cpio \
	lynx elinks lhasa lzop p7zip unace irssi
	sudo pkgfile --update

update: ## Update arch linux packages and save packages cache 3 generations
	yaourt -Syua; paccache -ruk0

aur: ## Install arch linux AUR packages using yaourt
	yaourt drone-cli
	yaourt git-secrets
	yaourt goobook-git
	yaourt nkf
	yaourt peek
	yaourt profile-sync-daemon
	yaourt screenkey
	yaourt ttf-cica
	yaourt ttf-myrica

mozc: ## Install ibus-mozc
	test -L ${HOME}/.mozc || rm -rf ${HOME}/.mozc
	ln -vsfn ${HOME}/Dropbox/mozc/.mozc   ${HOME}/.mozc
	yaourt mozc
	yaourt ibus-mozc
	ibus-daemon -drx

emacsinit: ## Install emacs packages from MELPA using cask package manager
	curl -fsSL https://raw.githubusercontent.com/cask/cask/master/go | python
	test -L ${HOME}/.emacs.d || rm -rf ${HOME}/.emacs.d
	ln -vsfn ${PWD}/.emacs.d   ${HOME}/.emacs.d
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
	pip install --user rainbowstream
	pip install --user haxor-news
	pip install --user rtv

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

neoviminit: ## Init neovim
	mkdir -p ${HOME}/.config/nvim
	ln -vsf ${PWD}/.config/nvim/init.vim   ${HOME}/.config/nvim/init.vim
	ln -vsf ${PWD}/.config/nvim/installer.sh   ${HOME}/.config/nvim/installer.sh
	bash ${HOME}/.config/nvim/installer.sh ${HOME}/.config/nvim

dockerinit: ## Docker initial setup
	sudo usermod -aG docker ${USER}
	mkdir -p ${HOME}/.docker
	ln -vsf ${HOME}/Dropbox/docker/config.json   ${HOME}/.docker/config.json
	sudo systemctl enable docker.service
	sudo systemctl start docker.service

mariadbinit: # Mariadb initial setup
	sudo pacman -S mariadb mariadb-clients
	sudo mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
	sudo systemctl start mariadb.service
	mysql_secure_installation
	mysql -u root -p < ${HOME}/Dropbox/mariadb/world.sql/data

psdinit: ## Profile-Sync-Daemon initial setup
	mkdir -p ${HOME}/.config/psd
	ln -vsf ${PWD}/.config/psd/psd.conf   ${HOME}/.config/psd/psd.conf
	echo "${USER} ALL=(ALL) NOPASSWD: /usr/bin/psd-overlay-helper" | sudo EDITOR='tee -a' visudo
	systemctl --user enable psd.service

powertopinit: ## Powertop initial setup (Warning take a long time)
	sudo powertop --calibrate
	sudo systemctl enable powertop

gnupg: ## Import gnupg secret-key
	gpg --allow-secret-key-import --import ${HOME}/Dropbox/passwd/privkey.asc

kubernetes: ## Init kubernetes 
	yaourt google-cloud-sdk
	sudo gcloud components update kubectl
	gcloud init

kubernetes-cluster: ## Kubernetes cluster setup
	gcloud container clusters create --num-nodes=2 my-cluster \
	--zone us-central-a \
	--machine-type g1-small \
	--enable-autoscaling --min-nodes=2 --max-nodes=5

kubernetes-image2gcr: ## Upload docker image to Google Container Registry
	GCP_PROJECT=$(gcloud config get-value project)
	docker build -t us.gcr.io/${GCP_PROJECT}/myapp:1.0 ${HOME}/src/github.com/masasam/myapp
	gcloud docker -- push us.gcr.io/${GCP_PROJECT}/myapp:1.0
	open https://console.cloud.google.com/gcr

kubernetes-deploy: ## Deploy myapp to kubernetes cluster
	GCP_PROJECT=$(gcloud config get-value project)
	kubectl run myapp-deploy \
	--image=us.gcr.io/${GCP_PROJECT}/myapp:1.0 \
	--replicas=1 \
	--port=3000 \
	--limits=cpu=200m \
	--command -- node app/server.js
	kubectl get pod

kubernetes-publish: ## Publish kubernetes service
	kubectl expose deployment myapp-deploy --port=80 --target-port=3000 --type=LoadBalancer
	watch kubectl get service

kubernetes-scale: ## kubernetes scale 10 pod
	kubectl scale deploy myapp-deploy --replicas=10
	watch kubectl get pod

kubernetes-rolling-update: ## Rolling update for kubernetes
	GCP_PROJECT=$(gcloud config get-value project)
	docker build -t us.gcr.io/${GCP_PROJECT}/myapp:2.0 ${HOME}/src/github.com/masasam/myapp
	gcloud docker -- push us.gcr.io/${GCP_PROJECT}/myapp:2.0
	kubectl set image deployment/myapp-deploy myapp-deploy=us.gcr.io/${GCP_PROJECT}/myapp:2.0
	watch kubectl get node

kubernetes-rollout: ## Rollout version for kubernetes
	kubectl rollout history deployment/myapp-deploy

kubernetes-delete: ## Delete kubernetes cluster
	kubectl delete deployment,service,pod --all
	gcloud container clusters delete my-cluster

kubernetes-getyaml: ## Get yaml from kubernetes server
	kubectl get deployment/myapp-deploy -o yaml --export > deploy.yaml
	kubectl get service/myapp-deploy -o yaml --export > service.yaml
	cat service.yaml | sed -e "s/clusterIP/#clusterIP/" > service.yaml

kubernetes-deploy-yaml: ## Deploy from yaml
	kubectl create -f deploy.yaml
	kubectl create -f service.yaml
	kubectl get services

kubernetes-rolling-update-yaml: ## Rolling-update from yaml
	kubectl apply -f deploy.yaml
	kubectl get pod

kubernetes-delete-yaml: ## Delete kubernetes cluster from yaml
	kubectl delete -f deploy.yaml
	kubectl delete -f service.yaml
	gcloud container clusters delete myapp-cluster

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
	@echo "========== make initroot =========="
	docker exec makefiletest sh -c "cd ${PWD}; make initroot"
	@echo "========== make initdropbox =========="
	docker exec makefiletest sh -c "cd ${PWD}; make initdropbox"
	@echo "========== make emacsinit =========="
	docker exec makefiletest sh -c "cd ${PWD}; make emacsinit"
	@echo "========== make melpa =========="
	docker exec makefiletest sh -c "cd ${PWD}; make melpa"
	@echo "========== make aur =========="
	docker exec makefiletest sh -c "cd ${PWD}; make aur"
	@echo "========== make mozc =========="
	docker exec makefiletest sh -c "cd ${PWD}; make mozc"
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
	@echo "========== make initroot =========="
	docker exec makefiletest sh -c "cd ${PWD}; make initroot"
	@echo "========== make emacsinit =========="
	docker exec makefiletest sh -c "cd ${PWD}; make emacsinit"
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

allinstall: install init initroot initdropbox aur mozc emacsinit melpa pipinstall goinstall rubygems dockerinit mariadbinit psdinit rustinstall gnuglobal nodeinstall neoviminit

allupdate: update melpaupdate pipupdate rustupdate goinstall

allbackup: backup pipbackup

.PHONY: allinstall allupdate allbackup

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
	| sort \
	| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.DEFAULT_GOAL := help
