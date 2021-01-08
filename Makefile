export PATH := ${HOME}/.local/bin:${HOME}/.node_modules/bin:${HOME}/.cargo/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/bin/core_perl:${HOME}/bin:${HOME}/google-cloud-sdk/bin
export GOPATH := ${HOME}

rclone: ## Init rclone
	sudo pacman -S rclone
	chmod 600 ${PWD}/.config/rclone/rclone.conf
	test -L ${HOME}/.config/rclone || rm -rf ${HOME}/.config/rclone
	ln -vsfn ${PWD}/.config/rclone ${HOME}/.config/rclone

gnupg: ## Deploy gnupg (Run after rclone)
	sudo pacman -S git-crypt gnupg
	mkdir -p ${HOME}/.gnupg
	ln -vsf ${PWD}/.gnupg/gpg-agent.conf ${HOME}/.gnupg/gpg-agent.conf

ssh: ## Init ssh
	sudo pacman -S openssh
	mkdir -p ${HOME}/.ssh
	ln -vsf ${PWD}/.ssh/config ${HOME}/.ssh/config
	ln -vsf ${PWD}/.ssh/known_hosts ${HOME}/.ssh/known_hosts
	chmod 600 ${HOME}/.ssh/id_rsa

init: ## Initial deploy dotfiles
	test -L ${HOME}/.emacs.d || rm -rf ${HOME}/.emacs.d
	ln -vsfn ${PWD}/.emacs.d ${HOME}/.emacs.d
	ln -vsf ${PWD}/.lesskey ${HOME}/.lesskey
	lesskey
	ln -vsf ${PWD}/.zshrc ${HOME}/.zshrc
	ln -vsf ${PWD}/.vimrc ${HOME}/.vimrc
	ln -vsf ${PWD}/.bashrc ${HOME}/.bashrc
	ln -vsf ${PWD}/.npmrc ${HOME}/.npmrc
	ln -vsf ${PWD}/.myclirc ${HOME}/.myclirc
	ln -vsf ${PWD}/.tmux.conf ${HOME}/.tmux.conf
	ln -vsf ${PWD}/.screenrc ${HOME}/.screenrc
	ln -vsf ${PWD}/.aspell.conf ${HOME}/.aspell.conf
	ln -vsf ${PWD}/.gitconfig ${HOME}/.gitconfig
	mkdir -p ${HOME}/.config/mpv
	ln -vsf ${PWD}/.config/mpv/mpv.conf ${HOME}/.config/mpv/mpv.conf
	ln -vsf ${PWD}/.netrc ${HOME}/.netrc
	ln -vsf ${PWD}/.authinfo ${HOME}/.authinfo
	ln -vsf ${PWD}/.config/hub ${HOME}/.config/hub
	sudo ln -vsf ${PWD}/etc/hosts /etc/hosts

base: ## Install base and base-devel package
	sudo pacman -S filesystem gcc-libs glibc bash coreutils file findutils gawk \
	grep procps-ng sed tar gettext pciutils psmisc shadow util-linux bzip2 gzip \
	xz licenses pacman systemd systemd-sysvcompat iputils iproute2 autoconf sudo \
	automake binutils bison fakeroot flex gcc groff libtool m4 make patch pkgconf \
	texinfo which

