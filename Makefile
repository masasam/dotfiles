export PATH := ${HOME}/.local/bin:${HOME}/.node_modules/bin:${HOME}/.cargo/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/bin/core_perl:${HOME}/bin
export GOPATH := ${HOME}

init: ## Initial deploy dotfiles
	test -L ${HOME}/.emacs.d || rm -rf ${HOME}/.emacs.d
	ln -vsfn ${PWD}/.emacs.d   ${HOME}/.emacs.d
	ln -vsf ${PWD}/.lesskey   ${HOME}/.lesskey
	lesskey
	ln -vsf ${PWD}/.zshrc   ${HOME}/.zshrc
	ln -vsf ${PWD}/.vimrc   ${HOME}/.vimrc
	ln -vsf ${PWD}/.bashrc   ${HOME}/.bashrc
	ln -vsf ${PWD}/.npmrc   ${HOME}/.npmrc
	ln -vsf ${PWD}/.myclirc   ${HOME}/.myclirc
	ln -vsf ${PWD}/.tern-config   ${HOME}/.tern-config
	ln -vsf ${PWD}/.tmux.conf   ${HOME}/.tmux.conf
	ln -vsf ${PWD}/.screenrc   ${HOME}/.screenrc
	ln -vsf ${PWD}/.aspell.conf   ${HOME}/.aspell.conf
	ln -vsf ${PWD}/.gitconfig   ${HOME}/.gitconfig

rclone: ## Init rclone
	sudo pacman -S rclone
	chmod 600   ${HOME}/Dropbox/zsh/rclone/rclone.conf
	test -L ${HOME}/.config/rclone || rm -rf ${HOME}/.config/rclone
	ln -vsfn ${HOME}/Dropbox/zsh/rclone   ${HOME}/.config/rclone

initdropbox: ## Initial deploy dotfiles using dropbox
	sudo ln -vsf ${HOME}/Dropbox/arch/hosts   /etc/hosts
	mkdir -p ${HOME}/.config
	ln -vsf ${HOME}/Dropbox/zsh/.netrc   ${HOME}/.netrc
	ln -vsf ${HOME}/Dropbox/zsh/.authinfo   ${HOME}/.authinfo
	ln -vsf ${HOME}/Dropbox/zsh/.mycli-history   ${HOME}/.mycli-history
	ln -vsf ${HOME}/Dropbox/zsh/hub   ${HOME}/.config/hub
	test -L ${HOME}/.ssh || rm -rf ${HOME}/.ssh
	ln -vsfn ${HOME}/Dropbox/ssh   ${HOME}/.ssh
	chmod 600   ${HOME}/.ssh/id_rsa
	mkdir -p ${HOME}/.local/share
	test -L ${HOME}/.local/share/keyrings || rm -rf ${HOME}/.local/share/keyrings
	ln -vsfn ${HOME}/Dropbox/passwd/keyrings   ${HOME}/.local/share/keyrings

base: ## Install base and base-devel package
	sudo pacman -S bash bzip2 coreutils cryptsetup device-mapper dhcpcd mdadm \
	file filesystem findutils gawk gcc-libs gettext glibc grep gzip inetutils \
	iproute2 iputils jfsutils less licenses linux logrotate lvm2 man-db sudo \
	nano netctl pacman pciutils perl procps-ng psmisc reiserfsprogs s-nail vi \
	make shadow sysfsutils systemd-sysvcompat tar texinfo usbutils util-linux \
	which xfsprogs autoconf automake binutils bison fakeroot flex gcc groff m4 \
	libtool patch pkgconf systemd man-pages diffutils e2fsprogs sed

