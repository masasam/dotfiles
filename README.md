# Synopsis

![emacs](https://raw.githubusercontent.com/latestmasa/dotfiles/image/image/emacs.png)

この dotfiles は Archlinux 用です  
NetworkManager を入れるまで有線で接続しその後無線 Lan で使用する。  

Makefile があるので  

    make install
	
できる。  

しかし、かなりオレオレ make install なので  
利用する場合は make install せず  
一度手を動かして入れるほうがよろしいかと思います。  
もし make install される奇特な方は下記手順の  

--------------------------------------

*ここまで手で打ち込む   ここから make install できる*

--------------------------------------

までの手順を終えてから make install してください  
あるいは勝手に fork して Makefile を作ってね。  
よって、ドライバなどは make install に入れないで手動でやることにする。  

make install 後に

    make init

で dotfiles をデプロイできる。  
make init する前に Dropbox の同期を終わらせておくこと  

#### 30 分でいつもの環境をリカバリー

一度環境を作ったあとは  

    make backup

でインストールした arch linux パッケージ list が Dropbox にバックアップされるので  
そのあとの２回目のインストールは make install 以外にも  

    make recover

で arch linux 環境を回復させることができる。  
make recover すると途中でフリーズしたみたいになるが、  
数分たってから(install が終わる頃合いを見計らって)  
ctrl - alt - backspace で x 再起動して reboot すれば  
問題なく arch linux のパッケージがすべてインストールされているのでよし。  

![komakee](https://raw.githubusercontent.com/latestmasa/dotfiles/image/image/komakee.jpg)

なんかフリーズした感じが嫌な場合は  
2 回目以降も make install で環境をつくればよいと思います。  
オレオレ Makefile が完成しているならどちらでも 30 分で元通りにできるはず。  
この機会に是非 Makefile を作っておこう。  

Dropbox 同期後  

    make init

すれば dotfiles がデプロイされ元通りになる。  
これで 30 分でリカバリできる。  

#### Dropbox で管理するものの基準

1. github に置けないもの  
   .ssh に入っている公開鍵など  
   
2. すこぶる更新ファイルを吐き出すので github で同期するのが面倒くさいもの  
   .zsh_histfile .mozc  
   .emacs.d の中の更新ファイルは.gitignore を利用して問題なくデプロイできるから github で OK  
   
3. データの保護が目的のもの  
   Sylpheed の設定ファイルとメール gmail ライクに使いたい  
   メールが届いたらすぐ dropbox に同期されるからよい  
   メールが届くたびに git push なんて面倒くさい  

２段階認証にしておく  
２段階認証の recovery-code は Dropbox に置くと  
金庫を開ける鍵が金庫の中にある問題が発生するから  
recovery-code は自宅の NAS に置いておく  

# Arch linux install

Why Arch linux ?  

1. ローリング・リリースで壊れない限りは再インストールしなくてもいいから楽  
   壊れても 30 分で復帰できるように Makefile を作ったから無敵  
  
2. サーバは CentOS でいいけど,開発環境は割と最新じゃないとつらい  
   OverlayFS とか Profile Sync Daemon 使いたい  
   Emacs は最新じゃないと嫌なので make install していたが Arch なら pacman ですむ  
   go の最新バージョンをつかうためにコンパイルするとバイナリの管理が大変  
   バイナリの管理に paco を使っていたが Aur とかでパッケージ作って共有したほうが賢いと思う  

3. カスタマイズは好きだがエコシステムから外れない塩梅でやるのがいいと思う  
   Arch のパッケージは原則としてパッチをあてないバニラのソースからビルドする方針になっていて  
   Arch 固有の問題が起きにくいからよい  

4. 軽い!!  インストールが終わって Emacs Terminal Chrome を起動して top した画像  

![top](https://raw.githubusercontent.com/latestmasa/dotfiles/image/image/top.png)

--以上--  

BitTorrent で Arch linux をダウンロード  
https://www.archlinux.org/releng/releases/2016.06.01/torrent/  

USB インストールメディアを作成  

    dd bs=4M if=/path/to/archlinux.iso of=/dev/sdx && sync

/dev/sdx は環境で異なるから df して調べる  

![baobao](https://raw.githubusercontent.com/latestmasa/dotfiles/image/image/baobao.png)

SSD は 120G しかないが arch linux と emacs を使う環境としてはこれで十分足りる  
以下の初期設定が終わった段階で 6.6G ですんでしまっている。  

#### USB メモリでブートする

BIOS で usb ブートするように変更して boot  

パーティショニング  
* UEFI は使えない thinkpad なので BIOS  
  ハードに合わせて選ぶ  
* GPT なので boot パーティションは切らなくても動くので / のみ  
  面倒くさいことは徹底的に排除  
* SSD でメモリ 8G なのでスワップは無し  

gdisk /dev/sda  

    1 sda1  BIOS boot partition(ef02) 1007KB
    2 sda2 / 残り全部

ext4 でフォーマットしてマウント  

    mkfs.ext4 /dev/sda2
    mount /dev/sda2 /mnt

nano /etc/pacman.d/mirrorlist  

	Server = http://ftp.nara.wide.ad.jp/pub/Linux/archlinux/$repo/os/$arch
    Server = http://ftp.jaist.ac.jp/pub/Linux/ArchLinux/$repo/os/$arch

一番早いミラーかつ負荷分散になるようにする  

arch の bese bese-devel をインストール  

    pacstrap /mnt base base-devel

fstab を生成する  

    genfstab -U -p /mnt >> /mnt/etc/fstab

マウントして bash をログインシェルにしてログイン  

    arch-chroot /mnt /bin/bash

ホスト名を決める  

    echo thinkpad > /etc/hostname

時間を Tokyo に  

    ln -s /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

ロケールを設定  
nano /etc/locale.gen  

>en_US.UTF-8 UTF-8  
>ja_JP.UTF-8 UTF-8  

    locale-gen

シェルは英語環境で(error でググると english しか情報がないことがあるから)  

    export LANG=C

この辺は UTF-8 にしとく  

    echo LANG=ja_JP.UTF-8 > /etc/locale.conf

時刻合わせ  

    hwclock --systohc --utc

カーネルイメージを生成  

    mkinitcpio -p linux

ユーザーを生成  

    useradd -m -G wheel -s /bin/bash masa

パスワードを設定  

    passwd masa

グループと権限を設定  

    export EDITOR=/usr/bin/nano
    visudo

>Defaults env_keep += “ HOME ”  
>%wheel ALL=(ALL) ALL  

のコメントアウトを外す  

ブートローダーを設定  

    pacman -S grub
    grub-install --recheck /dev/sda
    grub-mkconfig -o /boot/grub/grub.cfg
	
リブート後 dhcp で繋がるように  

    systemctl enable dhcpcd.service
    exit
    reboot

BIOS が起動する直前くらいに USB メモリを引っこ抜く  
何かもっとクールな方法がないものか？  

#### root で login してドライバや Xorg Gnome wifi などを整える

bash で補完が効くように  

    pacman -S bash-completion

自分の環境にあったドライバをインストール  

    lspci|grep VGA
    pacman -S xf86-video-intel
    pacman -S libva-intel-driver
    pacman -S xorg-server xorg-server-utils xorg-xinit xorg-xclock xterm
    pacman -S xf86-input-evdev

gnome は必要最小限だけいれる  

    pacman -S gnome-backgrounds
	pacman -S gnome-calculator
	pacman -S gnome-control-center
	pacman -S gnome-keyring
	pacman -S gnome-shell-extensions
	pacman -S gnome-terminal
	pacman -S gnome-tweak-tool
	pacman -S nautilus
	pacman -S gedit
	

gdm でグラフィカルログインできるようにする  

    pacman -S gdm
    systemctl enable gdm.service

ネット環境を整える  

    pacman -S network-manager
    systemctl list-unit-files
    systemctl disable dhcpcd.service
    systemctl enable NetworkManager.service
    reboot

#### masa で login してホームディレクトリを整える

    sudo pacman -S xdg-user-dirs
    LANG=C xdg-user-dirs-update --force
    sudo pacman -S zsh git vim

#### yaourt を導入する

vim /etc/pacman.conf  

>[archlinuxfr]  
>SigLevel = Never  
>Server = http://repo.archlinux.fr/$arch  

yaourt を最新に同期する  

    sudo pacman -Syy
    sudo pacman -S yaourt
    sudo pacman --sync --refresh yaourt
    yaourt -Syua

dropbox を install して同期する  

    sudo pacman -S dropbox
	dropbox

git clone して dotfiles を用意

    mkdir git
    git clone git@github.com:latestmasa/dotfiles.git dotfiles

--------------------------------------

*ここまで手で打ち込む   ここから make install できる*

--------------------------------------

## 開発環境 install

pacman で入るものをインストール  

    sudo pacman -S firefox  firefox-i18n-ja
    sudo pacman -S otf-ipafont
    sudo pacman -S openssh
    sudo pacman -S dropbox
    sudo pacman -S nautilus-dropbox
    sudo pacman -S ibus-mozc mozc
    sudo pacman -S sylpheed
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

yaourt で入れるものをインストール  

    yaourt google-chrome 
    yaourt ricty
    yaourt peco-git
    yaourt noto-fonts-cjk
    yaourt man-pages-ja
    yaourt global

#### golang

    mkdir -p ~/go/{bin,src}
    go get -u github.com/nsf/gocode
    go get -u github.com/rogpeppe/godef


#### cask install

    yaourt cask
    cd .emacs.d
    cask upgrade
    cask install
    cask update

#### theme を適用

    sudo cp -R ~/Dropbox/arch/OSX-Arc-Shadow/ /usr/share/themes/

#### Trackpoint 

Thinkpad 特有のものをインストール  

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

thinkpad の i915 のみ
>sudo vim /etc/mkinitcpio.conf  

    MODULES="i915"

# Tweak Tool

gnome の細かい設定など

![TweakTool](https://raw.githubusercontent.com/latestmasa/dotfiles/image/image/tweaktool.png)
* キーテーマ  
>Emacs  

* Ctrl キーの位置  
>Caps Lock を Ctrl として使う  

* X サーバーを終了するためのキーシーケンス  
>Ctrl Alt Backspace  

* ワークスペースは１個に固定  

* 電源  

    AC 電源接続時 Blank  
    Don't suspend on lid close  
	
# Terminal

![terminal](https://raw.githubusercontent.com/latestmasa/dotfiles/image/image/terminal.png)
ターミナルサイズ  
134 列 72 行
(Think Pad のサイズ terminal を全画面にするサイズを指定)  

font ricty 15  

#### ターミナルのプロファイル  

solarized Dark  
組み込みのスキーム solarized  

#### .bashrc

どんな時でも bash が起動しないと困るから  
.bashrc は以下の２つのエイリアスを追記する以外はしない  
zsh をデフォルトシェルにして zsh をカスタマイズしまくると  
login できなくなって大変困ったことになるかもしれない。  
まぁそれでも Arch linux なら USB メモリで boot して  

    arch-chroot /mnt /bin/bash

すればいくらでも回復できるから気軽なものだが、  
面倒くさくなって新しいものを受け付けなくなるのは本末転倒であるから  
zsh をデフォルトシェルにはしない。  
tmux を起動したら zsh が起動するようにしておいて  
.bashrc はほぼディストリデフォルトにしておく  

    echo "alias screenstart='screen -D -RR'" >> ~/.bashrc
    echo "alias tmuxstart='tmux new-session -A -s main'" >> ~/.bashrc

terminal を開いて  
screenstart あるいは tmuxstart で起動すると  
セッションがあればそれを利用しなければ新規セッションで zsh が起動する  

# Powertop

消費電力を抑えて省エネ化  
使っていないシステムバスとか徹底的にスリープするようにしてくれる  

>sudo pacman -S powertop  

再起動すると無効になるので  

>sudo powertop --calibrate  

で解析して  

sudo vim /etc/systemd/system/powertop.service  

>[Unit]
>Description=Powertop tunings

>[Service]
>Type=oneshot
>ExecStart=/usr/sbin/powertop --auto-tune

>[Install]
>WantedBy=multi-user.target

    sudo systemctl enable powertop
    reboot

![PowerTop](https://raw.githubusercontent.com/latestmasa/dotfiles/image/image/powertop.png)

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

## 蓋を閉じてもサスペンドしないように

起動 10 秒で emacs までたどりつくのでサスペンドなどしない  
>/etc/systemd/logind.conf  

    #HandleLidSwitch=suspend
    HandleLidSwitch=ignore
	
そして、logind サービスを再起動します:  

    systemctl restart systemd-logind

## ウィンドウを最大化したときに表示に乱れが発生する
Intel HD Graphics のティアリング解消  
>sudo vim /etc/environment

    CLUTTER_PAINT=disable-clipped-redraws:disable-culling
	
追加して Xorg サーバーを再起動

## Activity

![activity](https://raw.githubusercontent.com/latestmasa/dotfiles/image/image/activity.png)
アクティビティ > 設定 > 検索  
全部 off にする  
アプリの起動にしか使わん  

アクティビティ > 設定 > キーボード > ショートカット  

>システム→アクティビティ画面を表示する  を Alt+Space  

Alt+space で alfred っぽく使う

>Ctrl-u  

文字を打ち間違えたら Ctrl-u で全消し  

Activity 画面では Ctrl-h で backspace できないのでつらいがこれでいける  
Ctrl-h できないのは  
g とタイプして tab 押して補完候補をめぐる時(上記の画像)  
GIMP まで移動して Ctrl-h を押すと  
補完候補のトップの Google Cheome に戻る  
っていうか Ctrl-ホニャララで全部補完候補トップに戻りおる  
誰得？  
まぁ Ctrl-u で凌げるからよし。実際のところアプリ呼び出すだけやしね  

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

許容範囲なのでデフォルトで使う  

# Theme
gnome3 テーマインストール  
<http://gnome-look.org> から好きなテーマを持ってきて Dropbox にいれとく  

    sudo cp -R ~/Dropbox/arch/OSX-Arc-Shadow/ /usr/share/themes/

# Mozc
ibus-mozc（gnome のデフォルトは ibus)  
地域と言語で入力ソースを mozc だけにする。  
emacs とかぶらないように shift+Space で mozc を利用する  

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

# ipv6 無効化
必要になったら on にするからそれまでいらん  

sudo vim /etc/sysctl.conf  

>net.ipv6.conf.all.disable_ipv6 = 1  
>net.ipv6.conf.default.disable_ipv6 = 1  

sysctl -p  
で変更を反映させる。  

#### 無効になったかを確認
cat /proc/net/if_inet6   
>00000000000000000000000000000001 01 80 10 80       lo  
>xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 02 40 20 80  enp0s10  

sudo sysctl -p  
>net.ipv6.conf.all.disable_ipv6 = 1  
>net.ipv6.conf.default.disable_ipv6 = 1  

sysctl -p を実行すると変更した内容が表示され、  
また cat /proc/net/if_inet6 で何も表示されなければ無効になっている。  

#### firefox ipv6 無効化
>about:config  
>network.dns.disableIPv6 の値を true  

# Sylpheed

sylpheed 初回起動時に  
Mail フォルダを質問されるので  

> ~/Dropbox/sylpheed/Mail  

に Mail フォルダを指定する。  
1 メール 1 ファイルのファイル形式なので  
Dropbox でメールをすぐ同期すれば  
データロストの心配がない。  

もしあっても最新のメールが一通だけだろう。  
普通サーバーに７日くらいメールはとっておくから  
データロストは心配しなくてもよい。  

#### sylpheed の設定ファイル

ひとしきり設定が終了したら  
dropbox に丸投げして二度と設定作業とかかわらないようにしよう。  

    ln -sfn ~/Dropbox/sylpheed/.sylpheed-2.0 ~/.sylpheed-2.0

最小化した時にトレイアイコンに格納する  
に設定しておくと  
Alt - Tab  
で sylpheed がでてこないのでよい  
コード書いてる時はメールなど見たくないものだ。  