install: ## Install arch linux packages using pacman
	sudo pacman -S base go zsh git vim tmux keychain evince unrar hugo ethtool \
	zsh-completions xsel emacs gvfs-smb unace iperf valgrind noto-fonts-emoji \
	inkscape file-roller xclip atool debootstrap oath-toolkit imagemagick lynx \
	the_silver_searcher cifs-utils elinks flameshot ruby-rdoc ipcalc traceroute \
	cups-pdf firefox firefox-i18n-ja gimp strace lhasa hub bookworm tig sysprof \
	pkgfile dconf-editor rsync nodejs debian-archive-keyring gauche cpio aria2 \
	nmap poppler-data ffmpeg asciidoc sbcl aspell aspell-en screen mosh diskus \
	gdb wmctrl pwgen linux-docs htop tcpdump gvfs p7zip lzop fzf gpaste optipng \
	arch-install-scripts pandoc jq pkgstats ruby highlight alsa-utils geckodriver \
	texlive-langjapanese tokei texlive-latexextra ctags hdparm eog curl parallel \
	arc-gtk-theme npm typescript llvm llvm-libs lldb tree w3m whois qreator pass \
	zsh-syntax-highlighting shellcheck bash-completion mathjax expect obs-studio \
	cscope postgresql-libs pdfgrep gnu-netcat cmatrix jpegoptim nethogs mlocate \
	pacman-contrib x11-ssh-askpass libreoffice-fresh-ja python-prompt_toolkit \
	jhead peek ncdu gnome-screenshot sshfs fping syncthing terraform bat lshw \
	xdotool sshuttle packer ripgrep stunnel vimiv adapta-gtk-theme gnome-tweaks \
	firejail opencv hexedit discord pv smartmontools gnome-logs wireshark-cli \
	wl-clipboard lsof mapnik browserpass-chromium editorconfig-core-c watchexec \
	mpv browserpass-firefox man-db baobab ioping ruby-irb mkcert code findomain \
	guetzli openvpn fabric gtop gopls convmv
	sudo pkgfile --update

pipinstall: ## Install python packages
	mkdir -p ${HOME}/.local
	curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
	python ${PWD}/get-pip.py --user
	sudo ln -vsf ${PWD}/usr/share/zsh/site-functions/_pipenv /usr/share/zsh/site-functions/_pipenv
	pip install --user --upgrade pip
	pip install --user ansible
	pip install --user ansible-lint
	pip install --user autopep8
	pip install --user black
	pip install --user cheat
	pip install --user chromedriver-binary
	pip install --user diagrams
	pip install --user django
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
	pip install --user neovim
	pip install --user nose
	pip install --user pandas
	pip install --user pipenv
	pip install --user poetry
	pip install --user progressbar2
	pip install --user psycopg2-binary
	pip install --user py-spy
	pip install --user pydoc_utils
	pip install --user pyflakes
	pip install --user pylint
	pip install --user python-language-server
	pip install --user r7insight_python
	pip install --user redis
	pip install --user requests_mock
	pip install --user rope
	pip install --user rtv
	pip install --user scipy
	pip install --user scrapy
	pip install --user seaborn
	pip install --user selenium
	pip install --user speedtest-cli
	pip install --user streamlink
	pip install --user tldr
	pip install --user trash-cli
	pip install --user truffleHog
	pip install --user virtualenv
	pip install --user virtualenvwrapper
	pip install --user yapf
	rm -fr get-pip.py

goinstall: ## Install go packages
	mkdir -p ${HOME}/{bin,src}
	GO111MODULE=on go get golang.org/x/tools/gopls@latest
	GO111MODULE="on" go get -u -v golang.org/x/tools/cmd/goimports
	go get -u -v github.com/golang/dep/cmd/dep
	GO111MODULE="on" go get -u -v github.com/x-motemen/ghq
	go get -u -v github.com/kyoshidajp/ghkw
	go get -u -v github.com/simeji/jid/cmd/jid
	go get -u -v github.com/jmhodges/jsonpp
	GO111MODULE="on" go get -u -v github.com/mithrandie/csvq