install: ## Install arch linux packages using pacman
	sudo pacman -S go zsh git vim tmux keychain evince unrar seahorse hugo mpv \
	zsh-completions xsel emacs gvfs-smb unace iperf valgrind noto-fonts-emoji \
	inkscape file-roller xclip atool debootstrap oath-toolkit imagemagick lynx \
	the_silver_searcher cifs-utils elinks flameshot ruby-rdoc ipcalc traceroute \
	cups-pdf openssh firefox firefox-i18n-ja gimp strace lhasa hub bookworm tig \
	pkgfile dconf-editor rsync nodejs debian-archive-keyring gauche cpio nnn \
	nmap poppler-data ffmpeg asciidoc sbcl docker aspell aspell-en screen mosh \
	gdb wmctrl pwgen linux-docs htop tcpdump gvfs p7zip lzop fzf gpaste optipng \
	arch-install-scripts pandoc jq pkgstats ruby highlight alsa-utils geckodriver \
	texlive-langjapanese yarn texlive-latexextra ctags hdparm eog curl parallel \
	arc-gtk-theme npm typescript llvm llvm-libs lldb php tree w3m neomutt whois \
	zsh-syntax-highlighting shellcheck bash-completion mathjax expect elixir lsof \
	cscope postgresql-libs pdfgrep gnu-netcat cmatrix jpegoptim nethogs mlocate \
	pacman-contrib x11-ssh-askpass libreoffice-fresh-ja python-prompt_toolkit \
	jhead peek ncdu sxiv gnome-screenshot sshfs fping syncthing terraform gnupg \
	xdotool sshuttle packer ripgrep stunnel vimiv adapta-gtk-theme gnome-tweaks
	sudo pkgfile --update

pipinstall: ## Install python packages
	mkdir -p ${HOME}/.local
	curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
	python ${PWD}/get-pip.py --user
	pip install --user --upgrade pip
	pip install --user ansible
	pip install --user ansible-lint
	pip install --user autopep8
	pip install --user cheat
	pip install --user docker-compose
	pip install --user faker
	pip install --user flake8
	pip install --user gif-for-cli
	pip install --user graph-cli
	pip install --user httpie
	pip install --user importmagic
	pip install --user ipywidgets
	pip install --user jedi
	pip install --user jupyter
	pip install --user jupyterlab
	pip install --user jupyterthemes
	pip install --user litecli
	pip install --user matplotlib
	pip install --user mycli
	pip install --user neovim
	pip install --user pandas
	pip install --user pgcli
	pip install --user pipenv
	pip install --user progressbar2
	pip install --user pydoc_utils
	pip install --user pyflakes
	pip install --user pylint
	pip install --user python-language-server
	pip install --user redis
	pip install --user rope
	pip install --user rtv
	pip install --user scikit-learn
	pip install --user scipy
	pip install --user scrapy
	pip install --user seaborn
	pip install --user selenium
	pip install --user speedtest-cli
	pip install --user streamlink
	pip install --user tldr
	pip install --user tmuxp
	pip install --user trash-cli
	pip install --user truffleHog
	pip install --user virtualenv
	pip install --user virtualenvwrapper
	pip install --user yapf

goinstall: ## Install go packages
	mkdir -p ${HOME}/{bin,src}
	go get -u -v golang.org/x/tools/cmd/gopls
	go get -u -v github.com/sourcegraph/go-langserver
	go get -u -v github.com/golang/dep/cmd/dep
	go get -u -v github.com/pressly/goose/cmd/goose
	go get -u -v github.com/motemen/ghq
	go get -u -v github.com/sonatard/ghs
	go get -u -v github.com/kyoshidajp/ghkw
	go get -u -v github.com/simeji/jid/cmd/jid
	go get -u -v github.com/jmhodges/jsonpp
	go get -u -v github.com/dinedal/textql...

nodeinstall: ## Install node packages
	mkdir -p ${HOME}/.node_modules
	yarn global add babel-eslint
	yarn global add bash-language-server
	yarn global add cloc
	yarn global add create-component-app
	yarn global add create-nuxt-app
	yarn global add create-react-app
	yarn global add eslint
	yarn global add eslint-cli
	yarn global add eslint-plugin-react
	yarn global add firebase-tools
	yarn global add fx
	yarn global add gulp
	yarn global add	gulp-cli
	yarn global add heroku
	yarn global add indium
	yarn global add javascript-typescript-langserver
	yarn global add jshint
	yarn global add logo.svg
	yarn global add mermaid
	yarn global add mermaid.cli
	yarn global add netlify-cli
	yarn global add ngrok
	yarn global add npm
	yarn global add prettier
	yarn global add tern
	yarn global add vscode-css-languageserver-bin
	yarn global add vue-cli
	yarn global add vue-language-server
	yarn global add webpack

