#!/bin/bash

variant=minbase
#variant=buildd

bd=`cat ./env/bd`

mkdir -p "$bd"

# karmic
# heron

debootstrap --variant=minbase --arch amd64 lucid "$bd" http://archive.ubuntu.com/ubuntu/
retval="$?"
if [ "$retval" != 0 ]; then
    echo debootstrap problem
    exit 1
fi
cp /etc/resolv.conf "$bd"/etc/resolv.conf
cp /etc/apt/sources.list "$bd"/etc/apt/
#editor "$bd"/etc/apt/sources.list
chroot "$bd" apt-get -y --force-yes install module-init-tools ethtool
chroot "$bd" apt-get -y --force-yes install autoconf automake libtool
chroot "$bd" apt-get -y --force-yes install libasound2-dev libsamplerate-dev gcc wget bzip2 python2.6
chroot "$bd" apt-get -y --force-yes install svtools ipsvd runit net-tools
chroot "$bd" apt-get -y --force-yes install libcairo-dev
chroot "$bd" apt-get -y --force-yes install openssl libssl-dev
chroot "$bd" apt-get -y --force-yes install grub
chroot "$bd" apt-get -y --force-yes install nginx
chroot "$bd" apt-get -y --force-yes install xsltproc libexpat1-dev libfreetype6-dev
chroot "$bd" apt-get -y --force-yes install fontconfig
chroot "$bd" apt-get update
chroot "$bd" apt-get -y --force-yes install openssh-server
chroot "$bd" apt-get -y --force-yes install alsa net-tools
chroot "$bd" apt-get -y --force-yes install dhcp3-common dhcp3-client
chroot "$bd" apt-get -y --force-yes install dhcdbd
chroot "$bd" /usr/bin/dpkg --purge ppp pppoe pppconfig pppoeconf
chroot "$bd" apt-get upgrade -y
chroot "$bd" apt-get clean

chroot "$bd" apt-get -y --force-yes install pciutils # for lspci
chroot "$bd" apt-get -y --force-yes install x11-xserver-utils # for xrandr
chroot "$bd" apt-get -y --force-yes install openssl # for trading software
chroot "$bd" apt-get -y --force-yes install libXtst # for synergy+
chroot "$bd" apt-get -y --force-yes install stumpwm xserver-xorg-video-radeon
chroot "$bd" apt-get -y --force-yes install sawfish # in case we need a light wm
chroot "$bd" apt-get -y --force-yes install synergy
chroot "$bd" apt-get -y --force=yes install language-pack-en # for locale error, gnome-terminal
chroot "$bd" apt-get -y --force=yes install language-support-en # needed?
chroot "$bd" apt-get -y --force-yes install ethtool wget tftp
chroot "$bd" apt-get -y --force-yes install bzip2 fastjar
chroot "$bd" apt-get -y --force-yes install sawfish
chroot "$bd" apt-get -y --force-yes install ipsvd
chroot "$bd" apt-get -y --force-yes install linux-firmware
