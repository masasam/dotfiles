export PATH := ${HOME}/.local/bin:${HOME}/.node_modules/bin:${HOME}/.cargo/bin:${HOME}/.cask/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/bin/core_perl:${HOME}/bin
export GOPATH := ${HOME}

init: ## Initial deploy dotfiles
	ln -vsf ${PWD}/.lesskey   ${HOME}/.lesskey
	lesskey
	ln -vsf ${PWD}/.zshrc   ${HOME}/.zshrc
	ln -vsf ${PWD}/.vimrc   ${HOME}/.vimrc
	ln -vsf ${PWD}/.bashrc   ${HOME}/.bashrc
	ln -vsf ${PWD}/.gitignore   ${HOME}/.gitignore
	ln -vsf ${PWD}/.npmrc   ${HOME}/.npmrc
	ln -vsf ${PWD}/.myclirc   ${HOME}/.myclirc
	ln -vsf ${PWD}/.tern-config   ${HOME}/.tern-config
	ln -vsf ${PWD}/.tmux.conf   ${HOME}/.tmux.conf
	ln -vsf ${PWD}/.screenrc   ${HOME}/.screenrc
	ln -vsf ${PWD}/.aspell.conf   ${HOME}/.aspell.conf

initdropbox: ## Initial deploy dotfiles using dropbox
	sudo ln -vsf ${HOME}/Dropbox/arch/hosts   /etc/hosts
	ln -vsf ${HOME}/Dropbox/zsh/.gitconfig   ${HOME}/.gitconfig
	mkdir -p ${HOME}/.config
	ln -vsf ${HOME}/Dropbox/zsh/.netrc   ${HOME}/.netrc
	ln -vsf ${HOME}/Dropbox/zsh/.mycli-history   ${HOME}/.mycli-history
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
	sudo pacman -S go zsh git vim tmux keychain evince unrar seahorse hugo mpv \
	zsh-completions xsel emacs gvfs-smb unace iperf valgrind noto-fonts-emoji \
	inkscape file-roller xclip atool debootstrap oath-toolkit imagemagick lynx \
	the_silver_searcher cifs-utils elinks flameshot ruby-rdoc ipcalc traceroute \
	cups-pdf openssh firefox firefox-i18n-ja gimp strace lhasa hub bookworm tig \
	pkgfile baobab dconf-editor rsync nodejs debian-archive-keyring gauche cpio \
	nmap poppler-data ffmpeg asciidoc sbcl docker aspell aspell-en screen mosh \
	gdb wmctrl pwgen linux-docs htop tcpdump gvfs p7zip lzop fzf gpaste optipng \
	arch-install-scripts pandoc jq sylpheed pkgstats python-pip ruby highlight  \
	texlive-langjapanese yarn texlive-latexextra ctags hdparm eog noto-fonts-cjk \
	arc-gtk-theme npm typescript chromium llvm llvm-libs lldb php tree w3m neomutt \
	zsh-syntax-highlighting shellcheck bash-completion mathjax expect elixir lsof \
	cscope postgresql-libs pdfgrep gnu-netcat cmatrix jpegoptim nethogs alsa-utils \
	curl parallel mlocate jhead whois geckodriver
	sudo pkgfile --update

pipinstall: ## Install python packages
	mkdir -p ${HOME}/.local
	pip install --user --upgrade pip
	pip install --user virtualenv
	pip install --user ansible
	pip install --user ansible-lint
	pip install --user docker-compose
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
	pip install --user progressbar2
	pip install --user ranger-fm
	pip install --user rtv
	pip install --user jupyterthemes
	pip install --user httpie
	pip install --user trash-cli
	pip install --user jupyterlab
	pip install --user cheat
	pip install --user faker

goinstall: ## Install go packages
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
	go get -u -v github.com/sonatard/ghs
	go get -u -v github.com/kyoshidajp/ghkw
	go get -u -v github.com/hashicorp/packer

nodeinstall: ## Install node packages
	mkdir -p ${HOME}/.node_modules
	yarn global add npm
	yarn global add tern
	yarn global add jshint
	yarn global add eslint
	yarn global add babel-eslint
	yarn global add eslint-plugin-react
	yarn global add vue-language-server
	yarn global add vue-cli
	yarn global add create-react-app
	yarn global add create-component-app
	yarn global add prettier
	yarn global add firebase-tools
	yarn global add heroku-cli
	yarn global add webpack
	yarn global add gulp
	yarn global add tldr