rustinstall: ## Install rust and rust packages
	sudo pacman -S cmake
	mkdir -p ${HOME}/.cargo
	curl -sSf https://sh.rustup.rs | sh
	cargo install cargo-edit
	cargo install cargo-script
	cargo install cargo-update
	cargo install exa
	cargo install fd-find
	cargo install hyperfine
	cargo install skim
	cargo install tztail
	cargo install xsv
	rustup component add rls-preview rust-analysis rust-src

neomutt: ## Init neomutt mail client
	mkdir -p ${HOME}/.mutt
	ln -vsf ${PWD}/.muttrc   ${HOME}/.muttrc
	ln -vsf ${PWD}/.mutt/mailcap   ${HOME}/.mutt/mailcap
	ln -vsf ${PWD}/.mutt/certificates   ${HOME}/.mutt/certificates
	ln -vsf ${HOME}/Dropbox/mutt/aliases   ${HOME}/.mutt/aliases
	ln -vsf ${HOME}/Dropbox/mutt/signature   ${HOME}/.mutt/signature
	ln -vsf ${HOME}/Dropbox/mutt/.goobookrc   ${HOME}/.goobookrc
	yay -S goobook-git
	goobook authenticate

urxvt: ## Init rxvt-unicode terminal
	sudo pacman -S rxvt-unicode urxvt-perls
	ln -vsf ${PWD}/.Xresources   ${HOME}/.Xresources
	sudo ln -vsf ${PWD}/usr/share/applications/urxvt.desktop   /usr/share/applications/urxvt.desktop
	sudo ln -vsf ${PWD}/usr/share/applications/urxvtc.desktop   /usr/share/applications/urxvtc.desktop
	sudo ln -vsf ${PWD}/usr/share/applications/urxvt-tabbed.desktop   /usr/share/applications/urxvt-tabbed.desktop
	mkdir -p ${HOME}/.config/autostart
	chmod a+x ${PWD}/.auto_start.sh
	ln -vsf ${PWD}/.auto_start.sh   ${HOME}/.auto_start.sh
	ln -vsf ${PWD}/.config/autostart/autostart.desktop   ${HOME}/.config/autostart

xterm: ## Init xterm terminal
	sudo pacman -S xterm
	ln -vsf ${PWD}/.Xresources   ${HOME}/.Xresources
	sudo ln -vsf ${PWD}/usr/share/applications/xterm.desktop   /usr/share/applications/xterm.desktop
	sudo ln -vsf ${PWD}/usr/share/applications/uxterm.desktop   /usr/share/applications/uxterm.desktop

mlterm: ## Init mlterm terminal
	yay -S mlterm
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

tym: ## Init tym terminal
	yay -S tym
	mkdir -p ${HOME}/.config/tym
	ln -vsf ${PWD}/.config/tym/config.lua   ${HOME}/.config/tym/config.lua
	sudo ln -vsf ${PWD}/usr/share/applications/tym.desktop   /usr/share/applications/tym.desktop

dnsmasq: ## Init dnsmasq
	sudo pacman -S dnsmasq
	sudo ln -vsf ${PWD}/etc/dnsmasq/resolv.dnsmasq.conf   /etc/resolv.dnsmasq.conf
	sudo ln -vsf ${PWD}/etc/dnsmasq/dnsmasq.conf   /etc/dnsmasq.conf
	sudo mkdir -p /etc/NetworkManager
	sudo ln -vsf ${PWD}/etc/NetworkManager/NetworkManager.conf /etc/NetworkManager/NetworkManager.conf

mozc: ## Install ibus-mozc
	test -L ${HOME}/.mozc || rm -rf ${HOME}/.mozc
	ln -vsfn ${HOME}/Dropbox/mozc/.mozc   ${HOME}/.mozc
	yay -S ibus-mozc
	ibus-daemon -drx

ttf-cica: ## Install Cica font
	cd ${HOME}/Dropbox/arch/Cica-v4.1.1/;\
	sudo install -dm755 /usr/share/fonts/TTF;\
	sudo install -m644 *.ttf /usr/share/fonts/TTF/;\
	sudo install -d /usr/share/licenses/ttf-cica/;\
	sudo install -Dm644 *.txt /usr/share/licenses/ttf-cica/;\
	cd -