nodeinstall: ## Install node packages
	sudo pacman -S yarn
	mkdir -p ${HOME}/.node_modules
	yarn global add babel-eslint
	yarn global add bash-language-server
	yarn global add cloc
	yarn global add create-component-app
	yarn global add create-nuxt-app
	yarn global add create-react-app
	yarn global add dockerfile-language-server-nodejs
	yarn global add esbuild-linux-64
	yarn global add eslint
	yarn global add eslint-cli
	yarn global add eslint-config-vue
	yarn global add eslint-plugin-react
	yarn global add eslint-plugin-vue@next
	yarn global add expo-cli
	yarn global add firebase-tools
	yarn global add fx
	yarn global add gulp
	yarn global add	gulp-cli
	yarn global add heroku
	yarn global add indium
	yarn global add intelephense
	yarn global add javascript-typescript-langserver
	yarn global add jshint
	yarn global add logo.svg
	yarn global add @marp-team/marp-cli
	yarn global add mermaid
	yarn global add mermaid.cli
	yarn global add netlify-cli
	yarn global add ngrok
	yarn global add now
	yarn global add prettier
	yarn global add parcel-bundler
	yarn global add typescript-language-server
	yarn global add @vue/cli
	yarn global add vue-language-server
	yarn global add vue-native-cli
	yarn global add webpack

rustinstall: ## Install rust and rust language server
	sudo pacman -S rustup
	rustup default stable
	rustup component add rls rust-analysis rust-src

neomutt: ## Init neomutt mail client
	sudo pacman -S neomutt
	mkdir -p ${HOME}/.mutt
	ln -vsf ${PWD}/.muttrc ${HOME}/.muttrc
	ln -vsf ${PWD}/.mutt/mailcap ${HOME}/.mutt/mailcap
	ln -vsf ${PWD}/.mutt/certificates ${HOME}/.mutt/certificates
	ln -vsf ${PWD}/.mutt/aliases ${HOME}/.mutt/aliases
	ln -vsf ${PWD}/.mutt/signature ${HOME}/.mutt/signature
	ln -vsf ${PWD}/.goobookrc ${HOME}/.goobookrc
	yay -S goobook-git
	goobook authenticate

alacritty: ## Init alacritty
	sudo pacman -S alacritty
	test -L ${HOME}/.config/alacritty/alacritty.yml || rm -rf ${HOME}/.config/alacritty/alacritty.yml
	ln -vsf ${PWD}/.config/alacritty/alacritty.yml ${HOME}/.config/alacritty/alacritty.yml

urxvt: ## Init rxvt-unicode terminal
	sudo pacman -S rxvt-unicode urxvt-perls
	ln -vsf ${PWD}/.Xresources ${HOME}/.Xresources
	sudo ln -vsf ${PWD}/usr/share/applications/urxvt.desktop /usr/share/applications/urxvt.desktop
	sudo ln -vsf ${PWD}/usr/share/applications/urxvtc.desktop /usr/share/applications/urxvtc.desktop
	sudo ln -vsf ${PWD}/usr/share/applications/urxvt-tabbed.desktop /usr/share/applications/urxvt-tabbed.desktop
	mkdir -p ${HOME}/.config/autostart
	chmod a+x ${PWD}/.auto_start.sh
	ln -vsf ${PWD}/.auto_start.sh ${HOME}/.auto_start.sh
	ln -vsf ${PWD}/.config/autostart/autostart.desktop ${HOME}/.config/autostart/autostart.desktop

xterm: ## Init xterm terminal
	sudo pacman -S xterm
	ln -vsf ${PWD}/.Xresources ${HOME}/.Xresources
	sudo ln -vsf ${PWD}/usr/share/applications/xterm.desktop /usr/share/applications/xterm.desktop
	sudo ln -vsf ${PWD}/usr/share/applications/uxterm.desktop /usr/share/applications/uxterm.desktop

mlterm: ## Init mlterm terminal
	yay -S mlterm
	mkdir -p ${HOME}/.mlterm
	ln -vsf ${PWD}/.mlterm/main ${HOME}/.mlterm/main
	ln -vsf ${PWD}/.mlterm/color ${HOME}/.mlterm/color
	ln -vsf ${PWD}/.mlterm/aafont ${HOME}/.mlterm/aafont
	ln -vsf ${PWD}/.mlterm/key ${HOME}/.mlterm/key
	sudo ln -vsf ${PWD}/usr/share/applications/mlterm.desktop /usr/share/applications/mlterm.desktop
	sudo ln -vsf ${PWD}/usr/share/applications/mlclient.desktop /usr/share/applications/mlclient.desktop

