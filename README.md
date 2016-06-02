# Arch linux or Ubuntu gnome?

Arch Linux で自分最小構成を作るか？  
Ubuntu Gnome でいらないものを削ぎ落とすか？  

何かあった時すぐ仕事に取り掛かれないといけないので  
割と安定していて( LTS なんで安定すると期待して )  
環境構築は最速で用意できる Ubuntu Gnome 16.04 を削ぎ落とす方針とした  

emacs のための環境なのですべて emacs キーバインドにする  


#### ubuntu gnome を usb メモリでインストール

SSD だからインストールは 10 分くらいで終わる  
SSD は暗号化すると TRIM が効かなくなるので  
ディスクを暗号化せず、普通にインストール  

GnomeSoftware から  
dropbox をインストール  

フォルダ名英語化  

    LANG=C xdg-user-dirs-gtk-update  



# Terminal
![terminal](https://raw.githubusercontent.com/latestmasa/dotfiles/image/image/terminal.png)
ターミナルサイズ  
134 列 72 行
(Think Pad のサイズ terminal を全画面にするサイズを指定)  

#### ターミナルのプロファイル  
solarized のパレット５を暗く  
組み込みのスキーム 黒字に緑文字  

#### .bashrc
どんな時でも bash が起動しないと困るから  
.bashrc は以下の２つのエイリアスを追記する以外はしない  
zsh をデフォルトシェルにして zsh をカスタマイズしまくると  
環境に影響を与えすぎて大変なことになることがある。  
この繰り返しで腰が重くなって新しいものを受け付けなくなるのは本末転倒であるから  
zsh をデフォルトシェルにはしない  
バッチ系の処理でも、
デフォルトに近い bash のほうが書きやすい。  
tmux を起動したら zsh が起動するようにしておいて  
.bashrc はほぼディストリデフォルトにしておく  

    echo "alias screenstart='screen -D -RR'" >> .bashrc
    echo "alias tmuxstart='tmux new-session -A -s main'" >> .bashrc

terminal を開いて  
screenstart あるいは tmuxstart で起動すると  
セッションがあればそれを利用しなければ新規セッションで起動する  

screenstart と tmuxstart は shellscript で書かないようにする  
心配なら  

    alias tmuxAI2aGn42Ij7UcmxV='tmux new-session -A -s main'" >> .bashrc  

みたいなファンキーな名前にするとよい  
朝 Treminal を開いて ctrl-r tmux で起動すればいい  
shellscript で tmux 呼ぶプログラマがファンキーだと思うがね  



# Activity
アクティビティ > 設定 > 検索  
全部 off にする  
アプリの起動にしか使わん  

アクティビティ > 設定 > キーボード > ショートカット  
>システム→アクティビティ画面を表示する  を Alt+Space  
↑ GnomeDo っぽく  

#### ショートカットキー  
>Ctrl-u  
文字を打ち間違えたら Ctrl-u で全消し  
なぜか Activity 画面では Ctrl-h で backspace できないのでつらいがこれでいける  



# Tweak Tool
キーテーマ  
>Emacs  

Ctrl キーの位置  
>Caps Lock を Ctrl として使う  

X サーバーを終了するためのキーシーケンス  
>Ctrl Alt Backspace  

ワークスペースは１個に固定  

電源  
>AC 電源接続時 Blank  
>Don't suspend on lid close  



# Firefox
firefox sync を有効化  
ubuntu Modifications を無効化する  

#### Gnome Shell Extention
>Dash to Dock  
>TopIcons Plus  

#### stylish
以下のテーマを利用
<https://userstyles.org/styles/23516/midnight-surfing-global-dark-style>  

defaultfullzoomlevel を 125 ％に  



# Chrome

    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
    sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
    sudo apt-get update
    sudo apt-get install google-chrome-stable
	
デフォルトのサイズを 125 ％に  



# Apt

    sudo apt-get install build-essential ubuntu-restricted-extras exuberant-ctags git traceroute \
    tig nmap vim nkf xsel htop keychain zsh apache2-utils colordiff \
    cifs-utils php7.0-cli screen xclip iotop parcellite vlc \
    clisp sbcl sbcl-doc hyperspec hardinfo manpages-ja manpages-ja-dev \
    inkscape p7zip rar shutter cups-pdf ntfs-config gparted trash-cli \
    dstat testdisk gimp whois mypaint powertop lv curl silversearcher-ag discount \
    byzanz ngrep tcpdump paco sylpheed atool tmux

☆ build-essential = libc6-dev libc-dev gcc g++ make dpkg-dev  


# Theme
gnome3 テーマインストール  
<http://gnome-look.org> から好きなテーマを持ってきて Dropbox にいれとく  

    sudo cp -R ~/Dropbox/ubuntu/OSX-Arc-Shadow/ /usr/share/themes/  



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



# Daemon
不要なデーモンを止める  
まずサービスの起動設定の一覧を表示していらないものを選別する  

    sudo systemctl list-unit-files -t service  

#### 止めるデーモン

    sudo systemctl disable bluetooth.service
    sudo systemctl disable ModemManager.service
    sudo systemctl disable avahi-daemon
    sudo systemctl disable pppd-dns.service
    sudo systemctl disable brltty.service
    sudo systemctl disable ufw.service
    sudo systemctl disable whoopsie.service


#### 不要なプロセスをデフォルトで出すアプリを purge

    sudo apt-get purge deja-dup


#### evolution のプロセスを止める
evolution を apt-get remove すると gnome ごと消えるから注意  
使わないが消すと世界が滅びてしまうため  
evolution のプロセスが起動しないように /dev/null へ  

    cd /usr/share/dbus-1/services
    sudo ln -snf /dev/null  org.gnome.evolution.dataserver.AddressBook.service
    sudo ln -snf /dev/null  org.gnome.evolution.dataserver.Calendar.service 
    sudo ln -snf /dev/null  org.gnome.evolution.dataserver.Sources.service 
    sudo ln -snf /dev/null  org.gnome.evolution.dataserver.UserPrompter.service 



# Tracker-min-fs
たまに CPU を 10 ％くらい使ってうざいから切る  
検索は silversearcher-ag でやるからいらん  
ファイル検索は helm か peco でやるからいらん  

DConf Editor で  
>org > freedesktop > Tracker > Miner > Files:  
>crawling-interval -2  
>enable-monitors false  



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



# Dnsmasq
<https://wiki.archlinux.org/index.php/dnsmasq#NetworkManager>  
によると /etc/NetworkManager/dnsmasq.d に cache-size=1000  
という内容のファイルを cache という名前で置けばいいらしい。  
1000 個までドメイン名を覚えてくれるようになる。  

    sudo su -
    echo cache-size=1000 > /etc/NetworkManager/dnsmasq.d/cache
    service network-manager restart

dnsmasq を正しく設定していれば、このコマンドを二回目に実行すると  
キャッシュされた DNS の IP が使用され、ルックアップの時間が速くなっているはず  

    dig archlinux.org | grep "Query time"
    ;; Query time: 18 msec
    dig archlinux.org | grep "Query time"
    ;; Query time: 2 msec

15 msec くらい早くなったからよい  



# Powertop
消費電力を抑えて省エネ化  
使っていないシステムバスとか徹底的にスリープするようにしてくれる  
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

アイドル時の消費電力が  
18W → 10W になった  
これで一日 16 時間アイドルで  
月間の電気代が 140 円くらいだからよい  
アイドル時以外の消費電力を考慮しても 200 円代ですむ  
キチンと不要なものを省けば  
core2duo の ThinkPad でもアイドル時 CPU 使用率が 3~10 ％ですむ  



# Profile-sync-daemon

chrome firefox の大量の cache やプロファイルをメモリにおいて高速化し  
SSD に同期する頻度を減らすので、SSD の長寿命化対策になる  
体感速度がありえないほど上がるのでオススメ  

    sudo add-apt-repository ppa:graysky/utils
    sudo apt-get update
    sudo apt-get install profile-sync-daemon

#### overlayfs を使う  
sudo su -  
visudo (以下を最終行に追加)   
>masa ALL=(ALL) NOPASSWD: /usr/bin/psd-overlay-helper
	
※ masa は使用するユーザー名

vim ~/.config/psd/psd.conf  
>USE_OVERLAYFS="yes"  
>BROWSERS="google-chrome firefox"  


#### psd 起動する
psd p  
>Profile-sync-daemon v6.21 on Ubuntu 16.04 LTS  

> Systemd service is currently inactive.  
> Systemd resync-timer is currently inactive.  
> Overlayfs technology is currently inactive.  

>Psd will manage the following per /home/masa/.config/psd/psd.conf:  

> browser/psname:  google-chrome/chrome  
> owner/group id:  masa/1000  
> sync target:     /home/masa/.config/google-chrome  
> tmpfs dir:       /run/user/1000/masa-google-chrome  
> profile size:    92M  
> recovery dirs:   none  

> browser/psname:  firefox/firefox  
> owner/group id:  masa/1000  
> sync target:     /home/masa/.mozilla/firefox/h1xyldmq.default  
> tmpfs dir:       /run/user/1000/masa-firefox-h1xyldmq.default  
> profile size:    24M  
> recovery dirs:   none  

#### psd の起動と停止
psd のバージョン 6.x シリーズのリリースから、公式でサポートされる init システムは  
systemd だけになりました。  
Psd には起動と停止を行うための systemd ユーザーサービスが付属しています (psd.service)。  
さらに、1 時間毎に tmpfs からディスクに再同期させる resync-timer も含まれています。  
resync-timer は psd.service によって自動的に起動するため、あなたがタイマーを起動させる必要はありません。  
systemd のユーザーモードの使い方がよくわからない場合、以下のコマンドで psd サービスを有効化できます  

    systemctl --user enable psd.service  
    reboot  


#### 動いているか確認する

    systemctl --user status psd  
	
>● psd.service - Profile-sync-daemon  
>   Loaded: loaded (/usr/lib/systemd/user/psd.service; enabled; vendor preset: enabled)  
>   Active: active (exited) since 水 2016-05-04 16:41:44 JST; 6min ago  
>     Docs: man:psd(1)  
>           man:profile-sync-daemon(1)  
>           https://wiki.archlinux.org/index.php/Profile-sync-daemon  
> Main PID: 1147 (code=exited, status=0/SUCCESS)  
>   CGroup: /user.slice/user-1000.slice/user@1000.service/psd.service  

> 5 月 04 16:41:44 ThinkPad systemd[1142]: Starting Profile-sync-daemon...  
> 5 月 04 16:41:44 ThinkPad systemd[1142]: Started Profile-sync-daemon.  


ドキュメント  
<https://wiki.archlinuxjp.org/index.php/Profile-sync-daemon>  



# SSD
![SSD](https://raw.githubusercontent.com/latestmasa/dotfiles/image/image/baobao.png)

SSD は 120G で十分  

home の半分は git のファイル  
残りは chrome firefox の cache  

usr の半分はフォントやアイコン  
残りは ライブラリ  

var lib は  
カーネルと apt のキャッシュなど  

これ以外は NAS にでも置いとけ  

TRIM を設定する  
cat /etc/cron.weekly/fstrim  

    #!/bin/sh
    # trim all mounted file systems which support it
    /sbin/fstrim --all || true

ubuntu gnome は週一回 TRIM がデフォルトで走るようになっているので  
そのままにしておく。  

#### I/O スケジューラー
cat /sys/block/sda/queue/scheduler  

    noop [deadline] cfq  

デフォルトで deadline になっているはず  
最速は noop だが、大きいファイルは deadline がいいので  
総合的に勘案して deadline にした  
SSD でブロックデバイス暗号化を使っている場合 TRIM はデフォルトでは有効になりません。  
fstrim を定期的に実行している場合 discard フラグは必要ありません。  



# Font

sudo apt-get install fontforge  

<https://github.com/google/fonts/tree/master/ofl/inconsolata>  
Inconsolata-Bold.ttf  
Inconsolata-Regular.ttf  
をとってくる

<http://mix-mplus-ipa.osdn.jp/migu/>  
migu-1m 〜.zip を解凍して  
migu-1m-bold.ttf  
migu-1m-regular.ttf  

<https://github.com/yascentur/Ricty>  
ricty_generator.sh をダウンロード  

    chmod u+x ricty_generator.sh  
    ./ricty_generator.sh migu-1m-regular.ttf migu-1m-bold.ttf Inconsolata-Regular.ttf Inconsolata-Bold.ttf  

#### terminal でも使えるように設定  

    sudo mv Ricty-Bold.ttf /usr/local/share/fonts/  
    sudo mv Ricty-Regular.ttf /usr/local/share/fonts/  
    sudo fc-cache -fv  



# Peco

    sudo apt install golang-go
    go get github.com/peco/peco/cmd/peco
	
update するときは以下で

    go get -u github.com/peco/peco/cmd/peco



# Emacs
![emacs](https://raw.githubusercontent.com/latestmasa/dotfiles/image/image/emacs.png)

    sudo apt-get install autoconf automake gcc make ncurses-dev texinfo libx11-dev libxpm-dev libjpeg-dev libpng-dev libgif-dev libtiff-dev libncurses-dev libgtk-3-dev
    cd git
    git clone git://git.sv.gnu.org/emacs.git
    git checkout emacs-25.1
    ./autogen.sh
    ./configure --with-x-toolkit=gtk3
    make bootstrap
    sudo paco -lp emacs-25.1 "make install"

#### paco
peco と paco は紛らわしいので注意
emacs は好きなバージョンをいつでも使いたいから git でインストール  
emacs をクリーンインストールするため  
paco で emacs を管理する  
emacs25.2 がでたり head を使いたくなったら  

    sudo paco -r emacs-25.1  
	
すると emacs-25.1 でインストールしたファイルがきれいサッパリ消える  



# Cask

    curl -fsSL https://raw.githubusercontent.com/cask/cask/master/go | python  
    cask upgrade  
    cd ~/.emacs.d  
	
Cask ファイルの初期化  

    cask init  
	
Cask に追加した場合  

    cd ~/.emacs.d  
    cask install   
	
cask 自体をアップデートする場合  

    cask upgrade-cask  
	
cask ライブラリをアップデート  

    cask update  



# TrackPoint
xinput  
⎡ Virtual core pointer                    	id=2	[master pointer  (3)]  
⎜   ↳ Virtual core XTEST pointer              	id=4	[slave  pointer  (2)]  
⎜   ↳ TPPS/2 IBM TrackPoint                   	id=10	[slave  pointer  (2)]  
⎣ Virtual core keyboard                   	id=3	[master keyboard (2)]  
    ↳ Virtual core XTEST keyboard             	id=5	[slave  keyboard (3)]  
    ↳ Power Button                            	id=6	[slave  keyboard (3)]  
    ↳ Video Bus                               	id=7	[slave  keyboard (3)]  
    ↳ Sleep Button                            	id=8	[slave  keyboard (3)]  
    ↳ AT Translated Set 2 keyboard            	id=9	[slave  keyboard (3)]  
    ↳ ThinkPad Extra Buttons                  	id=11	[slave  keyboard (3)]  


ポインタ速度を変更して、ちょうどいい速度になる値を確認する。  
ポインタ速度は、1 が無変更、数字が小さくなると速くなり、数字が大きくなると遅くなる。 (小数指定も可能)  
デバイス指定は、デバイス名でもデバイス ID でも、どちらでも可能。  

    xinput --set-prop "マウスのデバイス名" "Device Accel Constant Deceleration" ポインタ速度  

    xinput --set-prop マウスのデバイス ID "Device Accel Constant Deceleration" ポインタ速度  

「自動起動するアプリケーション」に設定する  

Dash またはターミナルから、次のコマンドを実行して、「自動起動するアプリケーション」を開く。  

    gnome-session-properties  

「コマンド」ボックスに、上で確認した「xinput --set-prop "マウスのデバイス名" "Device Accel Constant Deceleration" ポインタ速度」を記入し保存する。  
以上いちいちめんどくさいから  
.zshrc に  

    alias trackpointspeed='xinput --set-prop 10 "Device Accel Constant Deceleration"'  
	
と書いた。  

    trackpointspeed 0.7

  ↑
おすすめの速度
ThinkPad ユーザーは必須と思われる  



# f.lux
ブルーライトカットで目にやさしく  

    sudo add-apt-repository ppa:nathan-renniewaldock/flux
    sudo apt-get update
    sudo apt-get install fluxgui



# go-mode

    go get -u github.com/nsf/gocode
    go get -u github.com/rogpeppe/godef



# GNU GLOBAL
debian の global は古すぎるので make する  
例によって meke するものは paco で管理する  

    wget ftp://ftp.gnu.org/pub/gnu/global/global-6.5.4.tar.gz
    ./global-6.5.4.tar.gz
    cd gloval-6.5.4
    ./configure
    make
    sudo paco -lD "make install"

#### paco
paco で管理しておくとアンインストールが楽  

    sudo paco -r gloval-6.5.4  

global の新バージョンがでたら  

    sudo paco -r gloval-6.5.4  
	
してから新バージョンを  

    sudo paco -lD "make install"  