docker: ## Docker initial setup
	sudo usermod -aG docker ${USER}
	mkdir -p ${HOME}/.docker
	ln -vsf ${HOME}/Dropbox/docker/config.json   ${HOME}/.docker/config.json
	sudo systemctl enable docker.service
	sudo systemctl start docker.service

podman: ## Podman initial setup
	sudo pacman -S podman
	sudo systemctl enable io.podman.service
	sudo systemctl start io.podman.service

mariadb: ## Mariadb initial setup
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

mew: ## Install mew as mail reader
	cd ~/src;\
	wget https://www.mew.org/Release/mew-6.8.tar.gz;\
	tar zxvf mew-6.8.tar.gz;\
	test -f	mew-6.8.tar.gz && rm -fr mew-6.8.tar.gz;\
	cd mew-6.8;\
	./configure;\
	make;\
	sudo make install;\

dingo: ## Install dingo Google DNS over HTTPS
	sudo pacman -S dingo
	sudo systemctl enable dingo.service
	sudo systemctl start dingo.service

ccls: ## Install c,c++ language server
	yay -S ccls

bingo: ## Install golang language server
	yay -S bingo

mpsyt: ## Install and deploy mps-youtube
	pip install --user mps-youtube
	pip install --user youtube-dl
	test -L ${HOME}/.config/mps-youtube/playlists || rm -rf ${HOME}/.config/mps-youtube/playlists
	ln -vsfn ${HOME}/Dropbox/zsh/mps-youtube/playlists   ${HOME}/.config/mps-youtube/playlists

rbenv: ## Install rvenv ruby-build
	yay -S rbenv
	yay -S ruby-build
	rbenv install 2.5.1
	gem install bundle

rubygem: ## Install rubygem package
	gem install bundler jekyll sass solargraph rawler

django: ## Install Django
	mkdir -p ${HOME}/src/github.com/masasam/mydjango;\
	cd ${HOME}/src/github.com/masasam/mydjango;\
	virtualenv env;\
	source env/bin/activate;\
	pip install --upgrade pip;\
	pip install Django;\
	pip install python-language-server

rails: ## Create rails
	export RBENV_ROOT="${HOME}/.rbenv";\
	if [ -d "${RBENV_ROOT}" ]; then \
	  export PATH="${RBENV_ROOT}/bin:${PATH}";\
	  eval "$(rbenv init -)";\
	fi;\
	rbenv global 2.5.1;\
	rbenv rehash;\
	mkdir -p ${HOME}/src/github.com/masasam/myapp;\
	cd ${HOME}/src/github.com/masasam/myapp;\
	rbenv local 2.5.1;\
	bundle init;\
	echo "gem 'rails', '~> 5.2.0'" >> Gemfile;\
	bundle install --path vendor/bundle;\
	bundle exec rails new -B --webpack=react --database=mysql --skip-test .;\
	bundle install;\
	bundle exec rails webpacker:install;\
	cd -

sxiv: ## Init sxiv
	mkdir -p ${HOME}/.config/sxiv/exec
	ln -vsf ${PWD}/.config/sxiv/exec/image-info   ${HOME}/.config/sxiv/exec/image-info
	chmod +x ${HOME}/.config/sxiv/exec/image-info

zeal: ## Deploy zeal config and docsets
	sudo pacman -S zeal qt5-styleplugins qt5ct
	sudo ln -vsf ${PWD}/etc/environment   /etc/environment
	mkdir -p ${HOME}/.local/share
	mkdir -p ${HOME}/.config/Zeal
	ln -vsf ${PWD}/.config/Zeal/Zeal.conf   ${HOME}/.config/Zeal/Zeal.conf
	test -L ${HOME}/.local/share/Zeal || rm -rf ${HOME}/.local/share/Zeal
	ln -vsfn ${HOME}/Dropbox/Zeal   ${HOME}/.local/share/Zeal

zoom: ## Install zoom for web conference
	sudo pacman -U ${HOME}/Dropbox/arch/zoom_x86_64.pkg.tar.xz

screenkey: ## Init screenkey
	yay -S screenkey
	mkdir -p ${HOME}/.config
	ln -vsf ${PWD}/.config/screenkey.json ${HOME}/.config/screenkey.json

yay: ## Install yay using yay
	yay -S yay

aur: ## Install arch linux AUR packages using yay
	yay -S git-secrets
	yay -S pencil
	yay -S sequeler-git
	yay -S yaourt

