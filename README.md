# Arch linux or Ubuntu gnome?

Arch Linuxで自分最小構成を作るか？  
Ubuntu Gnomeでいらないものを削ぎ落とすか？  

何かあった時すぐ仕事に取り掛かれないといけないので  
割と安定していて( LTSなんで安定すると期待して )  
環境構築は最速で用意できる Ubuntu Gnome 16.04を削ぎ落とす方針とした  

emacsのための環境なのですべてemacsキーバインドにする  


#### ubuntu gnomeをusbメモリでインストール

SSDなんで10分くらいで終わる  
SSD なので暗号化するとTRIMが効かなくなるので  
ディスクの暗号化は無しで普通にインストール  

GnomeSoftwareで  
dropboxをインストール  

フォルダ名英語化  

    LANG=C xdg-user-dirs-gtk-update  



# Terminal
![terminal](https://raw.githubusercontent.com/latestmasa/dotfiles/image/image/terminal.png)
ターミナルサイズ  
134列72行 (Think Padのサイズ お好みで)  

#### ターミナルのプロファイル  
solarizedのパレット５を暗くする  
組み込みのスキーム 黒字に緑文字  

#### .bashrc
この２つのエイリアス以外はいじらない  
それはどんな時でも bash が起動しないと困るから  
バッチ系の処理はデフォルトに近い bash のほうが楽だから  
bash はディストリデフォルトで使う  
tmux を起動したら zsh が起動するようにしておいて  
bash はほぼデフォルトにしておく  

    echo "alias screenstart='screen -D -RR'" >> .bashrc
    echo "alias tmuxstart='tmux new-session -A -s main'" >> .bashrc

screenstart と tmuxstart は shellscript で書かないようにする  
心配なら  

    alias tmuxAI2aGn42Ij7UcmxV='tmux new-session -A -s main'" >> .bashrc  

みたいなファンキーな名前にするとよい  
ctrl-r tmux とかで起動すればいい  
シェルスクリプトで tmux 呼ぶプログラマがファンキーだと思うがね  

gnome-terminalを開いて  
screenstart あるいは tmuxstart で起動すると  
セッションがあればそれを利用しなければ新規セッションで起動する  



# Activity
アクティビティ > 設定 > 検索  
全部offにする  
アプリの起動にしか使わん  

アクティビティ > 設定 > キーボード > ショートカット  
システム→アクティビティ画面を表示する  
を Alt+Space ← GnomeDoっぽく  

#### ショートカットキー  
Ctrl-u ← おすすめ  
文字を打ち間違えたらCtrl-uで全消し  
なぜかCtrl-hでbackspaceできないのでつらいがこれで乗り切る  



# Tweak Tool

キーテーマ  
>Emacs  

Ctrlキーの位置  
>Caps Lock をCtrlとして使う  

Xサーバーを終了するためのキーシーケンス  
>Ctrl Alt Backspace  

ワークスペースは１個に固定  

電源  
>AC電源接続時 Blank  
>Don't suspend on lid close  



# Firefox
firefox sync を有効化  
ubuntu Modificationsを無効化する  

#### Gnome Shell Extention
>Dash to Dock  
>TopIcons Plus  

#### stylish
以下のテーマを利用
<https://userstyles.org/styles/23516/midnight-surfing-global-dark-style>  

defaultfullzoomlevel を 125％に  



# Chrome

    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
    sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
    sudo apt-get update
    sudo apt-get install google-chrome-stable
	
デフォルトのサイズを125％に  



# Apt-get

    sudo apt-get install build-essential ubuntu-restricted-extras exuberant-ctags git traceroute \
    tig nmap vim nkf xsel htop keychain zsh apache2-utils colordiff \
    cifs-utils php7.0-cli screen xclip iotop parcellite vlc \
    clisp sbcl sbcl-doc hyperspec hardinfo manpages-ja manpages-ja-dev \
    inkscape p7zip rar shutter cups-pdf ntfs-config gparted trash-cli \
    dstat testdisk gimp whois mypaint powertop lv curl silversearcher-ag discount \
    byzanz ngrep tcpdump paco sylpheed atool tmux

☆ build-essential = libc6-dev libc-dev gcc g++ make dpkg-dev  


# Theme
gnome3テーマインストール  
gnome-look.org から好きなテーマを持ってきてDropboxにいれとく  

    sudo cp -R ~/Dropbox/ubuntu/OSX-Arc-Shadow/ /usr/share/themes/  



# Mozc
ibus-mozc（gnomeのデフォルトはibus)  
地域と言語で入力ソースをmozcだけにする。  
emacsとかぶらないように shift+Space でmozcを利用する  

ON/OFF のキーバインドは、今までの「IBus の設定」ではなく  
Mozc の「プロパティ」の「一般」タブにある「キーの設定」で設定できます。  
例えば、shift+Space で ON/OFF を切り替えるには、次のエントリーを追加するか、  
または最初から登録されている「Hankaku/Zenkaku」キーへの割り当てを書き換えます。  