termite: ## Init termite terminal
	sudo pacman -S termite
	mkdir -p ${HOME}/.config/termite
	ln -vsf ${PWD}/.config/termite/config ${HOME}/.config/termite/config

dnsmasq: ## Init dnsmasq
	sudo pacman -S dnsmasq
	sudo ln -vsf ${PWD}/etc/dnsmasq/resolv.dnsmasq.conf /etc/resolv.dnsmasq.conf
	sudo ln -vsf ${PWD}/etc/dnsmasq/dnsmasq.conf /etc/dnsmasq.conf
	sudo mkdir -p /etc/NetworkManager
	sudo ln -vsf ${PWD}/etc/NetworkManager/NetworkManager.conf /etc/NetworkManager/NetworkManager.conf

tlp: ## Setting for power saving and preventing battery deterioration
	sudo pacman -S tlp powertop
	sudo ln -vsf ${PWD}/etc/default/tlp /etc/default/tlp
	systemctl enable tlp.service
	systemctl enable tlp-sleep.service

lvfs: ## For Linux Vendor Firmware Service
	sudo pacman -S fwupd dmidecode
	sudo dmidecode -s bios-version

uefiupdate: ## Update system firmware and uefi
	fwupdmgr refresh
	fwupdmgr get-updates
	fwupdmgr update

thinkpad: ## Workaround for Intel throttling issues in Linux
	sudo pacman -S throttled
	sudo systemctl enable --now lenovo_fix.service

keyring: ## Init gnome keyrings
	sudo pacman -S seahorse
	mkdir -p ${HOME}/.local/share
	test -L ${HOME}/.local/share/keyrings || rm -rf ${HOME}/.local/share/keyrings
	ln -vsfn ${HOME}/backup/keyrings ${HOME}/.local/share/keyrings

ibusmozc: ## Install ibus-mozc
	test -L ${HOME}/.mozc || rm -rf ${HOME}/.mozc
	ln -vsfn ${HOME}/backup/mozc ${HOME}/.mozc
	mkdir -p ${HOME}/.config/autostart
	ln -vsf ${PWD}/.config/autostart/ibus.desktop ${HOME}/.config/autostart/ibus.desktop
	yay -S ibus-mozc
	ibus-daemon -drx

ttf-cica: ## Install Cica font
	yay -S ttf-cica

localhostssl: # Set ssl for localhost
	mkcert -install
	mkcert localhost

docker: ## Docker initial setup
	sudo pacman -S docker
	sudo usermod -aG docker ${USER}
	mkdir -p ${HOME}/.docker
	ln -vsf ${PWD}/.docker/config.json ${HOME}/.docker/config.json
	sudo systemctl enable docker.service
	sudo systemctl start docker.service

podman: ## Podman initial setup
	sudo pacman -S podman
	sudo systemctl enable io.podman.service
	sudo systemctl start io.podman.service

php: ## Init php setting
	sudo pacman -S php php-intl
	sudo ln -vsf ${PWD}/etc/php/php.ini /etc/php/php.ini

circle-ci-cli: ## Install circle ci cli and setup
	curl -fLSs https://circle.ci/cli | sudo bash
	circleci update install

maria-db: ## Mariadb initial setup
	sudo ln -vsf ${PWD}/etc/sysctl.d/40-max-user-watches.conf /etc/sysctl.d/40-max-user-watches.conf
	sudo pacman -S mariadb mariadb-clients
	sudo ln -vsf ${PWD}/etc/my.cnf /etc/my.cnf
	sudo mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
	sudo systemctl start mariadb.service
	sudo mysql -u root < ${PWD}/mariadb/init.sql
	mysql_secure_installation
	mysql_tzinfo_to_sql /usr/share/zoneinfo | mysql -u root mysql

