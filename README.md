# Synopsis

![emacs](https://raw.githubusercontent.com/masasam/image/image/emacs.png)


## Let's build environment with Makefile

This dotfiles is for Archlinux  
Because there is no such as a distribution without make If you make  
Makefile you can correspond to any distribution  
Let's make a Makefile immediately  

### With a Makefile, such a good thing

Easy to build development environment with  

    make install

I never have to worry about resetting my PC again  

### Deploying dotfiles can be done in a moment

After make install  
You can deploy dotfiles with.  

    make init

Keep Dropbox synchronized before making make init  

### With Makefile, you will be able to recover your usual environment in 30 minutes

![make](https://raw.githubusercontent.com/masasam/image/image/make.png)
Once after creating the environment  

    make backup

Since the arch linux package list that was installed at will be backed up to Dropbox  
In addition to make install for the second time after that  
You can recover the arch linux environment with.  

    make recover

Troubleshooting is with make recover A serious person is also make  
install for the second time or later If Makefile is completed, you  
should be able to restore in 30 minutes in either case.  

After Dropbox Sync  

    make init

Then dotfiles will be deployed and restored.  
You can recover in 30 minutes.  

#### Criteria of things managed by Dropbox

- What can not be placed on github  
   Public key in .ssh etc.

- Because it expires a lot of update file, it is troublesome to synchronize with github  
   .zsh_history  
   .mozc  

- To protect data  
   Sylpheed configuration file  
   Mail data used for gmail in dropbox  
   As mail arrives, it will be synchronized to dropbox so you do not have to think about backup  

Make it 2-step verification  

# ArchLinux install

Why Arch linux ?  

- As long as it does not break by rolling release, it does not have to be reinstalled  
  Even if it gets broken, I made a Makefile so I can return in half an hour and it's unbeatable  

- Server can be in CentOS, but if the development environment is not up to date it is hard  

- I like customization but I think that it is better to do it with salt plum  
  which does not come off the ecosystem  
  In principle the package of Arch is a policy to build from the source of vanilla  
  not to patch     It is good because Arch unique problems are unlikely  

- It is light !! After installing Emacs Terminal Chrome and launching an image htop  

![top](https://raw.githubusercontent.com/masasam/image/image/top.png)

Download Arch linux with BitTorrent
https://www.archlinux.org/releng/releases/  

Create USB installation media  

    dd bs=4M if=/path/to/archlinux.iso of=/dev/sdx && sync

![baobao](https://raw.githubusercontent.com/masasam/image/image/baobao.png)

SSD has only 120 G, but it is sufficient for the environment that uses arch linux and emacs  

#### Boot in USB memory

Change it to boot usb in BIOS and boot  

Partitioning  
* UEFI can not use thinkpad so BIOS  
  Choose according to your hardware  
* Since it is GPT, it runs even if you do not run the boot partition / only  
  Eliminate thoroughly that it is troublesome  
* With SSD it's 8G memory so there's no swap  

gdisk /dev/sda  

    1 sda1  BIOS boot partition(ef02) 1007KB
    2 sda2 / All remaining

Formatted and mounted with ext4  

    mkfs.ext4 /dev/sda2
    mount /dev/sda2 /mnt

vi /etc/pacman.d/mirrorlist  

    Server = http://ftp.jaist.ac.jp/pub/Linux/ArchLinux/$repo/os/$arch

Make sure the earliest mirror is selected  

Install bese bese-devel of arch  

    pacstrap /mnt base base-devel

Generate fstab  

    genfstab -U -p /mnt >> /mnt/etc/fstab

Mount and log in as bash login shell  

    arch-chroot /mnt /bin/bash

Set the host name  

    echo thinkpad > /etc/hostname

Time to Tokyo  

    ln -s /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

Set the locale  
vi /etc/locale.gen  

>en_US.UTF-8 UTF-8  
>ja_JP.UTF-8 UTF-8  

    locale-gen

Shell is in English environment  

    export LANG=C

This neighborhood will be UTF-8  

    echo LANG=ja_JP.UTF-8 > /etc/locale.conf

Time adjustment  

    hwclock --systohc --utc

Generate kernel image  

    mkinitcpio -p linux

Generate user  

    useradd -m -G wheel -s /bin/bash masa

Set password  

    passwd masa

Set groups and permissions  

    visudo

>Defaults env_keep += “ HOME ”  
>%wheel ALL=(ALL) ALL  

Uncomment comment out  

Set boot loader  

    pacman -S grub
    grub-install --recheck /dev/sda
    grub-mkconfig -o /boot/grub/grub.cfg

As reconnected with dhcp after reboot  

    systemctl enable dhcpcd.service
    exit
    reboot

Pull out the USB memory just before the BIOS starts up  

#### root で login してドライバや Xorg Gnome wifi などを整える

As bash complements work  

    pacman -S bash-completion

Install drivers that match your environment  

    lspci|grep VGA
    pacman -S xf86-video-intel
    pacman -S libva-intel-driver
    pacman -S xorg-server xorg-server-utils xorg-xinit xorg-xclock xterm

Gnome can be put as small as necessary  

    pacman -S gnome-backgrounds
	pacman -S gnome-calculator
	pacman -S gnome-control-center
	pacman -S gnome-keyring
	pacman -S gnome-shell-extensions
	pacman -S gnome-tweak-tool
	pacman -S nautilus
	pacman -S gedit

Terminal uses termite and lilyterm  

	sudo pacman -S termite
	sudo pacman -S lilyterm

Enable graphical login with gdm  

    pacman -S gdm
    systemctl enable gdm.service

Install yaourt  
vim /etc/pacman.conf  

    [archlinuxfr]
    SigLevel = Never
    Server = http://repo.archlinux.fr/$arch

Synchronize yaourt latest  

    sudo pacman -Syy
    sudo pacman -S yaourt
    sudo pacman --sync --refresh yaourt
    yaourt -Syua

Preparing the net environment  
After using NetworkManager, use it with wifi You can not wifi unless you turn off dhcpcd  

    sudo pacman -S networkmanager
    systemctl disable dhcpcd.service
    systemctl enable NetworkManager.service
    reboot

#### Login with masa to arrange home directory

    sudo pacman -S xdg-user-dirs
    LANG=C xdg-user-dirs-update --force
    sudo pacman -S zsh git vim

Install dropbox and sync  

    sudo pacman -S dropbox
    sudo pacman -S nautilus-dropbox
	dropbox

Preparing dotfiles with ghq  

	yaourt ghq
	git config --global ghq.root ~/src
	ghq get -p masasam/dotfiles
	ghq look dotfiles
	make install
	make init

	# Below is for posting images of github
	cd ~/Pictures
	git clone -b image git@github.com:masasam/image.git

 ※ When git cloning with ssh, it is necessary to put the public key first in .ssh  

--------------------------------------

You can make install from here

--------------------------------------

## Development environment install

Install what enters with pacman  

    sudo pacman -S firefox  firefox-i18n-ja
    sudo pacman -S otf-ipafont
    sudo pacman -S openssh
    sudo pacman -S sylpheed
    sudo pacman -S zsh-completions
    sudo pacman -S emacs
    sudo pacman -S curl
    sudo pacman -S tmux
    sudo pacman -S keychain
    sudo pacman -S gnome-tweak-tool
    sudo pacman -S xsel
    sudo pacman -S archlinux-wallpaper
    sudo pacman -S evince inkscape gimp unrar
    sudo pacman -S file-roller vlc
    sudo pacman -S xclip
    sudo pacman -S atool
    sudo pacman -S trash-cli
    sudo pacman -S the_silver_searcher
    sudo pacman -S powertop
    sudo pacman -S cifs-utils
    sudo pacman -S gvfs gvfs-smb
    sudo pacman -S seahorse gnome-keyring
    sudo pacman -S cups-pdf
    sudo pacman -S redshift
    sudo pacman -S eog
    sudo pacman -S mcomix
    sudo pacman -S libreoffice-fresh-ja
    sudo pacman -S go pkgfile rsync elixir
	sudo pacman -S nodejs phantomjs whois nmap poppler-data
	sudo pacman -S rtmpdump ffmpeg swftools fish sbcl
	sudo pacman -S aspell aspell-en httperf
	sudo pacman -S gdb ripgrep hub wmctrl
	sudo pacman -S linux-docs ansible pwgen pygmentize
	sudo pacman -S arch-install-scripts
	sudo pacman -S htop
	sudo pacman -S neovim youtube-dl
	sudo pacman -S pandoc texlive-langjapanese texlive-latexextra ctags python-pygments
	sudo pacman -S python-neovim python2-neovim
	sudo pacman -S rust cargo
	sudo pacman -S noto-fonts-cjk arc-gtk-theme jq
	sudo pacman -S docker zsh-syntax-highlighting python-pip
	sudo pacman -S eslint shellcheck python-pyflakes python-jedi autopep8 python-virtualenv
	sudo pacman -S python-pylint flake8
	sudo pacman -S npm llvm llvm-libs lldb hdparm rxvt-unicode dnsmasq typescript php cscope
	sudo pacman -S speedtest-cli cpanminus mariadb-clients postgresql-libs tig lsof fzf
	sudo pacman -S debootstrap

Install what you put in yaourt  

	yaourt google-chrome
	yaourt peco
	yaourt ttf-ricty
	yaourt profile-sync-daemon
	yaourt man-pages-ja
	yaourt global
	yaourt hugo
	yaourt ghq
	yaourt casperjs
	yaourt nkf
	yaourt cmigemo-git
	yaourt ibus-mozc
	yaourt mozc
	yaourt clipit
	yaourt python-epc
	yaourt debian-archive-keyring

#### golang npm rust

    ghq get -p github.com/nsf/gocode
    ghq get -p github.com/rogpeppe/godef
	go get -u golang.org/x/tools/cmd/goimports
	go get -u golang.org/x/tools/cmd/godoc
	ghq get -p josharian/impl
	ghq get -p github.com/motemen/ghq
	ghq get -p phildawes/racer
	sudo npm install -g tern
	sudo npm install -g jshint
	curl https://sh.rustup.rs -sSf | sh
	source $HOME/.cargo/env
	cargo install rustfmt
	cargo install racer
	cargo install cargo-script
	cpanm RPC::EPC::Service DBI DBD::SQLite DBD::Pg DBD::mysql

#### cask install

    curl -fsSL https://raw.githubusercontent.com/cask/cask/master/go | python
    cd .emacs.d
    cask upgrade
    cask install
    cask update

#### Trackpoint 

Install Thinkpad specific ones  

~/.xinitrc  

    tpset() { xinput set-prop "TPPS/2 IBM TrackPoint" "$@"; }

    tpset "Evdev Wheel Emulation" 1
    tpset "Evdev Wheel Emulation Button" 2
    tpset "Evdev Wheel Emulation Timeout" 200
    tpset "Evdev Wheel Emulation Axes" 6 7 4 5
    tpset "Device Accel Constant Deceleration" 0.95

sudo vim /etc/udev/rules.d/10-trackpoint.rules  

    ACTION=="add", SUBSYSTEM=="input", ATTR{name}=="TPPS/2 IBM TrackPoint", ATTR{device/sensitivity}="240"

sudo vim /etc/X11/xorg.conf.d/20-thinkpad.conf  

    Section "InputClass"
        Identifier	"Trackpoint Wheel Emulation"
        MatchProduct	"TPPS/2 IBM TrackPoint"
        MatchDevicePath	"/dev/input/event*"
        Option		"EmulateWheel"		"true"
        Option		"EmulateWheelButton"	"2"
        Option		"Emulate3Buttons"	"false"
        Option		"XAxisMapping"		"6 7"
        Option		"YAxisMapping"		"4 5"
    EndSection

Thinkpad i915 only  
>sudo vim /etc/mkinitcpio.conf  

    MODULES="i915"

# Tweak Tool

Detailed setting of gnome etc.

![TweakTool](https://raw.githubusercontent.com/masasam/image/image/tweaktool.png)
* Key theme  
>Emacs  

* Ctrl key position  
>Use Caps Lock as Ctrl  

* Key sequence for terminating X server  
>Ctrl Alt Backspace  

* Fix workspace to 1  

* Power supply  

    When AC power is connected Blank  
    Don't suspend on lid close  

# Terminal

![terminal](https://raw.githubusercontent.com/masasam/image/image/terminal.png)

Terminal uses termite and lilyterm see  

	.config/lilyterm
	.config/termite

#### .bashrc

zsh をデフォルトシェルにして zsh をカスタマイズしまくると  
login できなくなって大変困ったことになるかもしれない。  
まぁそれでも Arch linux なら USB メモリで boot して  

    arch-chroot /mnt /bin/bash

すればいくらでも回復できるから気軽なものだが、  
面倒くさくなって新しいものを受け付けなくなるのは本末転倒であるから  
zsh をデフォルトシェルにはしない。  
tmux を起動したら zsh が起動するようにしておいて  
.bashrc はほぼディストリデフォルトにしておく  
どんな時でも bash が起動しないと困るから  
.bashrc は以下のエイリアスを追記する以外はしない  

    echo "alias tmuxstart='tmux new-session -A -s main'" >> ~/.bashrc
    echo "export HISTCONTROL=erasedups" >> ${HOME}/.bashrc

terminal を開いて  
tmuxstart で起動すると  
セッションがあればそれを利用しなければ新規セッションで zsh が起動する  
これで bash の履歴は tmuxstart しかたまらないので  
.bashrc の export HISTCONTROL=erasedups で bash の履歴が増えないようにする  

# Powertop

消費電力を抑えて省エネ化  
使っていないシステムバスとか徹底的にスリープするようにしてくれる  

>sudo pacman -S powertop  

再起動すると無効になるので  

>sudo powertop --calibrate  

で解析して  

sudo vim /etc/systemd/system/powertop.service  

>[Unit]
>Description=PowerTOP auto tune

>[Service]
>Type=idle
>Environment="TERM=dumb"
>ExecStart=/usr/sbin/powertop --auto-tune

>[Install]
>WantedBy=multi-user.target

    sudo systemctl enable powertop
    reboot

![PowerTop](https://raw.githubusercontent.com/masasam/image/image/powertop.png)

このタブが全部 Good になっていれば成功

アイドル時の消費電力が  
18W → 10W になった  
これで一日 16 時間アイドルで  
月間の電気代が 140 円くらいだからよい  
アイドル時以外の消費電力を考慮しても 200 円代ですむ  

# Profile-Sync-Daemon

chrome firefox のキャッシュとプロファイルを  
メモリ上に置くようにして超高速化  
ディスクに同期する頻度は下がるので SSD の消耗を防ぐ効果もある  

>yaourt profile-sync-daemon  

visudo  

    masa ALL=(ALL) NOPASSWD: /usr/bin/psd-overlay-helper

>psd p  

vim ~/.config/psd/psd.conf  

    USE_OVERLAYFS="yes"
    BROWSERS="google-chrome firefox"

>psd p  

#### psd を自動起動するように
>systemctl --user enable psd.service  
>reboot  
動いているか確認する

再起動後

>systemctl --user status psd  

# DNS キャッシュを有効にする

dnsmasq をインストール  

	sudo pacman -S dnsmasq

/etc/NetworkManager/NetworkManager.conf  

	[main]
	plugins=keyfile
	#dns=default
	dns=dnsmasq

NetworkManager を再起動すると dnsmasq が自動で使えるように設定される  

	sudo systemctl restart NetworkManager

drill で同じ DNS ルックアップを二回やって確認する  

![dnsmasq](https://raw.githubusercontent.com/masasam/image/image/dnsmasq.png)

## 蓋を閉じてもサスペンドしないように

起動 10 秒で emacs までたどりつくのでサスペンドなどしない  
>/etc/systemd/logind.conf  

    #HandleLidSwitch=suspend
    HandleLidSwitch=ignore

そして、logind サービスを再起動します:  

    systemctl restart systemd-logind

## Activity

![activity](https://raw.githubusercontent.com/masasam/image/image/activity.png)
アクティビティ > 設定 > 検索  
全部 off にする  
アプリの起動にしか使わないから  

アクティビティ > 設定 > キーボード > ショートカット  

>システム→アクティビティ画面を表示する  を Alt+Space  

Alt+space でランチャーっぽく使う

>Ctrl-u  

文字を打ち間違えたら Ctrl-u で全消し  

Activity 画面では Ctrl-h で backspace できないのでつらいがこれでいける  
Ctrl-h できないのは誰得？  
まぁ Ctrl-u で凌げるからよし。実際のところアプリ呼び出すだけやし  

# Firefox
firefox sync を有効化  

#### Gnome Shell Extention
>Dash to Dock  
>TopIcons Plus  

#### stylish
以下のテーマを利用
<https://userstyles.org/styles/23516/midnight-surfing-global-dark-style>  

defaultfullzoomlevel を 125 ％に  

# Chrome
デフォルトのサイズを 125 ％に  

<https://chrome.google.com/webstore/detail/change-colors/jbmkekhehjedonbhoikhhkmlapalklgn>  
change-colors で黒画面をベースにする。  
黒画面が都合の悪いドメインは指定すれば普通の画面になる  
chrome の google 検索のデフォルトは vi キーバインドだが気にしない(vim も使うし)  

>jk で移動して  
>enter で新規 tab に開き  
>Ctrl+W tab を消す  
>Ctrl+R 再読み込み  
>Ctrl+tab タブ移動  
>Ctrl+K 検索  
>Ctrl+f I-search
>Ctrl+g I-search 中に押すと次の候補へ
>Ctrl+shift+g I-search 中に押すと前の候補へ

許容範囲なのでデフォルトで使う  

# Mozc
ibus-mozc（gnome のデフォルトは ibus)  
地域と言語で入力ソースを mozc だけにする。  

US キーボードなので日本語変換は control+space は  
emacs とかぶるので shift+Space で mozc を利用する  

キー設定はことえりをベースに ← emacs キーバインドに一番近い  

>「変換前入力中」「Shift+Space」「IME を無効化」  
>「変換中」「Shift+Space」「IME を無効化」  
>「直接入力」「Shift+Space」「IME を有効化」  
>「入力文字なし」「Shift+Space」「IME を無効化」  
>他の Shift-space 絡みのショートカットは削除しておく。  

ターミナルで

    ibus-setup

でフォントなど設定する。  
全般タブで  
>カスタムフォントを選んで fontsize 14  
>次のインプットメソッド super-space  
>インプットメソッドタブを mozc だけにする  
これで reboot  

#### mozc 用辞書インストール

<http://mediadesign.jp/article-4218/>  
住所とかキーボードで打ちたくないから  
郵便番号を入れると住所がでるようにしておく  

Zipcode_J_Mzc  
　┣　 Readme_J.txt  
　┣　 zipcode_j_3_4.txt  
　┗　 zipcode_j_7.txt  
辞書ファイルはハイフン有無により２種類。  
・ zipcode_j_3_4.txt  
　郵便番号がハイフンでつながれた１２３-４５６７の形式で入力し変換する辞書  
・ zipcode_j_7.txt  
　郵便番号がハイフンなしの７桁の数字１２３４５６７の形式で入力し変換する辞書  
Mozc 辞書ツールを起動しメニューの［管理］＞［新規辞書にインポート］を選択。  

mozc の設定が完成したら  

    ln -sfn ~/Dropbox/mozc/.mozc ~/.mozc

で mozc の設定は Dropbox に投げておく  
これでもう二度と設定しなくてもよくなるだろう  

# Sylpheed

sylpheed 初回起動時に  
Mail フォルダを質問されるので  

> ~/Dropbox/sylpheed/Mail  

初回起動時以外 Mail フォルダを変更する場合は
> vim ~/.sylpheed-2.0/folderlist.xml  

    <folder type="mh" name="メール箱" path="/home/masa/Dropbox/sylpheed/Mail">

で Mail フォルダを指定する。  
1 メール 1 ファイルのファイル形式なので  
Dropbox でメールをすぐ同期すれば  
データロストの心配がない。  

もしあっても最新のメールが一通だけだろう。  
普通サーバーに７日くらいメールはとっておくから  
メールデータロストは心配しなくてもよいことになる。  

#### sylpheed の設定ファイル

ひとしきり設定が終了したら  
dropbox に丸投げして二度と設定作業とかかわらないようにしよう。  

    ln -sfn ~/Dropbox/sylpheed/.sylpheed-2.0 ~/.sylpheed-2.0

最小化した時にトレイアイコンに格納する  
に設定しておくと  
Alt - Tab  
で sylpheed がでてこないのでよい  
コード書いてる時はメールなど見たくないものだ。  

### font の設定

gnome-tweak-tool で以下を設定  

フォント  

- ウインドウタイトル  Cantarell 11
- インターフェース   Noto Sans CJK JP Regular 11
- ドキュメント   Sans Regular 11
- 等幅    Monospace Regular 11
