export PATH := ${HOME}/.local/bin:${HOME}/.node_modules/bin:${HOME}/.cargo/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/bin/core_perl:${HOME}/bin:${HOME}/google-cloud-sdk/bin
export GOPATH := ${HOME}

BASE_PKGS	:= filesystem gcc-libs glibc bash coreutils file findutils gawk grep procps-ng sed tar gettext
BASE_PKGS	+= pciutils psmisc shadow util-linux bzip2 gzip xz licenses pacman systemd systemd-sysvcompat 
BASE_PKGS	+= iputils iproute2 autoconf sudo automake binutils bison fakeroot flex gcc groff libtool m4 
BASE_PKGS	+= make patch pkgconf texinfo which archlinux-keyring debugedit

PACKAGES	:= base base-devel go zsh git vim tmux keychain evince unrar hugo ethtool zsh-completions xsel emacs gvfs-smb
PACKAGES	+= unace iperf valgrind noto-fonts-emoji inkscape file-roller xclip atool debootstrap oath-toolkit
PACKAGES	+= imagemagick lynx the_silver_searcher cifs-utils elinks flameshot ruby-rdoc ipcalc traceroute
PACKAGES	+= cups-pdf firefox firefox-i18n-ja gimp strace lhasa hub bookworm tig sysprof pkgfile p7zip
PACKAGES	+= rsync nodejs debian-archive-keyring cpio aria2 nmap poppler-data ffmpeg asciidoc sbcl
PACKAGES	+= aspell aspell-en screen mosh diskus gdb wmctrl pwgen linux-docs htop tcpdump gvfs lzop fzf
PACKAGES	+= gpaste optipng arch-install-scripts pandoc jq pkgstats ruby highlight alsa-utils geckodriver
PACKAGES	+= texlive-langjapanese tokei texlive-latexextra ctags hdparm eog curl parallel npm yq ansible
PACKAGES	+= typescript llvm llvm-libs lldb tree w3m whois csvkit zsh-syntax-highlighting shellcheck
PACKAGES	+= bash-completion mathjax expect obs-studio cscope postgresql-libs pdfgrep gnu-netcat cmatrix btop
PACKAGES	+= jpegoptim nethogs plocate pacman-contrib x11-ssh-askpass libreoffice-fresh-ja tldr streamlink
PACKAGES	+= jhead peek ncdu gnome-screenshot sshfs fping syncthing terraform bat lshw xdotool sshuttle packer 
PACKAGES	+= ripgrep stunnel vimiv adapta-gtk-theme gnome-tweaks firejail opencv hexedit pv perl-net-ip
PACKAGES	+= smartmontools gnome-logs wireshark-cli wl-clipboard lsof mapnik editorconfig-core-c watchexec
PACKAGES	+= gtop gopls convmv mpv man-db baobab ioping ruby-irb mkcert findomain
PACKAGES	+= guetzli fabric detox usleep libvterm bind asunder lame git-lfs hex miller bash-language-server
PACKAGES	+= diffoscope dust rbw eza sslscan abiword pyright miniserve fdupes deno mold fx httpie
PACKAGES	+= gron typescript-language-server dateutils time xsv rust rust-analyzer git-delta zellij jc ruff speedtest-cli
PACKAGES	+= dconf-editor ghq gopls difftastic csvlens cloc eslint prettier trivy sqlitebrowser
PACKAGES	+= gnome-sound-recorder pass gitui yaml-language-server biome papers typst

PIP_PKGS	:= python-pip python-pipenv python-seaborn python-ipywidgets python-jupyter-client
PIP_PKGS	+= python-prompt_toolkit python-faker python-matplotlib python-nose python-pandas
PIP_PKGS	+= python-numpy python-beautifulsoup4

NODE_PKGS	:= mermaid @mermaid-js/mermaid-cli fx intelephense
NODE_PKGS	+= dockerfile-language-server-nodejs netlify-cli ngrok
NODE_PKGS	+= indium logo.svg @marp-team/marp-cli jshint

PACMAN		:= sudo pacman -S 
SYSTEMD_ENABLE	:= sudo systemctl --now enable

.DEFAULT_GOAL := help
.PHONY: all allinstall nextinstall allupdate allbackup

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
	| sort \
	| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