mysql57: ## MySQL initial setup
	sudo ln -vsf ${PWD}/etc/sysctl.d/40-max-user-watches.conf /etc/sysctl.d/40-max-user-watches.conf
	yay -S mysql57
	sudo ln -vsf ${PWD}/etc/my.cnf /etc/mysql/my.cnf
	sudo mysqld --initialize --user=mysql --basedir=/usr --datadir=/var/lib/mysql
	sudo systemctl start mysqld.service
	mysql_secure_installation
	mysql_tzinfo_to_sql /usr/share/zoneinfo | mysql -u root mysql

postgresql: ## PostgreSQL initial setup
	sudo pacman -S postgresql
	cd /home;\
	sudo -u postgres initdb -E UTF8 --no-locale -D '/var/lib/postgres/data'
	sudo systemctl start postgresql.service
	cd /home;\
	sudo -u postgres createuser --interactive

remotedesktop: ## Install remotedesktop
	sudo pacman -S remmina freerdp libvncserver

eralchemy: ## Install eralchemy
	sudo pacman -S graphviz
	pip install --user eralchemy

mycli: ## Init mycli
	mkdir -p ${HOME}/backup/mycli
	pip install --user mycli
	ln -vsf ${HOME}/backup/mycli/.mycli-history ${HOME}/.mycli-history

pgcli: ## Init pgcli
	mkdir -p ${HOME}/backup
	pip install --user pgcli
	test -L ${HOME}/.config/pgcli || rm -rf ${HOME}/.config/pgcli
	ln -vsfn ${HOME}/backup/pgcli ${HOME}/.config/pgcli

gcloud: ## Install google cloud SDK and setting
	sudo pacman -S kubectl kubectx kustomize helm
	curl https://sdk.cloud.google.com | bash
	test -L ${HOME}/.config/gcloud || rm -rf ${HOME}/.config/gcloud
	ln -vsfn ${HOME}/backup/gcloud   ${HOME}/.config/gcloud
	yay -S stern-bin

docker-compose: ## Set up docker-compose
	sudo pacman -S docker-compose
	gcloud components install docker-credential-gcr

minikube: ## Setup minikube with kvm2
	sudo pacman -S minikube libvirt qemu-headless ebtables docker-machine
	yay -S docker-machine-driver-kvm2
	sudo usermod -a -G libvirt ${USER}
	sudo systemctl start libvirtd.service
	sudo systemctl enable libvirtd.service
	sudo systemctl start virtlogd.service
	sudo systemctl enable virtlogd.service
	minikube config set vm-driver kvm2

kind: ## Setup kind (Kubernetes In Docker)
	GO111MODULE="on" go get sigs.k8s.io/kind@v0.9.0
	sudo sh -c "kind completion zsh > /usr/share/zsh/site-functions/_kind"

redis: ## Redis inital setup
	sudo pacman -S redis
	sudo systemctl enable redis.service
	sudo systemctl start redis.service

dingo: ## Install dingo Google DNS over HTTPS
	sudo pacman -S dingo
	sudo systemctl enable dingo.service
	sudo systemctl start dingo.service

ccls: ## Install c,c++ language server
	yay -S ccls

android: ## Install android-studio
	yay -S android-studio

dart: ## Install dart and language server
	sudo pacman -S dart
	pub global activate dart_language_server

flutter: ## Install flutter
	mkdir -p ~/src/github.com/flutter
	cd ~/src/github.com/flutter;\
	wget https://storage.googleapis.com/flutter_infra/releases/stable/linux/flutter_linux_v1.9.1+hotfix.6-stable.tar.xz;\
	tar xf flutter_linux_v1.9.1+hotfix.6-stable.tar.xz