キー設定はことえりをベースに ← emacsキーバインドに一番近い  

>「変換前入力中」「shift+Space」「IME を無効化」  
>「変換中」「shift+Space」「IME を無効化」  
>「直接入力」「shift+Space」「IME を有効化」  
>「入力文字なし」「shift+Space」「IME を無効化」  
>他のshift-space絡みのショートカットは削除しておく。  

ターミナルで

    ibus-setup
	
でフォントなど設定する。  
全般タブで  
>カスタムフォントを選んで fontsize 14  
>次のインプットメソッド super-space  
>インプットメソッドタブを mozcだけにする  
これでreboot  


#### mozc用辞書インストール
<http://mediadesign.jp/article-4218/>  
住所とかキーボードで打ちたくないから  
郵便番号を入れると住所がでるようにしておく  
アーカイブには3つのファイルが入っています。  
Zipcode_J_Mzc  
　┣　Readme_J.txt  
　┣　zipcode_j_3_4.txt  
　┗　zipcode_j_7.txt  
辞書ファイルはハイフン有無により２種類。  
・zipcode_j_3_4.txt  
　郵便番号がハイフンでつながれた１２３-４５６７の形式で入力し変換する辞書  
・zipcode_j_7.txt  
　郵便番号がハイフンなしの７桁の数字１２３４５６７の形式で入力し変換する辞書  
Mozc辞書ツールを起動しメニューの［管理］＞［新規辞書にインポート］を選択。  

mozcの設定が完成したら  

    ln -sfn ~/Dropbox/mozc/.mozc ~/.mozc  
	
でmozcの設定はDropboxに投げておく  



# Daemon
不要なデーモンを止める  
サービスの起動設定の一覧を表示  

    sudo systemctl list-unit-files -t service  

#### 止めるデーモン

    sudo systemctl disable bluetooth.service
    sudo systemctl disable ModemManager.service
    sudo systemctl disable avahi-daemon
    sudo systemctl disable pppd-dns.service
    sudo systemctl disable brltty.service
    sudo systemctl disable ufw.service
    sudo systemctl disable whoopsie.service


#### 不要なプロセスをデフォルトで出すアプリをpurge

    sudo apt-get purge deja-dup


#### evolutionのプロセスを止める
evolution を apt-get remove すると gnome ごと消えるから注意  
使わないが消すと世界が滅びてしまうため  
evolutionのプロセスが起動しないように /dev/null へ  
(困った時の /dev/null 愚痴は /dev/null へ)  

    cd /usr/share/dbus-1/services
    sudo ln -snf /dev/null  org.gnome.evolution.dataserver.AddressBook.service
    sudo ln -snf /dev/null  org.gnome.evolution.dataserver.Calendar.service 
    sudo ln -snf /dev/null  org.gnome.evolution.dataserver.Sources.service 
    sudo ln -snf /dev/null  org.gnome.evolution.dataserver.UserPrompter.service 



# Tracker-min-fs
たまにCPUを10％くらい使ってうざいから切る  
検索は silversearcher-ag でやるからいらん  
ファイル検索は helm か peco でやるからいらん  

DConf Editorで  
>org > freedesktop > Tracker > Miner > Files:  
>crawling-interval -2  
>enable-monitors false  



# ipv6無効化
必要になったらonにするからそれまでいらん  

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

sysctl -pを実行すると変更した内容が表示され、  
またcat /proc/net/if_inet6で何も表示されなければ無効になっている。  


#### firefox ipv6無効化
>about:config  
>network.dns.disableIPv6の値をtrue  



# Dnsmasq
<https://wiki.archlinux.org/index.php/dnsmasq#NetworkManager>  
によると /etc/NetworkManager/dnsmasq.d に cache-size=1000  
という内容のファイルを cache という名前で置けばいいらしい。  
1000 個までドメイン名を覚えてくれるようになる。  

    sudo su -
    echo cache-size=1000 > /etc/NetworkManager/dnsmasq.d/cache
    service network-manager restart

dnsmasq を正しく設定していれば、このコマンドを二回目に実行すると  
キャッシュされた DNS の IP が使用され、ルックアップの時間が速くなっているはずです  

    dig archlinux.org | grep "Query time"
    ;; Query time: 18 msec
    dig archlinux.org | grep "Query time"
    ;; Query time: 2 msec

15 msec くらい早くなるからよい  



# Powertop
消費電力を抑えて省エネ化  
使っていないシステムバスとか徹底的にスリープするようにしてくれる  
再起動すると無効になるので  
sudo powertop --calibrate  
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
これで一日１６時間アイドルで  
月間の電気代が140円くらいだからよい  
アイドル時以外の消費電力を考慮しても200円代ですむ  
キチンと不要なものを省けば  
core2duoのThinkPadでもアイドル時CPU使用率が3~10％ですむ  



# Profile-sync-daemon

chrome firefox の大量のcacheやプロファイルをメモリにおいて高速化し  
SSDに同期する頻度を減らすので、SSDの長寿命化対策になる  
体感速度がありえないほど上がるのでオススメ  

    sudo add-apt-repository ppa:graysky/utils
    sudo apt-get update
    sudo apt-get install profile-sync-daemon