all: allinstall nextinstall allupdate allbackup

${HOME}/.local:
	mkdir -p $<

rclone: ## Init rclone
	$(PACMAN) $@
	chmod 600 ${PWD}/.config/rclone/rclone.conf
	test -L ${HOME}/.config/rclone || rm -rf ${HOME}/.config/rclone
	ln -vsfn ${PWD}/.config/rclone ${HOME}/.config/rclone

gnupg: ## Deploy gnupg (Run after rclone)
	$(PACMAN) $@ git-crypt
	mkdir -p ${HOME}/.$@
	ln -vsf {${PWD},${HOME}}/.$@/gpg-agent.conf

ssh: ## Init ssh
	$(PACMAN) open$@
	mkdir -p ${HOME}/.$@
	chmod 600 ${HOME}/.ssh/id_rsa

init: ## Initial deploy dotfiles
	test -L ${HOME}/.emacs.d || rm -rf ${HOME}/.emacs.d
	ln -vsfn ${PWD}/.emacs.d ${HOME}/.emacs.d
	ln -vsf ${PWD}/.lesskey ${HOME}/.lesskey
	lesskey
	for item in zshrc vimrc bashrc npmrc myclirc tmux.conf screenrc aspell.conf gitconfig netrc authinfo; do
		ln -vsf {${PWD},${HOME}}/.$$item
	done
	mkdir -p ${HOME}/.config/mpv
	ln -vsf {${PWD},${HOME}}/.config/mpv/mpv.conf
	ln -vsf {${PWD},${HOME}}/.config/hub
	sudo ln -vsf {${PWD},}/etc/hosts

base: ## Install base and base-devel package
	$(PACMAN) $(BASE_PKGS)

install: ## Install arch linux packages using pacman
	$(PACMAN) $(PACKAGES)
	$(PACMAN) pkgfile
	sudo pkgfile --update

uv: ## Install uv and setup
	$(PACMAN) uv

rye: ## Install rye and setup
	$(PACMAN) rye
	mkdir ~/.zfunc
	rye self completion -s zsh > ~/.zfunc/_rye

pipinstall: ## Install python packages
	$(PACMAN) $(PIP_PKGS)

goinstall: ${HOME}/.local ## Install go packages
	go install golang.org/x/tools/cmd/goimports@latest
	go install github.com/kyoshidajp/ghkw@latest
	go install github.com/simeji/jid/cmd/jid@latest
	go install github.com/jmhodges/jsonpp@latest
	go install github.com/mithrandie/csvq@latest

mise: ## Setup mise
	$(PACMAN) mise
	mise use -g node
	mise use -g usage
	mise use -g gemini-cli
	mise use -g marp-cli
	mise use -g pnpm

yarninstall: ## Install yarn global packages
	$(PACMAN) yarn
	mkdir -p ${HOME}/.node_modules
	for pkg in $(NODE_PKGS); do yarn global add $$pkg; done

pnpminstall: ## Install pnpm global packages
	$(PACMAN) pnpm
	for pkg in $(NODE_PKGS); do pnpm add -g $$pkg; done

neomutt: ## Init neomutt mail client
	$(PACMAN) neomutt
	mkdir -p ${HOME}/.mutt
	ln -vsf ${PWD}/.muttrc ${HOME}/.muttrc
	for item in mailcap certifcates aliases signature; do ln -vsf {${PWD},${HOME}}/.mutt/$$item; done
	ln -vsf {${PWD},${HOME}}/.goobookrc
	yay -S goobook-git
	goobook authenticate

alacritty: ## Init alacritty
	$(PACMAN) $@
	test -L ${HOME}/.config/$@/$@.toml || rm -rf ${HOME}/.config/$@/$@.toml
	mkdir ${HOME}/.config/$@
	ln -vsf {${PWD},${HOME}}/.config/$@/$@.toml

ghostty: ## Init ghostty
	$(PACMAN) $@
	test -L ${HOME}/.config/$@/config || rm -rf ${HOME}/.config/$@/config
	mkdir ${HOME}/.config/$@
	ln -vsf {${PWD},${HOME}}/.config/$@/config