aurplus: ## Install arch linux AUR packages using yay
	yay -S discord
	yay -S drone-cli
	yay -S nkf
	yay -S rtags

desktop: ## Update desktop entry
	sudo ln -vsf ${PWD}/usr/share/applications/vim.desktop   /usr/share/applications/vim.desktop
	sudo ln -vsf ${PWD}/usr/share/applications/avahi-discover.desktop   /usr/share/applications/avahi-discover.desktop
	sudo ln -vsf ${PWD}/usr/share/applications/bvnc.desktop   /usr/share/applications/bvnc.desktop
	sudo ln -vsf ${PWD}/usr/share/applications/bssh.desktop   /usr/share/applications/bssh.desktop
	sudo ln -vsf ${PWD}/usr/share/applications/xterm.desktop   /usr/share/applications/xterm.desktop
	sudo ln -vsf ${PWD}/usr/share/applications/uxterm.desktop   /usr/share/applications/uxterm.desktop
	sudo ln -vsf ${PWD}/usr/share/applications/mlterm.desktop   /usr/share/applications/mlterm.desktop
	sudo ln -vsf ${PWD}/usr/share/applications/mlclient.desktop   /usr/share/applications/mlclient.desktop
	sudo ln -vsf ${PWD}/usr/share/applications/urxvt.desktop   /usr/share/applications/urxvt.desktop
	sudo ln -vsf ${PWD}/usr/share/applications/urxvtc.desktop   /usr/share/applications/urxvtc.desktop
	sudo ln -vsf ${PWD}/usr/share/applications/urxvt-tabbed.desktop   /usr/share/applications/urxvt-tabbed.desktop
	sudo ln -vsf ${PWD}/usr/share/applications/nvim.desktop   /usr/share/applications/nvim.desktop

toggle: ## Prepare command that toggle between emacs and chromium
	sudo ln -vsf ${PWD}/usr/share/applications/toggle.desktop   /usr/share/applications/toggle.desktop
	sudo cp ${PWD}/.toggle.sh /usr/local/bin/toggle

aws: ## Init aws cli
	mkdir -p ${HOME}/.local
	pip install --user awscli
	test -L ${HOME}/.aws || rm -rf ${HOME}/.aws
	ln -vsfn ${HOME}/Dropbox/zsh/.aws   ${HOME}/.aws

sk-tmux: ## Init sk-tmux
	chmod a+x /home/masa/Dropbox/zsh/sk-tmux
	sudo ln -vsf ${HOME}/Dropbox/zsh/sk-tmux   /usr/local/bin/sk-tmux

roswell: ## Install ros and lem
	yay -S roswell
	ros install cxxxr/lem

sylpheed: ## Init sylpheed
	sudo pacman -S sylpheed
	test -L ${HOME}/.sylpheed-2.0 || rm -rf ${HOME}/.sylpheed-2.0
	ln -vsfn ${HOME}/Dropbox/sylpheed/.sylpheed-2.0   ${HOME}/.sylpheed-2.0

psd: ## Profile-Sync-Daemon initial setup
	yay -S profile-sync-daemon
	mkdir -p ${HOME}/.config/psd
	ln -vsf ${PWD}/.config/psd/psd.conf   ${HOME}/.config/psd/psd.conf
	echo "${USER} ALL=(ALL) NOPASSWD: /usr/bin/psd-overlay-helper" | sudo EDITOR='tee -a' visudo
	systemctl --user enable psd.service

chromium: ## Install chromium and noto-fonts
	sudo pacman -S noto-fonts noto-fonts-cjk
	sudo pacman -S chromium

ranger: ## Init ranger
	mkdir -p ${HOME}/.local
	pip install --user ranger-fm
	test -L ${HOME}/.config/ranger || rm -rf ${HOME}/.config/ranger
	ln -vsfn ${HOME}/Dropbox/ranger   ${HOME}/.config/ranger

neovim: ## Init neovim
	sudo pacman -S neovim
	mkdir -p ${HOME}/.config/nvim
	ln -vsf ${PWD}/.config/nvim/init.vim   ${HOME}/.config/nvim/init.vim
	ln -vsf ${PWD}/.config/nvim/installer.sh   ${HOME}/.config/nvim/installer.sh
	bash ${HOME}/.config/nvim/installer.sh ${HOME}/.config/nvim
	sudo ln -vsf ${PWD}/usr/share/applications/nvim.desktop   /usr/share/applications/nvim.desktop

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