#### overlayfsを使う  
sudo su -  
visudo (以下を最終行に追加)   
>masa ALL=(ALL) NOPASSWD: /usr/bin/psd-overlay-helper
	
※masaは使用するユーザー名

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
さらに、1時間毎に tmpfs からディスクに再同期させる resync-timer も含まれています。  
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

> 5月 04 16:41:44 ThinkPad systemd[1142]: Starting Profile-sync-daemon...  
> 5月 04 16:41:44 ThinkPad systemd[1142]: Started Profile-sync-daemon.  


ドキュメント  
<https://wiki.archlinuxjp.org/index.php/Profile-sync-daemon>  



# SSD
TRIMを設定する  
cat /etc/cron.weekly/fstrim  

    #!/bin/sh
    # trim all mounted file systems which support it
    /sbin/fstrim --all || true

ubuntu gnomeは週一回 TRIM がデフォルトで走るようになっているので  
そのままにしておく。  

#### I/O スケジューラー
cat /sys/block/sda/queue/scheduler  

    noop [deadline] cfq  

デフォルトでdeadlineになっているはず  
最速はnoopだが、大きいファイルはdeadlineがいいので  
総合的に勘案してdeadlineにした  
SSD でブロックデバイス暗号化を使っている場合 TRIM はデフォルトでは有効になりません。  
fstrim を定期的に実行している場合 discard フラグは必要ありません。  



# Font

sudo apt-get install fontforge  

<https://github.com/google/fonts/tree/master/ofl/inconsolata>  
Inconsolata-Bold.ttf  
Inconsolata-Regular.ttf  
をとってくる

<http://mix-mplus-ipa.osdn.jp/migu/>  
migu-1m〜.zipを解凍して  
migu-1m-bold.ttf  
migu-1m-regular.ttf  

<https://github.com/yascentur/Ricty>  
ricty_generator.shをダウンロード  

    chmod u+x ricty_generator.sh  
    ./ricty_generator.sh migu-1m-regular.ttf migu-1m-bold.ttf Inconsolata-Regular.ttf Inconsolata-Bold.ttf  

#### terminalでも使えるように以下も設定  

    sudo mv Ricty-Bold.ttf /usr/local/share/fonts/  
    sudo mv Ricty-Regular.ttf /usr/local/share/fonts/  
    sudo fc-cache -fv  



# Peco

    sudo apt install golang-go
    go get github.com/peco/peco/cmd/peco
	
updateするときは以下で

    go get -u github.com/peco/peco/cmd/peco



# Emacs

    sudo apt-get install autoconf automake gcc make ncurses-dev texinfo libx11-dev libxpm-dev libjpeg-dev libpng-dev libgif-dev libtiff-dev libncurses-dev libgtk-3-dev
    cd git
    git clone git://git.sv.gnu.org/emacs.git
    git checkout emacs-25.1
    ./autogen.sh
    ./configure --with-x-toolkit=gtk3
    make bootstrap
    sudo paco -lp emacs-25.1 "make install"

#### paco
emacsは好きなバージョンをいつでも使えるように git からインストール  
いつでもクリーンインストールできるように  
paco で emacs を管理する  
emacs25.2 がでたり head を使いたくなったら  

    sudo paco -r emacs-25.1  
	
すると綺麗に消えるのでクリーンになる  



# Cask

    curl -fsSL https://raw.githubusercontent.com/cask/cask/master/go | python  
    cask upgrade  
    cd ~/.emacs.d  
	
Caskファイルの初期化  

    cask init  
	
Caskに追加した場合  

    cd ~/.emacs.d  
    cask install   
	
cask自体をアップデートする場合  

    cask upgrade-cask  
	
caskライブラリをアップデート  

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
.zshrcに  

    alias trackpointspeed='xinput --set-prop 10 "Device Accel Constant Deceleration"'  
	
と書いた。  

    trackpointspeed 0.7

  ↑
おすすめの速度
ThinkPadユーザーは必須と思われる  



# f.lux
ブルーライトカットで目をいたわる  

    sudo add-apt-repository ppa:nathan-renniewaldock/flux
    sudo apt-get update
    sudo apt-get install fluxgui



# go-mode

    go get -u github.com/nsf/gocode
    go get -u github.com/rogpeppe/godef



# GNU GLOBAL
debian の global は古すぎるのでmakeする  
mekeするものはpacoで管理する  

    wget ftp://ftp.gnu.org/pub/gnu/global/global-6.5.4.tar.gz
    ./global-6.5.4.tar.gz
    cd gloval-6.5.4
    ./configure
    make
    sudo paco -lD "make install"

#### paco
pacoで管理しておくとアンインストールが楽  

    sudo paco -r gloval-6.5.4  

globalの新バージョンがでたら  

    sudo paco -r gloval-6.5.4  
	
してから新バージョンを  

    sudo paco -lD "make install"  