urxvt: ## Init rxvt-unicode terminal
	$(PACMAN) $@-perls rxvt-unicode
	ln -vsf ${PWD}/.Xresources ${HOME}/.Xresources
	for item in urxvt{,c,-tabbed}; do sudo ln -vsf {${PWD},}/usr/share/applications/$$item.desktop; done
	mkdir -p ${HOME}/.config/autostart
	chmod a+x ${PWD}/.auto_start.sh
	ln -vsf {${PWD},${HOME}}/.auto_start.sh
	ln -vsf ${PWD}/.config/autostart/autostart.desktop ${HOME}/.config/autostart/autostart.desktop

xterm: ## Init xterm terminal
	$(PACMAN) $@
	ln -vsf {${PWD},${HOME}}/.Xresources
	for item in {,u}term; do sudo ln -vsf {${PWD},}/usr/share/applications/$$item.desktop; done

mlterm: ## Init mlterm terminal
	yay -S $@
	mkdir -p ${HOME}/.$@
	for item in main color aafont key; do
		ln -vsf {${PWD},${HOME}}/.$@/$$item
	done
	sudo ln -vsf {${PWD},}/usr/share/applications/$@.desktop
	sudo ln -vsf {${PWD},}/usr/share/applications/mlclient.desktop

termite: ## Init termite terminal
	yay -S $@
	mkdir -p ${HOME}/.config/$@
	ln -vsf {${PWD},${HOME}}/.config/$@/config

wezterm: ## Init wezterm terminal
	$(PACMAN) $@
	mkdir -p ${HOME}/.config/$@
	ln -vsf {${PWD},${HOME}}/.config/$@/$@.lua

zellij: ## Init zellij
	$(PACMAN) $@
	mkdir -p ${HOME}/.config/$@
	ln -vsf {${PWD},${HOME}}/.config/$@/config.kdl

dnsmasq: ## Init dnsmasq
	$(PACMAN) $@
	sudo ln -vsf ${PWD}/etc/$@/resolv.$@.conf /etc/resolv.$@.conf
	sudo ln -vsf ${PWD}/etc/$@/$@.conf /etc/$@.conf
	sudo mkdir -p /etc/NetworkManager
	sudo ln -vsf {${PWD},}/etc/NetworkManager/NetworkManager.conf

tlp: ## Setting for power saving and preventing battery deterioration
	$(PACMAN) $@ powertop
	sudo ln -vsf {${PWD},}/etc/$@.conf
	$(SYSTEMD_ENABLE) $@.service

lvfs: ## For Linux Vendor Firmware Service
	$(PACMAN) fwupd dmidecode
	sudo dmidecode -s bios-version

uefiupdate: ## Update system firmware and uefi
	for action in refresh get-updates update; do fwupdmgr $$action; done

gtk-theme: ## Set gtk theme
	$(PACMAN) gnome-themes-extra arc-gtk-theme xdg-desktop-portal-gnome
	gsettings set org.gnome.desktop.interface gtk-theme Adwaita-dark
	sudo ln -vsf ${PWD}/.xprofile ${HOME}/.xprofile
	test -L ${HOME}/.config/gtk-4.0 || rm -rf ${HOME}/.config/gtk-4.0
	ln -vsfn ${PWD}/.config/gtk-4.0 ${HOME}/.config/gtk-4.0

throttled: ## Workaround for Intel throttling issues in thinkpad x1 carbon gen6
	$(PACMAN) throttled
	$(SYSTEMD_ENABLE) throttled

pipewire-pulse: ## Install pipewire-pulse
	$(PACMAN) pipewire-pulse

keyring: ${HOME}/.local ## Init gnome keyrings
	$(PACMAN) seahorse
	test -L ${HOME}/.local/share/keyrings || rm -rf ${HOME}/.local/share/keyrings
	ln -vsfn ${HOME}/{backup,.local/share}/keyrings

ibusmozc: ## Install ibus-mozc
	sudo ln -vsf ${PWD}/etc/environment /etc/environment
	test -L ${HOME}/.mozc || rm -rf ${HOME}/.mozc
	ln -vsfn ${HOME}/backup/mozc ${HOME}/.mozc
	mkdir -p ${HOME}/.config/autostart
	ln -vsf {${PWD},${HOME}}/.config/autostart/ibus.desktop
	yay -S ibus-mozc
	ibus-daemon -drx