mpsyt: ## Install and deploy mps-youtube
	pip install --user mps-youtube
	pip install --user youtube-dl
	mkdir -p ${HOME}/.config/mps-youtube
	test -L ${HOME}/.config/mps-youtube/playlists || rm -rf ${HOME}/.config/mps-youtube/playlists
	ln -vsfn ${HOME}/backup/youtube/playlists ${HOME}/.config/mps-youtube/playlists

spotify: ## Install spotify
	gpg --keyserver hkp://keyserver.ubuntu.com --receive-keys 931FF8E79F0876134EDDBDCCA87FF9DF48BF1C90
	yay -S spotify

sxiv: ## Init sxiv
	sudo pacman -S sxiv
	mkdir -p ${HOME}/.config/sxiv/exec
	ln -vsf ${PWD}/.config/sxiv/exec/image-info ${HOME}/.config/sxiv/exec/image-info
	chmod +x ${HOME}/.config/sxiv/exec/image-info

zeal: ## Deploy zeal config and docsets
	yay -S zeal
	sudo pacman -S qt5-styleplugins qt5ct
	sudo ln -vsf ${PWD}/etc/environment /etc/environment
	mkdir -p ${HOME}/.config/Zeal
	ln -vsf ${PWD}/.config/Zeal/Zeal.conf ${HOME}/.config/Zeal/Zeal.conf

emacspeak: ## Install emacspeak for blind person
	yay -S emacspeak

yay: ## Install yay using yay
	yay -S yay

aur: ## Install arch linux AUR packages using yay
	yay -S downgrade
	yay -S git-secrets
	yay -S nvm
	yay -S slack-desktop
	yay -S trivy-bin
	yay -S zoom

guidb: ## Install gui database tools
	yay -S beekeeper-studio-bin
	yay -S sequeler-git

gh: ## Install and setup github-cli
	pacman -S github-cli
	test -L ${HOME}/.config/gh || rm -rf ${HOME}/.config/gh
	ln -vsfn ${HOME}/backup/gh ${HOME}/.config/gh

aurplus: ## Install arch linux AUR packages using yay
	yay -S appimagelauncher
	yay -S drone-cli
	yay -S nkf
	yay -S pencil
	yay -S rtags
	yay -S skypeforlinux-stable-bin

terraformer: ## Install terraformer
	curl -LO https://github.com/GoogleCloudPlatform/terraformer/releases/download/`curl -s https://api.github.com/repos/GoogleCloudPlatform/terraformer/releases/latest | grep tag_name | cut -d '"' -f 4`/terraformer-aws-linux-amd64
	chmod +x terraformer-aws-linux-amd64
	sudo mv terraformer-aws-linux-amd64 /usr/local/bin/terraformer

desktop: ## Update desktop entry
	sudo ln -vsf ${PWD}/usr/share/applications/vim.desktop /usr/share/applications/vim.desktop
	sudo ln -vsf ${PWD}/usr/share/applications/xterm.desktop /usr/share/applications/xterm.desktop
	sudo ln -vsf ${PWD}/usr/share/applications/uxterm.desktop /usr/share/applications/uxterm.desktop
	sudo ln -vsf ${PWD}/usr/share/applications/urxvt.desktop /usr/share/applications/urxvt.desktop
	sudo ln -vsf ${PWD}/usr/share/applications/urxvtc.desktop /usr/share/applications/urxvtc.desktop
	sudo ln -vsf ${PWD}/usr/share/applications/urxvt-tabbed.desktop /usr/share/applications/urxvt-tabbed.desktop

toggle: ## Prepare command that toggle between emacs and chromium
	sudo ln -vsf ${PWD}/usr/share/applications/toggle.desktop /usr/share/applications/toggle.desktop
	sudo cp ${PWD}/.toggle.sh /usr/local/bin/toggle

aws: ## Init aws cli
	mkdir -p ${HOME}/.local
	pip install --user awscli
	ln -vsfn ${PWD}/.aws ${HOME}/.aws

