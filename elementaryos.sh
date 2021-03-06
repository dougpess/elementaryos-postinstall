#!/bin/bash

## GUIA PÓS INSTALAÇÃO LINUX ELEMENTARY ##

# - Ativar o Firewall
	sudo ufw default DENY
	sudo ufw enable
    
# - Mudar o nome do host (nome da máquina
	hostnamectl set-hostname --static 'elementaryOS'

# - Manter tudo atualizado
	sudo apt update
	sudo apt upgrade -y
	sudo apt update -y
	sudo apt dist-upgrade -y

# - Primeira limpeza
	sudo apt autoremove -y
	sudo apt install -f -y

# - Essenciais
	echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections
	sudo apt install build-essential python-software-properties software-properties-common ttf-mscorefonts-installer ubuntu-restricted-addons ubuntu-restricted-extras -y

# - Preload
	sudo apt install -y preload
	sudo sed -i 's|^cycle *=.*|cycle = 30|' /etc/preload.conf
	sudo sed -i 's|^memcached *=.*|memcached = 20|' /etc/preload.conf
	sudo sed -i 's|^mapprefix *=.*|mapprefix = /usr/;/lib;/opt/;/var/cache/;!/|' /etc/preload.conf
	sudo sed -i 's|^exeprefix *=.*|exeprefix = !/usr/sbin/;!/usr/local/sbin/;/usr/;/opt/;!/|' /etc/preload.conf
	sudo /etc/init.d/preload restart

# - Prelink
	sudo apt install -y prelink
	sudo sed -i 's|^PRELINKING=unknown|PRELINKING=yes|' /etc/default/prelink
	sudo sed -i 's|^PRELINK_OPTS=-mR|PRELINK_OPTS=-amR|' /etc/default/prelink
	echo 'dpkg::Post-Invoke {"echo Executando prelink ...;/etc/cron.daily/prelink";}' | sudo tee /etc/apt/apt.conf.d/98prelink
	sudo prelink -amvR
    