fcitx-mozc: ## Install fcitx-mozc
	$(PACMAN) $@
	sudo ln -vsf ${PWD}/etc/environment /etc/environment
	mkdir -p ${HOME}/.config/fcitx/addon
	ln -vsf {${PWD},${HOME}}/.config/fcitx/addon/fcitx-clipboard.conf
	test -L ${HOME}/.mozc || rm -rf ${HOME}/.mozc
	ln -vsfn ${HOME}/backup/mozc ${HOME}/.mozc

ttf-cica: ## Install Cica font
	yay -S $@

dconfsetting: # Initial dconf setting
	$(PACMAN) dconf-editor
	dconf write /org/gnome/desktop/input-sources/xkb-options "['ctrl:nocaps']"
	dconf write /org/gnome/desktop/interface/gtk-theme "'Adwaita-dark'"
	dconf write /org/gnome/desktop/interface/gtk-key-theme "'Emacs'"
	dconf write /org/gnome/desktop/interface/text-scaling-factor 1.25
	dconf write /org/gnome/desktop/interface/cursor-size 30
	dconf write /org/gnome/desktop/interface/clock-show-date true
	dconf write /org/gnome/desktop/interface/clock-show-weekday true
	dconf write /org/gnome/desktop/interface/show-battery-percentage true
	dconf write /org/gnome/desktop/wm/preferences/num-workspaces 1
	dconf write /org/gnome/desktop/wm/keybindings/activate-window-menu "['']"
	dconf write /org/gnome/desktop/search-providers/disable-external true
	dconf write /org/gnome/desktop/privacy/remember-recent-files false
	dconf write /org/gnome/shell/keybindings/toggle-overview "['<Alt>space']"
	dconf write /org/gnome/mutter/dynamic-workspaces false

localhostssl: # Set ssl for localhost
	mkcert -install
	mkcert localhost

docker: ## Docker initial setup
	$(PACMAN) $@ $@-compose
	sudo usermod -aG $@ ${USER}
	$(SYSTEMD_ENABLE) $@.service

podman: ## Podman initial setup
	$(PACMAN) $@
	$(SYSTEMD_ENABLE) io.$@.service

circle-ci-cli: ## Install circle ci cli and setup
	curl -fLSs https://circle.ci/cli | sudo bash
	circleci update install

maria-db: mariadb
mariadb: ## Mariadb initial setup
	sudo ln -vsf {${PWD},}/etc/sysctl.d/40-max-user-watches.conf
	$(PACMAN) $@ $@-clients
	sudo ln -vsf {${PWD},}/etc/my.cnf
	sudo mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
	$(SYSTEMD_ENABLE) $@.service
	sudo mysql -u root < ${PWD}/$@/init.sql
	mysql_secure_installation
	mysql_tzinfo_to_sql /usr/share/zoneinfo | mysql -u root mysql

mysql: ## mysql initial setup
	yay mysql-clients80
	yay mysql80
	sudo mysqld --initialize --user=mysql --basedir=/usr --datadir=/var/lib/mysql
	$(SYSTEMD_ENABLE) mysqld.service
	mysql_secure_installation

tailscale: ## tailscale initial setup
	$(PACMAN) $@
	$(SYSTEMD_ENABLE) $@d
	sudo $@ up

.ONESHELL:
postgresql: ## PostgreSQL initial setup
	$(PACMAN) $@
	cd /home
	sudo -u postgres initdb -E UTF8 --no-locale -D '/var/lib/postgres/data'
	$(SYSTEMD_ENABLE) postgresql.service
	sudo -u postgres createuser --interactive

remotedesktop: ## Install remotedesktop
	$(PACMAN) remmina freerdp libvncserver

eralchemy: ## Install eralchemy
	$(PACMAN) graphviz
	yay -S $@

mycli: ## Init mycli
	mkdir -p ${HOME}/backup/$@
	yay -S $@
	ln -vsf ${HOME}{/backup/$@,}/.$@-history

pgcli: ## Init pgcli
	mkdir -p ${HOME}/backup
	yay -S $@
	test -L ${HOME}/.config/pgcli || rm -rf ${HOME}/.config/pgcli
	ln -vsfn ${HOME}/{backup,.config}/$@