rustinstall: ## Install rust and rust packages
	sudo pacman -S cmake
	mkdir -p ${HOME}/.cargo
	curl -sSf https://sh.rustup.rs | sh
	cargo install racer
	cargo install cargo-update
	cargo install cargo-script
	cargo install cargo-edit
	cargo install ripgrep
	cargo install exa
	cargo install fd-find
	cargo install xsv
	cargo install hyperfine
	rustup component add rust-src

neomutt: ## Init neomutt mail client
	mkdir -p ${HOME}/.mutt
	ln -vsf ${PWD}/.muttrc   ${HOME}/.muttrc
	ln -vsf ${PWD}/.mutt/mailcap   ${HOME}/.mutt/mailcap
	ln -vsf ${PWD}/.mutt/certificates   ${HOME}/.mutt/certificates
	ln -vsf ${HOME}/Dropbox/mutt/aliases   ${HOME}/.mutt/aliases
	ln -vsf ${HOME}/Dropbox/mutt/signature   ${HOME}/.mutt/signature
	ln -vsf ${HOME}/Dropbox/mutt/.goobookrc   ${HOME}/.goobookrc
	yaourt -S goobook-git
	goobook authenticate

urxvt: ## Init rxvt-unicode terminal
	sudo pacman -S rxvt-unicode urxvt-perls
	ln -vsf ${PWD}/.Xresources   ${HOME}/.Xresources
	sudo ln -vsf ${PWD}/usr/share/applications/urxvtc.desktop   /usr/share/applications/urxvtc.desktop
	sudo ln -vsf ${PWD}/usr/share/applications/urxvt-tabbed.desktop   /usr/share/applications/urxvt-tabbed.desktop

xterm: ## Init xterm terminal
	sudo pacman -S xterm
	ln -vsf ${PWD}/.Xresources   ${HOME}/.Xresources
	sudo ln -vsf ${PWD}/usr/share/applications/xterm.desktop   /usr/share/applications/xterm.desktop
	sudo ln -vsf ${PWD}/usr/share/applications/uxterm.desktop   /usr/share/applications/uxterm.desktop

mlterm: ## Init mlterm terminal
	yaourt -S mlterm
	mkdir -p ${HOME}/.mlterm
	ln -vsf ${PWD}/.mlterm/main   ${HOME}/.mlterm/main
	ln -vsf ${PWD}/.mlterm/color   ${HOME}/.mlterm/color
	ln -vsf ${PWD}/.mlterm/aafont   ${HOME}/.mlterm/aafont
	ln -vsf ${PWD}/.mlterm/key   ${HOME}/.mlterm/key
	sudo ln -vsf ${PWD}/usr/share/applications/mlterm.desktop   /usr/share/applications/mlterm.desktop
	sudo ln -vsf ${PWD}/usr/share/applications/mlclient.desktop   /usr/share/applications/mlclient.desktop

termite: ## Init termite terminal
	sudo pacman -S termite
	mkdir -p ${HOME}/.config/termite
	ln -vsf ${PWD}/.config/termite/config   ${HOME}/.config/termite/config

dnsmasq: ## Init dnsmasq
	sudo pacman -S dnsmasq
	sudo ln -vsf ${PWD}/etc/dnsmasq/resolv.dnsmasq.conf   /etc/resolv.dnsmasq.conf
	sudo ln -vsf ${PWD}/etc/dnsmasq/dnsmasq.conf   /etc/dnsmasq.conf
	sudo mkdir -p /etc/NetworkManager
	sudo ln -vsf ${PWD}/etc/NetworkManager/NetworkManager.conf /etc/NetworkManager/NetworkManager.conf

mozc: ## Install ibus-mozc
	test -L ${HOME}/.mozc || rm -rf ${HOME}/.mozc
	ln -vsfn ${HOME}/Dropbox/mozc/.mozc   ${HOME}/.mozc
	yaourt -S ibus-mozc
	ibus-daemon -drx

ttf-cica: ## Install Cica font
	cd ${HOME}/Dropbox/arch/Cica_v3.0.0-rc1/;\
	sudo install -dm755 /usr/share/fonts/TTF;\
	sudo install -m644 *.ttf /usr/share/fonts/TTF/;\
	sudo install -d /usr/share/licenses/ttf-cica/;\
	sudo install -Dm644 *.txt /usr/share/licenses/ttf-cica/;\
	cd -

