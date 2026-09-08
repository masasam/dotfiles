export PATH := ${HOME}/.local/bin:$HOME/.local/share/mise/shims:/usr/local/bin:/usr/local/sbin:/usr/bin
export GOPATH := ${HOME}

BASE_PKGS	:= filesystem gcc-libs glibc bash coreutils file findutils gawk grep
BASE_PKGS	+= util-linux bzip2 gzip xz licenses pacman systemd systemd-sysvcompat
BASE_PKGS	+= iputils iproute2 autoconf automake binutils bison fakeroot flex gcc
BASE_PKGS	+= m4 patch pkgconf texinfo which archlinux-keyring debugedit libtool
BASE_PKGS	+= make groff sudo pciutils psmisc shadow procps-ng sed tar gettext

PACKAGES	:= base base-devel go zsh git vim tmux keychain unrar xsel atool fd
PACKAGES	+= unace iperf valgrind noto-fonts-emoji inkscape file-roller xclip
PACKAGES	+= ipcalc traceroute debootstrap oath-toolkit gvfs-smb zsh-completions
PACKAGES	+= imagemagick lynx the_silver_searcher cifs-utils elinks satty mold
PACKAGES	+= firefox firefox-i18n-ja gimp strace lhasa tig highlight pwgen btop
PACKAGES	+= rsync nodejs debian-archive-keyring aria2 nmap ffmpeg asciidoc sbcl
PACKAGES	+= aspell aspell-en screen mosh diskus gdb wmctrl linux-docs htop ncdu
PACKAGES	+= tcpdump gvfs lzop poppler-data cpio sysprof pkgfile p7zip ruby-rdoc
PACKAGES	+= gpaste optipng arch-install-scripts pandoc jq pkgstats ruby ethtool
PACKAGES	+= texlive-langjapanese tokei texlive-latexextra ctags hdparm eog curl
PACKAGES	+= typescript llvm llvm-libs lldb tree w3m whois csvkit shellcheck fzf
PACKAGES	+= zsh-syntax-highlighting yq ansible parallel alsa-utils geckodriver
PACKAGES	+= bash-completion mathjax expect obs-studio cscope pdfgrep cmatrix
PACKAGES	+= jpegoptim nethogs plocate pacman-contrib x11-ssh-askpass streamlink
PACKAGES	+= jhead sshfs fping syncthing terraform bat ttf-font-awesome kooha
PACKAGES	+= ripgrep stunnel mpv firejail noto-fonts-extra gnome-calculator bc
PACKAGES	+= smartmontools wireshark-cli lsof watchexec lazygit yazi bat pdfpc
PACKAGES	+= gtop gopls convmv man-db baobab ioping ruby-irb mkcert findomain
PACKAGES	+= guetzli fabric detox usleep libvterm bind lame git-lfs hex miller
PACKAGES	+= diffoscope dust rbw eza sslscan pyright miniserve fdupes xsv opencv
PACKAGES	+= gron typescript-language-server dateutils time rust rust-analyzer
PACKAGES	+= dconf-editor gopls difftastic csvlens cloc eslint prettier trivy
PACKAGES	+= gnome-sound-recorder yaml-language-server papers typst discord
PACKAGES	+= mission-center pass gitui sqlitebrowser git-delta speedtest-cli
PACKAGES	+= jc fx httpie bash-language-server editorconfig-core-c hexedit tldr
PACKAGES	+= pv perl-net-ip lshw xdotool sshuttle packer libreoffice-fresh-ja
PACKAGES	+= ast-grep dosfstools unzip zig zls gitleaks reflector ghq biome
PACKAGES	+= spotify-launcher lximage-qt ruby-lsp python-lsp-server
PACKAGES	+= tailwindcss-language-server

PACMAN		:= sudo pacman -S 
SYSTEMD_ENABLE	:= sudo systemctl --now enable
SAFE_LINK	:= python3 ${PWD}/.config/workstationctl/workstationctl.py link
SAFE_SYSTEM_LINK := sudo python3 ${PWD}/.config/workstationctl/workstationctl.py link --allow-outside-home --backup-directory /var/lib/dotfiles/backups