gcloud: ## Install google cloud SDK and setting
	$(PACMAN) $@ kubectl kubectx kustomize helm
	curl https://sdk.cloud.google.com | bash
	test -L ${HOME}/.config/gcloud || rm -rf ${HOME}/.config/gcloud
	ln -vsfn ${HOME}/{backup,.config}/gcloud
	yay -S stern-bin

minikube: ## Setup minikube with kvm2
	$(PACMAN) $@ libvirt qemu-headless ebtables docker-machine
	yay -S docker-machine-driver-kvm2
	sudo usermod -a -G libvirt ${USER}
	$(SYSTEMD_ENABLE) libvirtd.service
	$(SYSTEMD_ENABLE) virtlogd.service
	$@ config set vm-driver kvm2

kind: ## Setup kind (Kubernetes In Docker)
	go install sigs.k8s.io/kind@v0.30.0
	sudo sh -c "kind completion zsh > /usr/share/zsh/site-functions/_kind"

redis: ## Redis inital setup
	$(PACMAN) $@
	$(SYSTEMD_ENABLE) $@.service

dingo: ## Install dingo Google DNS over HTTPS
	$(PACMAN) $@
	$(SYSTEMD_ENABLE) $@.service

ccls: ## Install c,c++ language server
	$(PACMAN) $@

android: ## Install android-studio
	yay -S android-studio

dart: ## Install dart and language server
	$(PACMAN) $@
	pub global activate $@_language_server

spotify: ## Install spotify
	gpg --keyserver hkp://keyserver.ubuntu.com --receive-keys 931FF8E79F0876134EDDBDCCA87FF9DF48BF1C90
	yay -S spotify

sxiv: ## Init sxiv
	$(PACMAN) $@
	mkdir -p ${HOME}/.config/$@/exec
	ln -vsf {${PWD},${HOME}}/.config/$@/exec/image-info && chmod +x $$_

zeal: ## Deploy zeal config and docsets
	yay -S $@
	$(PACMAN) qt5-styleplugins qt5ct
	sudo ln -vsf ${PWD}/etc/environment /etc/environment
	mkdir -p ${HOME}/.config/Zeal
	ln -vsf {${PWD},${HOME}}/.config/Zeal/Zeal.conf

emacspeak: ## Install emacspeak for blind person
	yay -S $@

intel: ## Setup Intel Graphics
	sudo ln -vsf {${PWD},}/etc/X11/xorg.conf.d/20-intel.conf

yay: ## Install yay using yay
	yay -S $@

aur: ## Install arch linux AUR packages using yay
	yay -S bun-bin duckdb-bin downgrade git-secrets firebase-tools-bin limbo-bin pscale-cli rgxg slack-desktop trdsql-bin turso-cli-bin volta-bin vscode-langservers-extracted zoom

sequeler: ## Install gui database tools
	yay -S $@-git

beekeeper: ## Setup beekeeper-studio
	$(PACMAN) html-xml-utils
	yay -S $@-studio-bin
	test -L ${HOME}/.config/$@-studio || rm -rf ${HOME}/.config/$@-studio
	ln -vsfn ${HOME}/{backup,.config}/$@-studio

gh: ## Install and setup github-cli
	$(PACMAN) github-cli
	test -L ${HOME}/.config/gh || rm -rf ${HOME}/.config/gh
	ln -vsfn ${HOME}/{backup,.config}/gh
	gh extension install seachicken/gh-poi

aurplus: ## Install arch linux AUR packages using yay
	yay -S appimagelauncher nkf rtags terraformer-bin

bluetooth: # Setup bluetooth
	$(PACMAN) bluez bluez-utils
	$(SYSTEMD_ENABLE) bluetooth.service
	sudo ln -vsf ${PWD}/etc/bluetooth/main.conf /etc/bluetooth/main.conf

desktop: ## Update desktop entry
	for item in vim xterm uxterm urxvt urxvtc urxvt-tabbed; do
		sudo ln -vsf {${PWD},}/usr/share/applications/$${item}.desktop
	done

toggle: ## Prepare command that toggle between emacs and browser
	sudo ln -vsf {${PWD},}/usr/share/applications/$@.desktop
	sudo install ${PWD}/.$@.sh /usr/local/bin/$@