melpa: ## Install emacs packages from MELPA using cask package manager
	curl -fsSL https://raw.githubusercontent.com/cask/cask/master/go | python
	test -L ${HOME}/.emacs.d || rm -rf ${HOME}/.emacs.d
	ln -vsfn ${PWD}/.emacs.d   ${HOME}/.emacs.d
	cd ${HOME}/.emacs.d/; cask upgrade;cask install
	cd -

docker: ## Docker initial setup
	sudo usermod -aG docker ${USER}
	mkdir -p ${HOME}/.docker
	ln -vsf ${HOME}/Dropbox/docker/config.json   ${HOME}/.docker/config.json
	sudo systemctl enable docker.service
	sudo systemctl start docker.service

mariadb: # Mariadb initial setup
	sudo ln -vsf ${PWD}/etc/sysctl.d/40-max-user-watches.conf   /etc/sysctl.d/40-max-user-watches.conf
	sudo pacman -S mariadb mariadb-clients
	sudo ln -vsf ${PWD}/etc/mysql/my.cnf   /etc/mysql/my.cnf
	sudo mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
	sudo systemctl enable mariadb.service
	sudo systemctl start mariadb.service
	mysql_secure_installation
	mysql -u root -p < ${HOME}/Dropbox/mariadb/world.sql/data

redis: ## Redis inital setup
	sudo pacman -S redis
	sudo systemctl enable redis.service
	sudo systemctl start redis.service

rbenv: ## Install rvenv ruby-build
	yaourt -S rbenv
	yaourt -S ruby-build
	rbenv install 2.5.0
	gem install bundle

rails: ## Create rails app
	export RBENV_ROOT="${HOME}/.rbenv";\
	if [ -d "${RBENV_ROOT}" ]; then \
	  export PATH="${RBENV_ROOT}/bin:${PATH}";\
	  eval "$(rbenv init -)";\
	fi;\
	rbenv global 2.5.0;\
	rbenv rehash;\
	mkdir -p ${HOME}/src/github.com/masasam/myapp;\
	cd ${HOME}/src/github.com/masasam/myapp;\
	rbenv local 2.5.0;\
	bundle init;\
	echo "gem 'rails', '~> 5.2.0.rc2'" >> Gemfile;\
	bundle install --path vendor/bundle;\
	bundle exec rails new -B --webpack=react --database=mysql --skip-test .;\
	bundle install;\
	bundle exec rails webpacker:install;\
	cd -

zoom: ## Install zoom for web conference
	sudo pacman -U ${HOME}/Dropbox/arch/zoom_x86_64.pkg.tar.xz

screenkey: ## Init screenkey
	yaourt -S screenkey
	mkdir -p ${HOME}/.config
	ln -vsf ${PWD}/.config/screenkey.json ${HOME}/.config/screenkey.json

aur: ## Install arch linux AUR packages using yaourt
	yaourt -S drone-cli
	yaourt -S git-secrets
	yaourt -S nkf
	yaourt -S peek

gnuglobal: ## Install gnu global
	mkdir -p ${HOME}/.local
	pip install --user pygments
	yaourt -S global

backup: ## Backup arch linux packages
	mkdir -p ${PWD}/archlinux
	pacman -Qqen > ${PWD}/archlinux/pacmanlist
	pacman -Qnq > ${PWD}/archlinux/allpacmanlist
	pacman -Qqem > ${PWD}/archlinux/yaourtlist

recover: ## Recover arch linux packages from backup
	sudo pacman -S --needed `cat ${PWD}/archlinux/pacmanlist`
	yaourt -S --needed $(DOY) `cat ${PWD}/archlinux/yaourtlist`

neovim: ## Init neovim
	sudo pacman -S neovim
	mkdir -p ${HOME}/.config/nvim
	ln -vsf ${PWD}/.config/nvim/init.vim   ${HOME}/.config/nvim/init.vim
	ln -vsf ${PWD}/.config/nvim/installer.sh   ${HOME}/.config/nvim/installer.sh
	bash ${HOME}/.config/nvim/installer.sh ${HOME}/.config/nvim

varnish: ## Varnish inital setup
	sudo pacman -S varnish
	sudo ln -vsf ${PWD}/etc/varnish/default.vcl   /etc/varnish/default.vcl
	sudo systemctl enable varnish.service
	sudo systemctl start varnish.service