# - Alguns Tunning
	sudo echo 'vm.vfs_cache_pressure = 200' >> /etc/sysctl.conf
	sudo echo 'vm.dirty_background_ratio = 8' >> /etc/sysctl.conf
	sudo echo 'vm.dirty_ratio = 25' >> /etc/sysctl.conf
	sudo echo 'vm.swappiness = 10' >> /etc/sysctl.conf
	sudo sed -i s/NoDisplay=true/NoDisplay=false/g /etc/xdg/autostart/*.desktop

## - Reiniciar o computador após estas últimas instalações ##

# - Limpeza do sistema
	sudo apt clean -y
	sudo apt autoclean -y
	sudo apt autoremove -y
	sudo apt install -f -y

# - Adicionando repositórios (Desmarque aqueles que julgar necessário)
	sudo add-apt-repository -y 'ppa:atareao/atareao'
	sudo add-apt-repository -y 'ppa:brightbox/ruby-ng'
	#sudo add-apt-repository -y 'ppa:gnome-shell-extensions'
	#sudo add-apt-repository -y 'ppa:graphics-drivers/ppa'
	sudo add-apt-repository -y 'ppa:n-muench/programs-ppa'
	sudo add-apt-repository -y 'ppa:nilarimogard/webupd8' # Albert e NetSpeed Indicator
	sudo add-apt-repository -y 'ppa:noobslab/apps'
	sudo add-apt-repository -y 'ppa:noobslab/icons'
	sudo add-apt-repository -y 'ppa:noobslab/macbuntu' # Temas Mac Like
	sudo add-apt-repository -y 'ppa:noobslab/themes'
	sudo add-apt-repository -y 'ppa:numix/ppa' # Numix Temas, Ícones e Outros

# Atualizando a lista de repositórios
	sudo apt update;sudo apt autoremove -y

# - Instalar bibliotecas e dependências
	# alguns pacotes estão desatualizados ou não servem
	sudo apt install -y bridge-utils gir1.2-granite-1 gtk2-engines-pixbuf ipxe-qemu jbig2dec jbigkit-bin kdelibs-bin kdelibs5-data kdelibs5-plugins latexmk libaio1 libavcodec-extra libboost-random1.58.0 libcacard0 libcurl3 libcurl4-openssl-dev libfdt1 libfilezilla0 libgeos-dev libgranite-common libgranite2 libiodbc2 libiodbc2-dev libiscsi2 libjbig-dev libjbig0 libjbig2dec0 libjbig2dec0-dev libjpeg8-dev libnss3-tools libopenal-dev libpng12-dev libqt4-declarative libqt4-network libqt4-opengl libqtgui4 librados2 librbd1 libspice-server1 libusbredirparser1 libvirt-bin libx11-dev libxen-4.6 libxenstore3.0 libxft-dev mesa-utils qemu-block-extra qemu-system-common qemu-system-x86 seabios

# - Instalar Codecs
	sudo apt install -y ffmpeg lame libdvdread4 libavcodec-extra
	
# - Instalar compiladores
	sudo apt install -y bwbasic clang cmake make cpp cppcheck g++ "g++-multilib" gcc "gcc-multilib" colorgcc gperf python gfortran gfortran-doc ratfor fpc fpc-source ruby ruby-dev
	ln -s /usr/bin/colorgcc /usr/local/sbin/g++
	ln -s /usr/bin/colorgcc /usr/local/sbin/gcc

# - Instalar softwares de sistema
	sudo apt install -y bleachbit cups clamav clamav-docs clamav-base clamav-freshclam eog fuse exfat-utils exfat-fuse gdebi gdebi-core gnome-colors-common gnome-color-manager gnome-disk-utility gnome-system-monitor gedit gparted gpart htop icc-profiles-free keepassx memtest86+ nano powertop redshift redshift-gtk synaptic screenfetch testdisk testdisk-dbg
	
# - Compactadores e Descompactadores de Arquivos
	sudo apt install -y arj ark cabextract file-roller mpack p7zip p7zip-full rar unace unrar unzip zip

# Rapid Photo Downloader
	sudo add-apt-repository -y ppa:dlynch3
	sudo apt update;sudo apt autoremove -y
	sudo apt install -y rapid-photo-downloader
	
# Android Rules
	sudo wget -O /etc/udev/rules.d/51-android.rules https://raw.githubusercontent.com/NicolasBernaerts/ubuntu-scripts/master/android/51-android.rules
	sudo chmod a+r /etc/udev/rules.d/51-android.rules
	sudo service udev restart
	sudo apt install -y android-tools-adb android-tools-fastboot

# DupeGuru
	sudo apt-add-repository -y ppa:hsoft/ppa
	sudo apt update;sudo apt autoremove -y
	sudo apt install -y dupeguru-se

# Intel Tearing Fix
	#sudo mkdir /etc/X11/xorg.conf.d/
	#echo -e 'Section "Device"\n Identifier "Intel Graphics"\n Driver "Intel"\n Option "AccelMethod" "sna"\n Option "TearFree" "true"\nEndSection' | sudo tee /etc/X11/xorg.conf.d/20-intel.conf

# TLP
	sudo add-apt-repository -y ppa:linrunner/tlp
	sudo apt update;sudo apt autoremove -y
	sudo apt install -y tlp tlp-rdw
	sudo tlp start
	
# Ferramentas ISO e USB
	sudo apt install -y acetoneiso furiusisomount unetbootin usb-creator-gtk gnome-multi-writer
	
# - Wine. DosBox e outros emuladores
	sudo apt install -y wine wine-gecko winetricks xterm playonlinux dosbox
	
# - Limpeza
	sudo apt clean -y
	sudo apt autoclean -y
	sudo apt autoremove -y
	sudo apt install -f -y

# Oracle OpenJDK (Java JRE/JDK)
	sudo apt install -y openjdk-8-jre openjdk-8-jdk

# Oracle Java (Java JRE/JDK)
	sudo add-apt-repository -y ppa:webupd8team/java
	sudo apt update;sudo apt autoremove -y
	echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
	sudo apt install -y oracle-java6-installer oracle-java7-installer oracle-java8-installer oracle-java9-installer;sudo apt install -y oracle-java8-set-default

# Softwares Multimídia
	sudo apt install -y gaupol k3b kdenlive lives lives-data devede easytag pavucontrol pitivi pulseaudio-equalizer rhythmbox rhythmbox-mozilla sound-juicer vlc vlc-plugin-vlsub vlc-plugin-notify browser-plugin-vlc brasero kazam

# Audacity (Editor de Áudio)
	sudo add-apt-repository -y ppa:audacity-team/daily
	sudo apt update;sudo apt autoremove -y
	sudo apt install -y audacity

# Clementine (Player de Áudio)
	sudo add-apt-repository -y ppa:me-davidsansome/clementine
	sudo apt update;sudo apt autoremove -y
	sudo apt install -y clementine

# Spotify Client (Cliente Spotify)
	# 1. Add the Spotify repository signing key to be able to verify downloaded packages
	sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys BBEBDCB318AD50EC6865090613B00F1FD2C19886
	# 2. Add the Spotify repository
	echo deb http://repository.spotify.com stable non-free | sudo tee /etc/apt/sources.list.d/spotify.list
	# 3. Update list of available packages
	sudo apt update
	# 4. Install Spotify
	sudo apt install -y spotify-client

# MusicBrainz (Picard)
	sudo add-apt-repository -y ppa:musicbrainz-developers/stable
	sudo apt-get update;sudo apt autoremove -y
	sudo apt install -y picard

# Vocal (PodCast)
	sudo add-apt-repository -y ppa:nathandyer/vocal-daily
	sudo apt update;sudo apt autoremove -y
	sudo apt install -y vocal

# OpenShot (Editor de Vídeo)
	sudo add-apt-repository -y ppa:openshot.developers/ppa
	sudo apt update;sudo apt autoremove -y
	sudo apt install -y openshot openshot-doc frei0r-plugins

# Simple Screen Recorder (Screencast)
	sudo add-apt-repository -y ppa:maarten-baert/simplescreenrecorder
	sudo apt update;sudo apt autoremove -y
	sudo apt install -y simplescreenrecorder

# VidMasta (Download de Vídeos like Popcorn-Time)
	# wget http://ufpr.dl.sourceforge.net/project/vidmasta/vidmasta-setup-21.9.jar -O /home/brcmesquita/Downloads/vidmasta.jar
	# sudo chmod +x /home/brcmesquita/Downloads/vidmasta.jar
	
# Atalho do VidMasta	
	# echo -e '[Desktop Entry]
	# Version=1.0
	# Name=vidmasta
	# Exec=/usr/local/VidMasta/vidmasta/VidMasta.jar
	# Icon=/usr/local/VidMasta/vidmasta/favicon.ico
	# Type=Application
	# Categories=Application' | sudo tee /usr/share/applications/vidmasta.desktop
	# sudo chmod +x /usr/share/applications/vidmasta.desktop

# Ferramentas de edição de imagens, fotos etc
	sudo apt install -y birdfont blender gthumb krita luminance-hdr rawtherapee shutter tgif ufraw ufraw-batch

# Darktable
	sudo add-apt-repository -y ppa:pmjdebruijn/darktable-release
	sudo apt update;sudo apt autoremove -y
	sudo apt install -y darktable
	
# Gimp
	sudo add-apt-repository -y ppa:otto-kesselgulasch/gimp
	sudo apt update;sudo apt autoremove -y
	sudo apt install -y gimp gmic gimp-data gimp-data-extras gimp-gmic gimp-plugin-registry gimp-ufraw gnome-xcf-thumbnailer

# Inkscape
	sudo add-apt-repository -y ppa:inkscape.dev/stable
	sudo apt update;sudo apt autoremove -y
	sudo apt install -y inkscape

# Ferramentas de Escritório, Projetos, Produção etc
	sudo apt install -y dia texlive texlive-latex-extra planner umbrello

# LibreOffice 5
	sudo add-apt-repository -y ppa:libreoffice/ppa
	sudo add-apt-repository -y ppa:libreoffice/libreoffice-5-0
	sudo apt update;sudo apt autoremove -y
	sudo apt install -y libreoffice libreoffice-l10n-br libreoffice-style-sifr

# WPS Office
	cd /tmp;wget -c http://kdl.cc.ksosoft.com/wps-community/download/a21/wps-office_10.1.0.5672~a21_amd64.deb
    wget -c http://kdl.cc.ksosoft.com/wps-community/download/fonts/wps-office-fonts_1.0_all.deb
    sudo dpkg -i wps-office*
    rm wps-office*
    cd /opt/kingsoft/wps-office/office6/dicts/
    sudo wget -c http://wps-community.org/download/dicts/pt_BR.zip
    sudo unzip pt_BR.zip
    sudo chmod +x -R pt_BR
    sudo rm pt_BR.zip
    cd $HOME

# Ferramentas de Redes e Internet
	sudo apt install -y curl corebird ethtool filezilla nmap tmux traceroute firefox thunderbird network-manager-openvpn openssh-client openssh-server "openssh-sftp-server" openssl samba samba-common ssh rsync telnet uget wireshark wget youtube-dl youtube-dlg mpv youtube-viewer rdesktop remmina remmina-plugin-*

# Dropbox
	cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -

# qBitTorrent Client
	#sudo add-apt-repository -y ppa:qbittorrent-team/qbittorrent-stable
	#sudo apt update;sudo apt autoremove -y
	#sudo apt install -y qbittorrent

# Deluge BitTorrent Client
	sudo add-apt-repository -y ppa:deluge-team/ppa
	sudo apt update;sudo apt autoremove -y
	sudo apt install -y deluge

# Feed Reader
	#sudo add-apt-repository -y ppa:eviltwin1/feedreader-stable
	#sudo apt update;sudo apt autoremove -y
	#sudo apt install -y feedreader

# Geary
	#http://www.webupd8.org/2016/05/new-version-of-linux-email-client-geary.html
	#sudo add-apt-repository -y ppa:geary-team/releases
	sudo apt update;sudo apt autoremove -y
	#sudo apt install -y geary

# Google Chrome
	wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
	sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list'
	sudo apt update;sudo apt autoremove -y
	sudo apt install -y google-chrome-stable

# HexChat (IRC)
	sudo add-apt-repository -y ppa:gwendal-lebihan-dev/hexchat-stable
	sudo apt update;sudo apt autoremove -y
	sudo apt install -y hexchat

# Telegram
	sudo add-apt-repository -y ppa:atareao/telegram
	sudo apt update;sudo apt autoremove -y
	sudo apt install -y telegram

# Ferramentas de Desenvolvimento
	sudo apt install -y eclipse gambas3 gitk git-core meld lazarus monodevelop netbeans nodejs npm ruby ruby-dev
	ln -s /usr/bin/nodejs /usr/bin/node
    curl https://install.meteor.com/ | sh

# Android Studio
	sudo add-apt-repository -y ppa:paolorotolo/android-studio
	sudo apt update;sudo apt autoremove -y
	sudo apt install -y android-studio

# Atom
	#sudo add-apt-repository -y ppa:webupd8team/atom
	#sudo apt update;sudo apt autoremove -y
	#sudo apt install -y atom

# Bluefish
	#sudo add-apt-repository -y ppa:klaus-vormweg/bluefish
	#sudo apt update;sudo apt autoremove -y
	#sudo apt install -y bluefish

# Brackets
	sudo add-apt-repository -y ppa:webupd8team/brackets
	sudo apt update;sudo apt autoremove -y
	sudo apt install -y brackets

# Code::Blocks
	sudo add-apt-repository -y ppa:damien-moore/codeblocks-stable
	sudo apt update;sudo apt autoremove -y
	sudo apt install -y codeblocks

# Compiladores Python
	#sudo add-apt-repository -y ppa:fkrull/deadsnakes
	#sudo apt update;sudo apt autoremove -y
	#sudo apt install -y "python-pip" "python-dev" "python-matplotlib" "python-glade2 python-imaging"

# JetBrains (IDE Java)
    cd /tmp
	mkdir /opt/idea/
    wget https://download.jetbrains.com/idea/ideaIC-2016.2.4.tar.gz
    chmod +x ideaIC-2016.2.4.tar.gz
    sudo tar -xvzf ideaIC-2016.2.4.tar.gz
	mv idea-IC-162.2032.8 idea
	mv idea /opt/
    rm ideaIC-2016.2.4.tar.gz
	cd $HOME
	# Último passo da instalação. Digite no terminal
	#sh /opt/idea/bin/idea.sh

# Sublime Text 3
	sudo add-apt-repository -y ppa:webupd8team/sublime-text-3
	sudo apt update;sudo apt autoremove -y
	sudo apt install -y sublime-text-installer

# Microsoft Visual Studio Code
	cd /tmp
	wget https://go.microsoft.com/fwlink/?LinkID=760868 -O visual_code.deb
	chmod +x visual_code.deb
	sudo dpkg -i visual_code.deb
	rm visual_code.deb
	cd $HOMEv

# Ferramentas de Banco de Dados
	sudo apt install -y flamerobin mysql-workbench pgadmin3

# Jogos
	sudo apt install -y 0ad 0ad-data wesnoth unvanquished

# Steam
	# Verificar qual dos dois é o certo
	echo steam steam/accepted-steam-eula select true | debconf-set-selections
	sudo apt install -y steam

# Get DEB & Play DEB
	touch /etc/apt/sources.list.d/getdeb.list
	touch /etc/apt/sources.list.d/getdeb.list
	echo 'deb http://archive.getdeb.net/ubuntu xenial-getdeb apps' > /etc/apt/sources.list.d/getdeb.list
	echo 'deb http://archive.getdeb.net/ubuntu xenial-getdeb games' > /etc/apt/sources.list.d/playdeb.list
	wget -q -O- http://archive.getdeb.net/getdeb-archive.key | sudo apt-key add -
	sudo apt update && sudo apt autoremove -y

# Customização de Menus
	sudo apt install -y alacarte

# Customização DBConf
	sudo apt install -y dbconf

# Albert
	sudo apt install -y albert
	
# Caffeine Plus
	sudo apt install -y caffeine-plus
	
# My Weather Indicator
	#sudo apt install -y my-weather-indicator
	
# Indicator Netspeed
	sudo apt install -y indicator-netspeed
	
# Indicator Brightness
	#sudo add-apt-repository -y ppa:indicator-brightness/ppa
	#sudo apt update;sudo apt autoremove -y
	#sudo apt install -y indicator-brightness

# Indicator Keylock
	sudo add-apt-repository -y ppa:tsbarnes/indicator-keylock
	sudo apt update;sudo apt autoremove -y
	sudo apt install -y indicator-keylock

# Indicator SYSMonitor
	#sudo add-apt-repository -y ppa:fossfreedom/indicator-sysmonitor
	sudo apt update;sudo apt autoremove -y
	#sudo apt install -y indicator-sysmonitor
	
# Todo Indicator
	sudo apt install -y todo-indicator # Após intalar use: todo-indicator todo.txt
	
	# Para alterar o diretório de dados do ToDo, vá nos aplicativos de inicialização e altere o comando para:
	#/usr/bin/todo-indicator /home/usuario/todo.txt
	
# Remind
	sudo apt install -y remind

# Syspeek
	sudo apt install -y syspeek
	
# Diodon (Lightweight Clipboard Manager)
	#sudo add-apt-repository -y ppa:diodon-team/stable
	#sudo apt update;sudo apt autoremove -y
	#sudo apt install -y diodon
	
# Temas
	# Arc
	sudo apt install -y arc-theme
	
	# Faba
	sudo apt install -y faba-icon-theme
	
	# Numix
	sudo apt install -y numix-gtk-theme numix-icon-theme numix-icon-theme-circle
	
	# MacBuntu v4 (Ubuntu 14.04)
	#sudo apt install -y mbuntu-y-docky-skins-v4 mbuntu-y-lightdm-v4
	
	# MacBuntu v7 (Ubuntu 16.04)
	sudo apt install -y macbuntu-os-ithemes-lts-v7 macbuntu-os-icons-lts-v7 macbuntu-os-bscreen-lts-v7
	#sudo apt install -y macbuntu-os-lightdm-lts-v7 
	#ou
	sudo apt install -y macbuntu-os-*
	
	# Moka (icons)
	#sudo add-apt-repository -y ppa:moka/stable
	sudo apt update;sudo apt autoremove -y
	#sudo apt install moka-icon-theme -y

	# Nitrux
	#sudo add-apt-repository -y ppa:nitrux-team/nitrux-artwork
	sudo apt update;sudo apt autoremove -y
	#sudo apt install -y nitrux-icon-theme

	# Paper GTK Theme n' Icon Theme
	#sudo add-apt-repository -y ppa:snwh/pulp
	sudo apt update;sudo apt autoremove -y
	#sudo apt install -y paper-gtk-theme
	#sudo apt install -y paper-icon-theme
	
	# Vibrancy e Vivacious Colors
	sudo add-apt-repository -y ppa:ravefinity-project/ppa
	sudo apt update;sudo apt autoremove -y
	#sudo apt install -y vibrancy-colors
	#sudo apt install -y vivacious-colors
	#sudo apt install -y vivacious-folder-colors-addon
	#sudo apt install -y vivacious-colors-gtk-dark
	
# Conky e Conky Manager
	sudo add-apt-repository -y ppa:teejee2008/ppa
	sudo apt update;sudo apt autoremove -y
	sudo apt install -y conky conky-all conky-manager

# Docky
	#sudo add-apt-repository -y ppa:docky-core/ppa
	#sudo add-apt-repository -y ppa:docky-core/stable
	sudo apt update;sudo apt autoremove -y
	#sudo apt install -y docky

# Plank
	#sudo add-apt-repository -y ppa:ricotz/docky
	sudo apt update;sudo apt autoremove -y
	#sudo apt install -y plank
	#sudo apt install -y plank-themer

# XFonts
	#   xfonts-75dpi
	#   xfonts-100dpi
	#      then run: xset fp rehash  if already logged in so current X-session sees the fonts
	sudo apt install -y xfonts-100dpi xfonts-75dpi

# KVM
	#sudo apt install -y qemu-kvm virt-manager
	#sudo adduser usuário libvirt
	
	# Testar
	#virsh -c qemu:///system list

# Oracle VM VirtualBox
	sudo apt install -y dkms virtualbox virtualbox-dkms virtualbox-guest-additions-iso virtualbox-guest-utils virtualbox-qt

# Hashicorp Vagrant
	sudo apt install -y vagrant

# NVIDIA Tearing
	sudo apt install -y compizconfig-settings-manager

#### TWEAKS ####
# Elementary OS Freya 0.3
	#sudo add-apt-repository -y ppa:mpstark/elementary-tweaks-daily
	#sudo apt update;sudo apt autoremove -y
	#sudo apt install elementary-tweaks -y
# Elementary OS Loki 0.4
	sudo add-apt-repository -y ppa:philip.scott/elementary-tweaks
	sudo apt update;sudo apt autoremove -y
	sudo apt install -y elementary-tweaks

# Pepper Flash Player/Fresh Player Plugin
	sudo add-apt-repository -y ppa:nilarimogard/webupd8
	sudo apt update;sudo apt autoremove -y
	sudo apt install -y pepperflashplugin-nonfree freshplayerplugin

#### DESCONTINUADOS ####

# Pipelight
	#sudo add-apt-repository -y ppa:pipelight/stable
	sudo apt update;sudo apt autoremove -y
	#sudo apt install pipelight -y
	#sudo apt install pipelight-multi -y

# Pipelight Plugins
	#echo "y" | sudo pipelight-plugin --create-mozilla-plugins
	#echo "y" | sudo pipelight-plugin --update
	#echo "y" | sudo pipelight-plugin --unlock viewright-caiway
	#echo "y" | sudo pipelight-plugin --unlock vizzedrgr
	#echo "y" | sudo pipelight-plugin --enable silverlight
	#echo "y" | sudo pipelight-plugin --enable flash
	#echo "y" | sudo pipelight-plugin --enable widevine
	#echo "y" | sudo pipelight-plugin --enable viewright-caiway
	#echo "y" | sudo pipelight-plugin --enable vizzedrgr
	#echo "y" | sudo pipelight-plugin --enable unity3d

#### ÚLTIMOS COMANDOS ####
	clear
	echo "update-alternatives --config default.plymouth"
	echo "~/.dropbox-dist/dropboxd"
	echo "É isso aí! Todas as tarefas foram realizadas com sucesso!!!"