aws: ${HOME}/.local ## Init aws cli
	$(PACMAN) aws-cli
	ln -vsfn {${PWD},${HOME}}/.$@

awsv2: ## Init aws cli version 2
	$(PACMAN) aws-cli-v2
	test -L ${HOME}/.aws || rm -rf ${HOME}/.aws
	ln -vsfn ${PWD}/.aws ${HOME}/.aws
	yay -S awslogs

tmuxp: ${HOME}/.local ## Install tmuxp
	$(PACMAN) $@
	sudo ln -vsf {${PWD},${HOME}}/.config/main.yaml

roswell: ## Install ros and lem
	$(PACMAN) $@
	ros install cxxxr/lem

sylpheed: ## Init sylpheed
	$(PACMAN) $@
	test -L ${HOME}/.sylpheed-2.0 || rm -rf ${HOME}/.sylpheed-2.0
	ln -vsfn ${HOME}/{backup/sylpheed,}/.sylpheed-2.0

psd: ## Profile-Sync-Daemon initial setup
	yay -S profile-sync-daemon
	mkdir -p ${HOME}/.config/psd
	ln -vsf ${PWD}/.config/psd/psd.conf ${HOME}/.config/psd/psd.conf
	echo "${USER} ALL=(ALL) NOPASSWD: /usr/bin/psd-overlay-helper" | sudo EDITOR='tee -a' visudo
	systemctl --user --now enable psd.service

chromium: ## Install chromium and noto-fonts and browserpass
	$(PACMAN) $@ browserpass-$@ noto-fonts noto-fonts-cjk
	make -C /usr/lib/browserpass hosts-$@-user
	test -L ${HOME}/.password-store || rm -rf ${HOME}/.password-store
	ln -vsfn ${HOME}/backup/browserpass ${HOME}/.password-store

chrome: ## Install chrome and noto-fonts and browserpass
	yay -S google-$@
	$(PACMAN) browserpass noto-fonts noto-fonts-cjk
	make -C /usr/lib/browserpass hosts-$@-user
	test -L ${HOME}/.password-store || rm -rf ${HOME}/.password-store
	ln -vsfn ${HOME}/backup/browserpass ${HOME}/.password-store

browserpass-firefox:  ## Setup browserpass with firefox
	$(PACMAN) browserpass-firefox
	make -C /usr/lib/browserpass hosts-firefox-user
	test -L ${HOME}/.password-store || rm -rf ${HOME}/.password-store
	ln -vsfn ${HOME}/backup/browserpass ${HOME}/.password-store

gemini: ## Init gemini-cli
	mise use -g gemini-cli

ollama: ## Init ollama
	$(PACMAN) $@
	$(SYSTEMD_ENABLE) $@.service
	ollama pull gemma3n:latest
	ollama pull gpt-oss:latest
	ollama pull qwen3:30b-a3b

edge: ## Install edge
	yay -S microsoft-edge-stable-bin

neovim: ## Init neovim
	$(PACMAN) $@
	mkdir -p ${HOME}/.config/nvim
	for item in init installer; do \
		ln -vsf {${PWD},${HOME}}/.config/nvim/$$item.vim
	bash ${HOME}/.config/nvim/installer.sh ${HOME}/.config/nvim
	sudo ln -vsf {${PWD},}/usr/share/applications/nvim.desktop

varnish: ## Varnish inital setup
	$(PACMAN) $@
	sudo ln -vsf {${PWD},}/etc/$@/default.vcl
	$(SYSTEMD_ENABLE) $@.service

mongodb: ## Mongodb initial setup
	$(PACMAN) $@ $@-tools
	$(SYSTEMD_ENABLE) $@.service

solargraph: ## Ruby language server
	yay -S $@

gnuglobal: ${HOME}/.local ## Install gnu global
	$(PACMAN) global python-pygments

elixir-ls: ## Install elixir-ls
	$(PACMAN) elixir
	yay -S $@

emacs-devel: ## Install development version of emacs
	git clone -b emacs-30 git@github.com:emacs-mirror/emacs.git ${HOME}/src/github.com/masasam/emacs
	cd ${HOME}/src/github.com/masasam/emacs && ./autogen.sh && ./configure && make && sudo make install && make clean
	rm -rf ${HOME}/.emacs.d/elpa