tmuxp: ## Install tmuxp
	mkdir -p ${HOME}/.local
	pip install --user tmuxp
	sudo ln -vsf ${PWD}/.config/main.yaml ${HOME}/.config/main.yaml

roswell: ## Install ros and lem
	yay -S roswell
	ros install cxxxr/lem

sylpheed: ## Init sylpheed
	sudo pacman -S sylpheed
	test -L ${HOME}/.sylpheed-2.0 || rm -rf ${HOME}/.sylpheed-2.0
	ln -vsfn ${HOME}/backup/sylpheed/.sylpheed-2.0 ${HOME}/.sylpheed-2.0

psd: ## Profile-Sync-Daemon initial setup
	yay -S profile-sync-daemon
	mkdir -p ${HOME}/.config/psd
	ln -vsf ${PWD}/.config/psd/psd.conf ${HOME}/.config/psd/psd.conf
	echo "${USER} ALL=(ALL) NOPASSWD: /usr/bin/psd-overlay-helper" | sudo EDITOR='tee -a' visudo
	systemctl --user enable psd.service

chromium: ## Install chromium and noto-fonts
	sudo pacman -S noto-fonts noto-fonts-cjk
	sudo pacman -S chromium

neovim: ## Init neovim
	sudo pacman -S neovim
	mkdir -p ${HOME}/.config/nvim
	ln -vsf ${PWD}/.config/nvim/init.vim ${HOME}/.config/nvim/init.vim
	ln -vsf ${PWD}/.config/nvim/installer.sh ${HOME}/.config/nvim/installer.sh
	bash ${HOME}/.config/nvim/installer.sh ${HOME}/.config/nvim
	sudo ln -vsf ${PWD}/usr/share/applications/nvim.desktop /usr/share/applications/nvim.desktop

varnish: ## Varnish inital setup
	sudo pacman -S varnish
	sudo ln -vsf ${PWD}/etc/varnish/default.vcl /etc/varnish/default.vcl
	sudo systemctl enable varnish.service
	sudo systemctl start varnish.service

mongodb: ## Mongodb initial setup
	sudo pacman -S mongodb mongodb-tools
	sudo systemctl enable mongodb.service
	sudo systemctl start mongodb.service

gnuglobal: ## Install gnu global
	mkdir -p ${HOME}/.local
	pip install --user pygments
	yay -S global

elixir-ls: ## Install elixir-ls(Recompile if the version of elixir changes)
	sudo pacman -S elixir
	mkdir -p ${HOME}/src/github.com/JakeBecker
	cd ${HOME}/src/github.com/JakeBecker;\
	git clone git@github.com:JakeBecker/elixir-ls.git;\
	cd elixir-ls && mkdir rel;\
	mix deps.get && mix compile;\
	mix elixir_ls.release -o rel

emacs-devel: ## Install development version of emacs
	cd ${HOME}/src/github.com/masasam;\
	git clone -b emacs-27 git@github.com:emacs-mirror/emacs.git;\
	cd emacs;\
	./autogen.sh;\
	./configure;\
	make;\
	sudo make install;\
	rm -rf ${HOME}/.emacs.d/elpa

screenkey: ## Init screenkey
	yay -S screenkey
	mkdir -p ${HOME}/.config
	ln -vsf ${PWD}/.config/screenkey.json ${HOME}/.config/screenkey.json

rbenv: ## Install rvenv ruby-build
	yay -S rbenv
	yay -S ruby-build
	rbenv install 2.7.2
	rbenv rehash
	gem install bundle

rubygem: ## Install rubygem package
	gem install bundler jekyll sass compass solargraph rawler rdoc irb rails

django: ## Install Django
	mkdir -p ${HOME}/src/github.com/masasam/mydjango;\
	cd ${HOME}/src/github.com/masasam/mydjango;\
	touch Pipfile;\
	pipenv --python=3.8.6;\
	pipenv install django;\
	pipenv run django-admin startproject config .