gnuglobal: ## Install gnu global
	mkdir -p ${HOME}/.local
	pip install --user pygments
	yay -S global

nodenv: ## Install nodenv node-build
	yay -S nodenv
	git clone https://github.com/nodenv/node-build.git ${HOME}/.nodenv/plugins/node-build

wordpress: ## Deploy wordpress
	sudo pacman -S nginx php-fpm
	mkdir -p ${HOME}/src/github.com/masasam
	sudo ln -vsf ${PWD}/etc/nginx/nginx.conf   /etc/nginx/nginx.conf
	sudo ln -vsf ${PWD}/etc/php/php.ini   /etc/php/php.ini
	wget https://ja.wordpress.org/wordpress-latest-ja.tar.gz
	tar zxvf wordpress-latest-ja.tar.gz
	test -f	wordpress-latest-ja.tar.gz && rm -fr wordpress-latest-ja.tar.gz
	test -d /var/www/wp-admin || sudo mv wordpress /var/www
	chmod -R 777 /var/www/wp-content
	sudo ln -vsfn /var/www    ${HOME}/src/github.com/masasam/wordpress
	sudo chown http:http /var/www/wp-admin/includes/file.php  
	echo 'create database wp' | mysql -u root
	echo "grant all privileges on wp.* to wp@localhost identified by 'password';FLUSH PRIVILEGES;" | mysql -u root

emacs-devel: ## Install development version of emacs
	cd ${HOME}/src/github.com/masasam;\
	git clone -b emacs-27 git@github.com:emacs-mirror/emacs.git;\
	cd emacs;\
	./autogen.sh;\
	./configure;\
	make;\
	sudo make install;\
	rm -rf ${HOME}/.emacs.d/elpa

google-cloud: ## Install SDK
	yay -S google-cloud-sdk

kubernetes: ## Init kubernetes 
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

backup: ## Backup arch linux packages
	mkdir -p ${PWD}/archlinux
	pacman -Qqen > ${PWD}/archlinux/pacmanlist
	pacman -Qnq > ${PWD}/archlinux/allpacmanlist
	pacman -Qqem > ${PWD}/archlinux/yaylist

update: ## Update arch linux packages and save packages cache 3 generations
	yay -Syu; paccache -ruk0

pipbackup: ## Backup python packages
	mkdir -p ${PWD}/archlinux
	pip freeze > ${PWD}/archlinux/requirements.txt

piprecover: ## Recover python packages
	mkdir -p ${PWD}/archlinux
	pip install --user -r ${PWD}/archlinux/requirements.txt

pipupdate: ## Update python packages
	pip list --user | cut -d" " -f 1 | tail -n +3 | xargs pip install -U --user

rustupdate: ## Update rust packages
	cargo install-update -a

yarnupdate: ## Update yarn packages
	yarn global upgrade

test: ## Test this Makefile with docker
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

testsimple: ## Test this Makefile with docker without Dropbox
	docker build -t dotfiles ${PWD}
	docker run --name makefiletest -d dotfiles
	@echo "========== make install =========="
	docker exec makefiletest sh -c "cd ${PWD}; make install"
	@echo "========== make init =========="
	docker exec makefiletest sh -c "cd ${PWD}; make init"
	@echo "========== make neomutt =========="
	docker exec makefiletest sh -c "cd ${PWD}; make neomutt"
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

testpath: ## Echo PATH
	PATH=$$PATH
	@echo $$PATH
	GOPATH=$$GOPATH
	@echo $$GOPATH

allinstall: install init initdropbox urxvt xterm termite ttf-cica dnsmasq pipinstall goinstall aur mozc neomutt docker mariadb redis nodeinstall desktop sxiv zeal zoom toggle sylpheed google-cloud aws yay psd mpsyt

nextinstall: chromium screenkey rubygem rbenv rustinstall

allupdate: update pipupdate rustupdate goinstall yarnupdate

allbackup: backup pipbackup

.PHONY: allinstall allupdate allbackup nextinstall

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
	| sort \
	| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.DEFAULT_GOAL := help