screenkey: ## Init screenkey
	$(PACMAN) $@
	mkdir -p ${HOME}/.config
	ln -vsf ${PWD}/.config/screenkey.json ${HOME}/.config/screenkey.json

rbenv: ## Install rvenv ruby-build
	yay -S $@
	yay -S ruby-build
	$@ install 3.4.3
	$@ rehash
	gem install bundle

rubygem: ## Install rubygem package
	yay -S ruby-solargraph
	gem install bundler jekyll sass compass rawler rdoc irb rails

django: ## Create django project from scratch
	mkdir -p ${HOME}/src/github.com/masasam && cd $$_ && \
	uv python install 3.9 && \
	uv python pin 3.9 && \
	uv init newproject && \
	cd newproject && \
	uv sync && \
	uv add django && \
	uv add python-dotenv && \
	source .venv/bin/activate && \
	django-admin startproject config .

.ONESHELL:
rails: rubygem rbenv ## Create rails project from scratch
	export RBENV_ROOT="${HOME}/.rbenv"
	if [ -d "${RBENV_ROOT}" ]; then
	  export PATH="${RBENV_ROOT}/bin:${PATH}"
	  eval "$(rbenv init -)"
	fi
	rbenv rehash
	mkdir -p ${HOME}/src/github.com/masasam/$@; cd $$_
	rbenv local 3.4.3
	bundle init
	echo "gem '$@', '~> 7.1.3'" >> Gemfile
	bundle install --path vendor/bundle
	bundle exec $@ new . --database=mysql --skip-test --skip-turbolinks
	bundle exec $@ webpacker:install

dvd: # Backup dvd media
	$(PACMAN) libdvdcss dvdbackup

tym: ## Init tym terminal
	yay -S $@
	mkdir -p ${HOME}/.config/$@
	ln -vsf {${PWD},${HOME}}/.config/$@/config.lua
	sudo ln -vsf {${PWD},}/usr/share/applications/$@.desktop

backup: ## Backup arch linux packages
	mkdir -p ${PWD}/archlinux
	pacman -Qnq > ${PWD}/archlinux/pacmanlist
	pacman -Qqem > ${PWD}/archlinux/aurlist

update: ## Update arch linux packages and save packages cache 3 generations
	yay -Syu; paccache -ruk0

pipbackup: ## Backup python global packages
	mkdir -p ${PWD}/archlinux
	pip freeze > ${PWD}/archlinux/requirements.txt

rustupdate: ## Update rust global packages
	cargo install-update -a

yarnupdate: ## Update yarn global packages
	yarn global upgrade

pnpmupdate: ## Update pnpm global packages
	pnpm self-update
	pnpm -g upgrade

mysite: ## My site and blogs source(This is private repository)
	ghq get -p masasam/solist
	ghq get -p masasam/solistblog
	ghq get -p masasam/PPAP

docker_image: docker
	docker build -t dotfiles ${PWD}

testbackup: docker_image ## Test this Makefile with mount backup directory
	docker run -it --name make$@ -v /home/${USER}/backup:${HOME}/backup:cached --name makefiletest -d dotfiles:latest /bin/bash
	for target in install init neomutt aur pipinstall goinstall; do
		docker exec -it make$@ sh -c "cd ${PWD}; make $${target}"
	done

test: docker_image ## Test this Makefile with docker without backup directory
	docker run -it --name make$@ -d dotfiles:latest /bin/bash
	for target in install init neomutt aur pipinstall goinstall; do
		docker exec -it make$@ sh -c "cd ${PWD}; make $${target}"
	done

testpath: ## Echo PATH
	PATH=$$PATH
	@echo $$PATH
	GOPATH=$$GOPATH
	@echo $$GOPATH

allinstall: dconfsetting rclone gnupg ssh install init keyring termite ghostty alacritty wezterm yay tlp pipewire-pulse ttf-cica dnsmasq goinstall ibusmozc neomutt docker lvfs toggle aur beekeeper kind gtk-theme chrome uv pipinstall ccls

nextinstall: mysql mycli pgcli rubygem rbenv postgresql zeal gcloud awsv2 eralchemy gh

allupdate: update goinstall pnpmupdate

allbackup: backup pipbackup