.DEFAULT_GOAL := help
.PHONY: all allinstall allupdate allbackup git-hooks
.PHONY: check check-hypr check-workspace-toggle check-deskctl check-emacs check-zsh check-foot
.PHONY: check-workstationctl check-secrets

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
	| sort \
	| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

all: allinstall allupdate allbackup

git-hooks: ## Enable the tracked Git hooks for this repository
	git config --local core.hooksPath .githooks

check: check-hypr check-workspace-toggle check-deskctl check-emacs check-zsh check-foot check-workstationctl check-secrets ## Validate maintained dotfile code

check-hypr:
	luac -p ${PWD}/.config/hypr/hyprland.lua ${PWD}/.config/hypr/modules/*.lua
	lua ${PWD}/.config/hypr/check-config.lua

check-workspace-toggle:
	cargo test --locked --manifest-path ${PWD}/.config/hypr/workspace-toggle/Cargo.toml

check-deskctl:
	zig build --build-file ${PWD}/.config/hypr/deskctl/build.zig test -Doptimize=ReleaseSafe

check-emacs:
	emacs --batch --quick -l ${PWD}/.emacs.d/check-config.el

check-zsh:
	zsh -n ${PWD}/.zshrc

check-foot:
	foot --config=${PWD}/.config/foot/foot.ini --check-config

check-workstationctl:
	python3 ${PWD}/.config/workstationctl/test_workstationctl.py

check-secrets: ## Scan Git history for secrets, allowing only the redacted legacy baseline
	gitleaks git --redact --no-banner --baseline-path=${PWD}/.gitleaks-baseline.json --log-opts="--all --no-textconv" ${PWD}

${HOME}/.local:
	mkdir -p $<

rclone: ## Init rclone
	$(PACMAN) $@
	chmod 600 ${PWD}/.config/rclone/rclone.conf
	$(SAFE_LINK) ${PWD}/.config/rclone ${HOME}/.config/rclone

gnupg: ## Deploy gnupg (Run after rclone)
	$(PACMAN) $@ git-crypt
	mkdir -p ${HOME}/.$@
	$(SAFE_LINK) ${PWD}/.$@/gpg-agent.conf ${HOME}/.$@/gpg-agent.conf

ssh: ## Init ssh
	$(PACMAN) open$@
	mkdir -p ${HOME}/.$@
	chmod 600 ${HOME}/.ssh/id_rsa
	$(SAFE_SYSTEM_LINK) ${PWD}/etc/ssh/sshd_config /etc/ssh/sshd_config

emacs: ## Init emacs
	$(PACMAN) emacs-wayland
	$(SAFE_LINK) ${PWD}/.emacs.d ${HOME}/.emacs.d

init: ## Initial deploy dotfiles
	$(MAKE) git-hooks
	$(MAKE) dotctl
	$(MAKE) zshctl
	$(MAKE) workstationctl
	$(SAFE_LINK) ${PWD}/.config/btop ${HOME}/.config/btop
	$(SAFE_LINK) ${PWD}/.lesskey ${HOME}/.lesskey
	lesskey
	for item in zshrc vimrc myclirc tmux.conf screenrc aspell.conf gitconfig netrc authinfo; do
		$(SAFE_LINK) ${PWD}/.$$item ${HOME}/.$$item
	done
	chmod 600 ${PWD}/.netrc
	mkdir -p ${HOME}/.config/mpv
	$(SAFE_LINK) ${PWD}/.config/mpv/mpv.conf ${HOME}/.config/mpv/mpv.conf
	$(SAFE_SYSTEM_LINK) ${PWD}/etc/hosts /etc/hosts
	$(SAFE_SYSTEM_LINK) ${PWD}/.vimrc /root/.vimrc

base: ## Install base and base-devel package
	$(PACMAN) $(BASE_PKGS)

install: ## Install arch linux packages using pacman
	$(PACMAN) $(PACKAGES)
	$(PACMAN) pkgfile
	sudo pkgfile --update

hyprland: ## Setup hyprland
	$(PACMAN) hyprland fuzzel wlr-randr waybar brightnessctl hyprlock
	$(PACMAN) xdg-desktop-portal-hyprland hypridle network-manager-applet
	$(PACMAN) mako hyprshot qt5ct qt6ct kvantum kvantum-qt5 hyprpolkitagent
	$(PACMAN) hyprsunset pavucontrol wl-clip-persist nwg-displays pipewire
	$(PACMAN) wireplumber pipewire-pulse pcmanfm-qt xdg-desktop-portal-gtk
	$(PACMAN) wl-clipboard hyprpaper wf-recorder
	$(MAKE) deskctl
	$(MAKE) workspace-toggle
	yay -S wlogout
	$(SAFE_LINK) ${PWD}/.config/hypr ${HOME}/.config/hypr
	$(SAFE_LINK) ${PWD}/.config/waybar ${HOME}/.config/waybar
	$(SAFE_LINK) ${PWD}/.config/mako ${HOME}/.config/mako
	$(SAFE_LINK) ${PWD}/.config/fuzzel ${HOME}/.config/fuzzel
	mkdir -p ${HOME}/.config/wlogout
	$(SAFE_SYSTEM_LINK) ${PWD}/.config/wlogout/wlogout.desktop /usr/share/applications/wlogout.desktop
	$(SAFE_LINK) ${PWD}/.config/wlogout/style.css ${HOME}/.config/wlogout/style.css
	yay -S snappy-switcher
	$(SAFE_LINK) ${PWD}/.config/snappy-switcher/config.ini ${HOME}/.config/snappy-switcher/config.ini

hyprwhspr: ## Setup hyprwhspr for voice input
	yay -S hyprwhspr
	$(SAFE_LINK) ${PWD}/.config/hyprwhspr/config.json ${HOME}/.config/hyprwhspr/config.json
	hyprwhspr setup
	systemctl --user enable --now hyprwhspr.service

greetd: ## Setup greetd
	$(PACMAN) $@ greetd-tuigreet terminus-font
	$(SAFE_SYSTEM_LINK) ${PWD}/etc/$@/config.toml /etc/$@/config.toml
	$(SAFE_SYSTEM_LINK) ${PWD}/etc/pam.d/greetd /etc/pam.d/greetd
	$(SAFE_SYSTEM_LINK) ${PWD}/etc/vconsole.conf /etc/vconsole.conf
	systemctl enable greetd.service

logicool: ## Setup logicool mouse
	$(PACMAN) solaar

goinstall: ${HOME}/.local ## Install go packages
	go install golang.org/x/tools/cmd/goimports@latest
	go install github.com/kyoshidajp/ghkw@latest
	go install github.com/simeji/jid/cmd/jid@latest
	go install github.com/jmhodges/jsonpp@latest
	go install github.com/mithrandie/csvq@latest

mise: ## Setup mise
	$(PACMAN) mise
	$(SAFE_LINK) ${PWD}/.config/mise/config.toml ${HOME}/.config/mise/config.toml
	mise use -g atlas
	mise use -g bun
	mise use -g claude-code
	mise use -g deno
	mise use -g duckdb
	mise use -g erlang
	mise use -g elixir
	mise use -g elixir-ls
	mise use -g firebase
	mise use -g gemini-cli
	mise use -g hugo
	mise use -g lua-language-server
	mise use -g marp-cli
	mise use -g node
	mise use -g npm:@agentclientprotocol/codex-acp
	mise use -g npm:gcloud
	mise use -g npm:@github/copilot-language-server
	mise use -g npm:@github/copilot
	mise use -g npm:@googleworkspace/cli
	mise use -g npm:oxlint
	mise use -g npm:playwright
	mise use -g npm:pnpm
	mise use -g npm:ts-node
	mise use -g npm:typescript
	mise use -g opencode
	mise use -g pi
	mise use -g ruff
	mise use -g stripe-cli
	mise use -g trdsql
	mise use -g usage
	mise use -g uv
	mise use -g yay
	mise use -g youtube-dl
	mise use -g yt-dlp
	mise use -g zls

deskctl: ## Build Hyprland desktop controller
	zig build --build-file ${PWD}/.config/hypr/deskctl/build.zig -Doptimize=ReleaseSafe

zshctl: ${HOME}/.local ## Build and deploy zsh helper utilities
	zig build --build-file ${PWD}/.config/zshctl/build.zig -Doptimize=ReleaseSafe
	mkdir -p ${HOME}/.local/bin
	$(SAFE_LINK) ${PWD}/.config/zshctl/zig-out/bin/zshctl ${HOME}/.local/bin/zshctl

workstationctl: ${HOME}/.local ## Deploy Python workstation utilities
	chmod a+x ${PWD}/.config/workstationctl/workstationctl.py
	mkdir -p ${HOME}/.local/bin
	$(SAFE_LINK) ${PWD}/.config/workstationctl/workstationctl.py ${HOME}/.local/bin/workstationctl

workspace-toggle: ## Build Hyprland workspace window toggle
	cargo build --locked --release --manifest-path ${PWD}/.config/hypr/workspace-toggle/Cargo.toml

dotctl: ${HOME}/.local ## Build and deploy general dotfile utilities
	cargo build --locked --release --manifest-path ${PWD}/.config/dotctl/Cargo.toml
	mkdir -p ${HOME}/.local/bin
	$(SAFE_LINK) ${PWD}/.config/dotctl/target/release/dotctl ${HOME}/.local/bin/dotctl

codex: ## Setup openai codex
	mise use -g codex
	$(SAFE_LINK) ${PWD}/.config/codex/config.toml ${HOME}/.codex/config.toml
	mkdir -p ${HOME}/.codex/hooks
	chmod a+x ${PWD}/.config/codex/codex_notify.py
	$(SAFE_LINK) ${PWD}/.config/codex/codex_notify.py ${HOME}/.codex/hooks/codex_notify.py
	${HOME}/.codex/hooks/codex_notify.py

codexdesktop: ## Setup openai codex app
	yay -S openai-codex-desktop

herdr: ## Setup herdr
	mise use -g herdr
	$(SAFE_LINK) ${PWD}/.config/herdr/config.toml ${HOME}/.config/herdr/config.toml

neomutt: ## Init neomutt mail client
	$(PACMAN) neomutt urlscan
	mkdir -p ${HOME}/.mutt
	$(SAFE_LINK) ${PWD}/.muttrc ${HOME}/.muttrc
	mkdir -p ${HOME}/.config/urlscan
	$(SAFE_LINK) ${PWD}/.config/urlscan/config.json ${HOME}/.config/urlscan/config.json
	for item in mailcap certificates aliases signature; do $(SAFE_LINK) ${PWD}/.mutt/$$item ${HOME}/.mutt/$$item; done

alacritty: ## Init alacritty terminal
	$(PACMAN) $@
	$(SAFE_LINK) ${PWD}/.config/$@ ${HOME}/.config/$@

foot: ## Init foot terminal
	$(PACMAN) $@
	mkdir -p ${HOME}/.config/foot
	$(SAFE_LINK) ${PWD}/.config/foot/foot.ini ${HOME}/.config/foot/foot.ini

ghostty: ## Init ghostty terminal
	$(PACMAN) $@
	mkdir -p ${HOME}/.config/$@
	$(SAFE_LINK) ${PWD}/.config/$@/config ${HOME}/.config/$@/config

kitty: # Init kitty terminal
	$(PACMAN) $@
	mkdir -p ${HOME}/.config/$@
	$(SAFE_LINK) ${PWD}/.config/$@/$@.conf ${HOME}/.config/$@/$@.conf
	$(SAFE_LINK) ${PWD}/.config/kitty/current-theme.conf ${HOME}/.config/kitty/current-theme.conf

rio: # Init rio terminal
	$(PACMAN) $@
	$(SAFE_LINK) ${PWD}/.config/$@ ${HOME}/.config/$@

tree-sitter: ## Install tree-sitter
	$(PACMAN) tree-sitter tree-sitter-rust tree-sitter-bash tree-sitter-python
	$(PACMAN) tree-sitter-javascript tree-sitter-c
	yay -S tree-sitter-typescript
	yay -S tree-sitter-json
	yay -S tree-sitter-css
	yay -S tree-sitter-yaml
	yay -S tree-sitter-html

dnsmasq: ## Init dnsmasq
	$(PACMAN) $@
	$(SAFE_SYSTEM_LINK) ${PWD}/etc/$@/resolv.$@.conf /etc/resolv.$@.conf
	$(SAFE_SYSTEM_LINK) ${PWD}/etc/$@/$@.conf /etc/$@.conf
	sudo mkdir -p /etc/NetworkManager
	$(SAFE_SYSTEM_LINK) ${PWD}/etc/NetworkManager/NetworkManager.conf /etc/NetworkManager/NetworkManager.conf

tlp: ## Setting for power saving and preventing battery deterioration
	$(PACMAN) $@ tlp-pd powertop
	$(SAFE_SYSTEM_LINK) ${PWD}/etc/$@.conf /etc/$@.conf
	$(SYSTEMD_ENABLE) $@.service
	$(SYSTEMD_ENABLE) tlp-pd.service

lvfs: ## For Linux Vendor Firmware Service
	$(PACMAN) fwupd dmidecode
	sudo dmidecode -s bios-version

uefiupdate: ## Update system firmware and uefi
	for action in refresh get-updates update; do fwupdmgr $$action; done

gtk-theme: ## Set gtk theme
	$(PACMAN) gnome-themes-extra
	gsettings set org.gnome.desktop.interface gtk-theme Adwaita-dark
	$(SAFE_LINK) ${PWD}/.config/gtk-4.0 ${HOME}/.config/gtk-4.0
	$(SAFE_LINK) ${PWD}/.config/gtk-3.0 ${HOME}/.config/gtk-3.0

throttled: ## Workaround for Intel throttling issues in thinkpad x1 carbon gen6
	$(PACMAN) throttled
	$(SYSTEMD_ENABLE) throttled

keyring: ${HOME}/.local ## Init gnome keyrings
	$(PACMAN) seahorse
	$(SAFE_LINK) ${HOME}/backup/keyrings ${HOME}/.local/share/keyrings

fcitx-mozc: ## Install fcitx-mozc
	$(PACMAN) fcitx5-im fcitx5-mozc
	yay -S fcitx5-skin-adwaita-dark
	$(SAFE_SYSTEM_LINK) ${PWD}/etc/environment /etc/environment
	$(SAFE_LINK) ${PWD}/.config/fcitx5/conf/clipboard.conf ${HOME}/.config/fcitx5/conf/clipboard.conf
	$(SAFE_LINK) ${HOME}/backup/mozc ${HOME}/.mozc
	$(SAFE_LINK) ${PWD}/.config/fcitx5/conf/classicui.conf ${HOME}/.config/fcitx5/conf/classicui.conf

ttf-cica: ## Install Cica font
	yay -S $@

dconfsetting: # Initial dconf setting
	$(PACMAN) dconf-editor
	dconf write /org/gnome/desktop/input-sources/xkb-options "['ctrl:nocaps']"
	dconf write /org/gnome/desktop/interface/gtk-theme "'Adwaita-dark'"
	dconf write /org/gnome/desktop/interface/gtk-key-theme "'Emacs'"
	dconf write /org/gnome/desktop/interface/text-scaling-factor 1
	dconf write /org/gnome/desktop/interface/cursor-size 30
	dconf write /org/gnome/desktop/interface/clock-show-date true
	dconf write /org/gnome/desktop/interface/clock-show-weekday true
	dconf write /org/gnome/desktop/interface/show-battery-percentage true
	dconf write /org/gnome/desktop/wm/keybindings/activate-window-menu "['']"
	dconf write /org/gnome/desktop/search-providers/disable-external true
	dconf write /org/gnome/desktop/privacy/remember-recent-files false
	dconf write /org/gnome/shell/keybindings/toggle-overview "['<Alt>space']"
	dconf write /org/gnome/mutter/dynamic-workspaces false

printer: ## Setup printer
	sudo pacman -S cups cups-pdf avahi nss-mdns
	$(SAFE_SYSTEM_LINK) ${PWD}/etc/nsswitch.conf /etc/nsswitch.conf
	$(SYSTEMD_ENABLE) cups.service
	$(SYSTEMD_ENABLE) avahi-daemon.service

docker: ## Docker initial setup
	$(PACMAN) $@ $@-compose
	sudo usermod -aG $@ ${USER}
	$(SYSTEMD_ENABLE) $@.service

podman: ## Podman initial setup
	$(PACMAN) $@
	$(SYSTEMD_ENABLE) io.$@.service

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

eralchemy: ## Install eralchemy
	$(PACMAN) graphviz
	yay -S $@

mycli: ## Init mycli
	mkdir -p ${HOME}/backup/$@
	yay -S $@
	$(SAFE_LINK) ${HOME}/backup/$@/.$@-history ${HOME}/.$@-history

pgcli: ## Init pgcli
	mkdir -p ${HOME}/backup
	yay -S $@
	$(SAFE_LINK) ${HOME}/backup/$@ ${HOME}/.config/$@

gcloud: ## Install google cloud SDK and setting
	$(PACMAN) $@ kubectl kubectx kustomize helm stern
	curl https://sdk.cloud.google.com | bash
	$(SAFE_LINK) ${HOME}/backup/gcloud ${HOME}/.config/gcloud

minikube: ## Setup minikube with kvm2
	$(PACMAN) $@ libvirt qemu-headless ebtables docker-machine
	yay -S docker-machine-driver-kvm2
	sudo usermod -a -G libvirt ${USER}
	$(SYSTEMD_ENABLE) libvirtd.service
	$(SYSTEMD_ENABLE) virtlogd.service
	$@ config set vm-driver kvm2

kind: ## Setup kind (Kubernetes In Docker)
	mise use -g kind
	sudo sh -c "kind completion zsh > /usr/share/zsh/site-functions/_kind"

valkey: ## Valkey inital setup
	$(PACMAN) $@
	$(SYSTEMD_ENABLE) $@.service

dingo: ## Install dingo Google DNS over HTTPS
	$(PACMAN) $@
	$(SYSTEMD_ENABLE) $@.service

ccls: ## Install c,c++ language server
	$(PACMAN) $@

emacspeak: ## Install emacspeak for blind person
	yay -S $@

aur: ## Install arch linux AUR packages using yay
	yay -S downgrade git-secrets grok-build pscale-cli turso-bin vscode-langservers-extracted yacreader zoom

aurplus: ## Install arch linux AUR packages using yay
	yay -S appimagelauncher asunder hermes-agent nkf rgxg rtags terraformer-bin

wkhtmltopdf: ## Install wkhtmltopdf
	yay -S wkhtmltopdf-bin

sequeler: ## Install gui database tools
	yay -S $@

beekeeper: ## Setup beekeeper-studio
	$(PACMAN) html-xml-utils
	yay -S $@-studio-bin
	$(SAFE_LINK) ${HOME}/backup/$@-studio ${HOME}/.config/$@-studio

gh: ## Install and setup github-cli
	$(PACMAN) github-cli
	$(SAFE_LINK) ${HOME}/backup/gh ${HOME}/.config/gh
	gh completion -s zsh > ${HOME}/.zfunc/_gh

bluetooth: # Setup bluetooth
	$(PACMAN) bluez bluez-utils blueman bluetui
	$(SYSTEMD_ENABLE) bluetooth.service
	$(SAFE_SYSTEM_LINK) ${PWD}/etc/bluetooth/main.conf /etc/bluetooth/main.conf

aws: ${HOME}/.local ## Init aws cli
	mise use -g aws-cli
	$(SAFE_LINK) ${PWD}/.$@ ${HOME}/.$@

tmuxp: ${HOME}/.local ## Install tmuxp
	$(PACMAN) $@
	$(SAFE_LINK) ${PWD}/.config/main.yaml ${HOME}/.config/main.yaml

psd: ## Profile-Sync-Daemon initial setup
	yay -S profile-sync-daemon
	mkdir -p ${HOME}/.config/psd
	$(SAFE_LINK) ${PWD}/.config/psd/psd.conf ${HOME}/.config/psd/psd.conf
	echo "${USER} ALL=(ALL) NOPASSWD: /usr/bin/psd-overlay-helper" | sudo EDITOR='tee -a' visudo
	systemctl --user --now enable psd.service

chromium: ## Install chromium and noto-fonts and browserpass
	$(PACMAN) $@ browserpass-$@ noto-fonts noto-fonts-cjk
	make -C /usr/lib/browserpass hosts-$@-user
	$(SAFE_LINK) ${HOME}/backup/browserpass ${HOME}/.password-store

chrome: ## Install chrome and noto-fonts and browserpass
	yay -S google-$@
	$(PACMAN) browserpass noto-fonts noto-fonts-cjk
	make -C /usr/lib/browserpass hosts-$@-user
	$(SAFE_LINK) ${HOME}/backup/browserpass ${HOME}/.password-store

browserpass-firefox:  ## Setup browserpass with firefox
	$(PACMAN) browserpass-firefox
	make -C /usr/lib/browserpass hosts-firefox-user
	$(SAFE_LINK) ${HOME}/backup/browserpass ${HOME}/.password-store

ollama: ## Init ollama
	$(PACMAN) $@
	$(SYSTEMD_ENABLE) $@.service
	ollama pull gemma4:12b

edge: ## Install edge
	yay -S microsoft-edge-stable-bin

neovim: ## Init neovim
	$(PACMAN) $@
	$(SAFE_LINK) ${PWD}/.config/nvim ${HOME}/.config/nvim

mongodb: ## Mongodb initial setup
	$(PACMAN) $@ $@-tools
	$(SYSTEMD_ENABLE) $@.service

solargraph: ## Ruby language server and jekyll
	yay -S ruby-$@ jekyll

gnuglobal: ${HOME}/.local ## Install gnu global
	$(PACMAN) global python-pygments

emacs-devel: ## Install development version of emacs
	git clone -b emacs-30 git@github.com:emacs-mirror/emacs.git ${HOME}/src/github.com/masasam/emacs
	cd ${HOME}/src/github.com/masasam/emacs && ./autogen.sh && ./configure && make && sudo make install && make clean
	rm -rf ${HOME}/.emacs.d/elpa

dvd: # Backup dvd media
	$(PACMAN) libdvdcss dvdbackup

backup: ## Backup arch linux packages
	mkdir -p ${PWD}/archlinux
	pacman -Qnq > ${PWD}/archlinux/pacmanlist
	pacman -Qqem > ${PWD}/archlinux/aurlist

update: ## Update arch linux packages and save packages cache 3 generations
	yay -Syu; paccache -ruk0

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

allinstall: dconfsetting rclone gnupg ssh install emacs init keyring mise foot ghostty rio alacritty tlp ttf-cica hyprland greetd dnsmasq fcitx-mozc neomutt lvfs aur beekeeper kind gtk-theme chrome ccls gh tree-sitter tailscale codex codexapp hyprwhspr logicool

allupdate: update goinstall

allbackup: backup