mongodb: ## Mongodb initial setup
	sudo pacman -S mongodb mongodb-tools
	sudo systemctl enable mongodb.service
	sudo systemctl start mongodb.service

powertop: ## Powertop initial setup (Warning take a long time)
	sudo pacman -S powertop
	sudo ln -vsf ${PWD}/etc/systemd/system/powertop.service   /etc/systemd/system/powertop.service
	sudo powertop --calibrate
	sudo systemctl enable powertop

gnupg: ## Import gnupg secret-key
	gpg --allow-secret-key-import --import ${HOME}/Dropbox/passwd/privkey.asc

aws: ## Init aws cli
	pip install --user awscli
	test -L ${HOME}/.aws || rm -rf ${HOME}/.aws
	ln -vsfn ${HOME}/Dropbox/zsh/.aws   ${HOME}/.aws

kubernetes: ## Init kubernetes 
	yaourt -S google-cloud-sdk
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

kubernetes-portforward-mariadb: ## Portforward for mariadb
	kubectl port-forward mysql-podname 3306:3306

kubernetes-mysql-dump: ## Kubernetes-portforward-mariadb next to command
	mysqldump -u root -p -h 127.0.0.1 dbname > mariadbdump

kubernetes-portforward-postgres: ## Portforward for postgres
	kubectl port-forward postgres-potname 5432:5432

kubernetes-postgres-dmup: ## Kubernetes-portforward-postgres next to command
	pg_dump -U root -h localhost dbname > pgdump

melpaupdate: ## Update emacs packages and backup 6 generations packages
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
	rm -rf ${HOME}/.emacs.d/.cask; caskinstall

pipbackup: ## Backup python packages
	mkdir -p ${PWD}/archlinux
	pip freeze > ${PWD}/archlinux/requirements.txt

piprecover: ## Recover python packages
	mkdir -p ${PWD}/archlinux
	pip install --user -r ${PWD}/archlinux/requirements.txt

pipupdate: ## Update python packages
	pip-review --user | cut -d = -f 1 | xargs pip install -U --user

rustupdate: ## Update rust packages
	cargo install-update -a

nodenv: ## Install nodenv node-build
	yaourt -S nodenv
	git clone https://github.com/nodenv/node-build.git ${HOME}/.nodenv/plugins/node-build

test: ## Test this Makefile using docker
	docker build -t dotfiles ${PWD}
	docker run -v /home/${USER}/Dropbox:${HOME}/Dropbox:cached --name makefiletest -d dotfiles
	@echo "========== make install =========="
	docker exec makefiletest sh -c "cd ${PWD}; make install"
	@echo "========== make init =========="
	docker exec makefiletest sh -c "cd ${PWD}; make init"
	@echo "========== make initdropbox =========="
	docker exec makefiletest sh -c "cd ${PWD}; make initdropbox"
	@echo "========== make neomutt =========="
	docker exec makefiletest sh -c "cd ${PWD}; make neomutt"
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
	@echo "========== make rustinstall =========="
	docker exec makefiletest sh -c "cd ${PWD}; make rustinstall"

testsimple: ## Test this Makefile using docker without Dropbox
	docker build -t dotfiles ${PWD}
	docker run --name makefiletest -d dotfiles
	@echo "========== make install =========="
	docker exec makefiletest sh -c "cd ${PWD}; make install"
	@echo "========== make init =========="
	docker exec makefiletest sh -c "cd ${PWD}; make init"
	@echo "========== make neomutt =========="
	docker exec makefiletest sh -c "cd ${PWD}; make neomutt"
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
	@echo "========== make rustinstall =========="
	docker exec makefiletest sh -c "cd ${PWD}; make rustinstall"

testpath: # Echo PATH
	PATH=$$PATH
	@echo $$PATH
	GOPATH=$$GOPATH
	@echo $$GOPATH

update: ## Update arch linux packages and save packages cache 3 generations
	yaourt -Syua; paccache -ruk0

allinit: init initdropbox

allinstall: ttf-cica install pipinstall goinstall melpa aur mozc neomutt docker mariadb neovim redis rustinstall nodeinstall screenkey dnsmasq

allupdate: update melpaupdate pipupdate rustupdate goinstall

allbackup: backup pipbackup

.PHONY: allinit allinstall allupdate allbackup

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
	| sort \
	| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.DEFAULT_GOAL := help