rails: ## Create rails from scratch
	export RBENV_ROOT="${HOME}/.rbenv";\
	if [ -d "${RBENV_ROOT}" ]; then \
	  export PATH="${RBENV_ROOT}/bin:${PATH}";\
	  eval "$(rbenv init -)";\
	fi;\
	rbenv global 2.7.2;\
	rbenv rehash;\
	mkdir -p ${HOME}/src/github.com/masasam/rails;\
	cd ${HOME}/src/github.com/masasam/rails;\
	rbenv local 2.7.2;\
	bundle init;\
	echo "gem 'rails', '~> 6.0.3.3'" >> Gemfile;\
	bundle install --path vendor/bundle;\
	bundle exec rails new . --database=mysql --skip-test --skip-turbolinks;\
	bundle exec rails webpacker:install;\
	cd -

tym: ## Init tym terminal
	yay -S tym
	mkdir -p ${HOME}/.config/tym
	ln -vsf ${PWD}/.config/tym/config.lua ${HOME}/.config/tym/config.lua
	sudo ln -vsf ${PWD}/usr/share/applications/tym.desktop /usr/share/applications/tym.desktop

backup: ## Backup arch linux packages
	mkdir -p ${PWD}/archlinux
	pacman -Qnq > ${PWD}/archlinux/pacmanlist
	pacman -Qqem > ${PWD}/archlinux/aurlist

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

mysite: ## My site and blogs source(This is private repository)
	ghq get -p masasam/solist
	ghq get -p masasam/solistblog
	ghq get -p masasam/PPAP

testbackup: ## Test this Makefile with mount backup directory
	docker build -t dotfiles ${PWD}
	docker run -it --name maketestbackup -v /home/${USER}/backup:${HOME}/backup:cached --name makefiletest -d dotfiles:latest /bin/bash;\
	docker exec -it maketestbackup sh -c "cd ${PWD}; make install";\
	docker exec -it maketestbackup sh -c "cd ${PWD}; make init";\
	docker exec -it maketestbackup sh -c "cd ${PWD}; make neomutt";\
	docker exec -it maketestbackup sh -c "cd ${PWD}; make aur";\
	docker exec -it maketestbackup sh -c "cd ${PWD}; make pipinstall";\
	docker exec -it maketestbackup sh -c "cd ${PWD}; make goinstall";\
	docker exec -it maketestbackup sh -c "cd ${PWD}; make nodeinstall"

test: ## Test this Makefile with docker without backup directory
	docker build -t dotfiles ${PWD};\
	docker run -it --name maketest -d dotfiles:latest /bin/bash;\
	docker exec -it maketest sh -c "cd ${PWD}; make install";\
	docker exec -it maketest sh -c "cd ${PWD}; make init";\
	docker exec -it maketest sh -c "cd ${PWD}; make neomutt";\
	docker exec -it maketest sh -c "cd ${PWD}; make aur";\
	docker exec -it maketest sh -c "cd ${PWD}; make pipinstall";\
	docker exec -it maketest sh -c "cd ${PWD}; make goinstall";\
	docker exec -it maketest sh -c "cd ${PWD}; make nodeinstall"

testpath: ## Echo PATH
	PATH=$$PATH
	@echo $$PATH
	GOPATH=$$GOPATH
	@echo $$GOPATH

allinstall: rclone gnupg ssh install init keyring urxvt xterm termite yay tlp thinkpad ttf-cica dnsmasq pipinstall goinstall ibusmozc neomutt docker nodeinstall zeal sylpheed lvfs gcloud docker-compose aws toggle aur guidb kind eralchemy mpsyt gh

nextinstall: chromium rubygem rbenv rustinstall postgresql maria-db mycli pgcli

allupdate: update pipupdate rustupdate goinstall yarnupdate

allbackup: backup pipbackup

.PHONY: allinstall nextinstall allupdate allbackup

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
	| sort \
	| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.DEFAULT_GOAL := help
