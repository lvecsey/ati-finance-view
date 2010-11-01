#!/bin/bash

variant=minbase
#variant=buildd

bd=`cat ./env/bd`

mkdir -p "$bd"

# karmic
# lucid
release=maverick
# natty

if [ "$1" != "" ]; then

  apt_proxy="$1"

else 

# apt_proxy='http://apt-proxy.internal:9998/ubuntu'
  apt_proxy='http://archive.ubuntu.com/ubuntu/'

fi

go_deboot () {

debootstrap --variant=minbase --arch amd64 "$release" "$bd" "$apt_proxy"
retval="$?"
if [ "$retval" != 0 ]; then
    echo debootstrap problem
    exit 1
fi

}

go_deboot

cp /etc/resolv.conf "$bd"/etc/resolv.conf

setup_apt_sources() {

ad="$1"

cat > "$ad"/sources.list << _END_
deb http://us.archive.ubuntu.com/ubuntu/ $release main
deb-src http://us.archive.ubuntu.com/ubuntu/ $release main
deb http://us.archive.ubuntu.com/ubuntu/ $release-updates main
deb-src http://us.archive.ubuntu.com/ubuntu/ $release-updates main
deb http://us.archive.ubuntu.com/ubuntu/ $release universe
deb-src http://us.archive.ubuntu.com/ubuntu/ $release universe
deb http://us.archive.ubuntu.com/ubuntu/ $release-updates universe
deb-src http://us.archive.ubuntu.com/ubuntu/ $release-updates universe
_END_

}

setup_apt_sources "$bd"/etc/apt

check_packages () {

chroot "$bd" apt-get -y --force-yes update

chroot "$bd" apt-get -y --force-yes install xserver-xorg-video-ati

chroot "$bd" apt-get -y --force-yes install module-init-tools ethtool
chroot "$bd" apt-get -y --force-yes install autoconf automake libtool
chroot "$bd" apt-get -y --force-yes install gcc wget
chroot "$bd" apt-get -y --force-yes install svtools ipsvd runit net-tools
chroot "$bd" apt-get -y --force-yes install openssl libssl-dev
chroot "$bd" apt-get -y --force-yes install xsltproc libexpat1-dev libfreetype6-dev
chroot "$bd" apt-get -y --force-yes install fontconfig
chroot "$bd" apt-get update
chroot "$bd" apt-get -y --force-yes install openssh-server
chroot "$bd" apt-get -y --force-yes install net-tools
chroot "$bd" apt-get -y --force-yes install dhcp3-common dhcp3-client
chroot "$bd" apt-get -y --force-yes install dhcdbd
chroot "$bd" /usr/bin/dpkg --purge ppp pppoe pppconfig pppoeconf
chroot "$bd" apt-get upgrade -y
chroot "$bd" apt-get clean

chroot "$bd" apt-get -y --force-yes install pciutils # for lspci
chroot "$bd" apt-get -y --force-yes install x11-xserver-utils # for xrandr
chroot "$bd" apt-get -y --force-yes install x11-utils # for xdpyinfo
chroot "$bd" apt-get -y --force-yes install openssl # for trading software
chroot "$bd" apt-get -y --force-yes install libXtst # for synergy+
chroot "$bd" apt-get -y --force-yes install xserver-xorg-video-radeon
chroot "$bd" apt-get -y --force-yes install xserver-xorg-video-ati
# ati captures as a meta package of sorts and radeonhd will be deprecated soon I think.
chroot "$bd" apt-get -y --force-yes install synergy
# chroot "$bd" apt-get -y --force-yes install stumpwm 
chroot "$bd" apt-get -y --force-yes install sawfish # in case we need a light wm
chroot "$bd" apt-get -y --force=yes install language-pack-en # for locale error, gnome-terminal
chroot "$bd" apt-get -y --force=yes install language-support-en # needed?
chroot "$bd" apt-get -y --force-yes install ethtool wget tftp
chroot "$bd" apt-get -y --force-yes install x11-apps # for xeyes, for testing.
chroot "$bd" apt-get -y --force-yes install lzma fastjar
chroot "$bd" apt-get -y --force-yes install sawfish
chroot "$bd" apt-get -y --force-yes install ipsvd
chroot "$bd" apt-get -y --force-yes install linux-firmware

chroot "$bd" apt-get -y --force-yes upgrade

}

check_packages

image_work () {

#
# secondary debootstrap, not needed if your target system is identical to the one you are starting with.
#

echo Setting up another directory structure, just so you can extract a recent boot image, /boot/vmlinuz-

debootstrap --variant=minbase --arch amd64 "$release" "$release"-image-module "$apt_proxy"
retval="$?"
if [ "$retval" != 0 ]; then
    echo debootstrap problem
    exit 1
fi
cp /etc/resolv.conf "$bd"-image-module/etc/resolv.conf
setup_apt_sources "$bd"-image-module/etc/apt
chroot "$release"-image-module apt-get -y --force-yes install linux-image-server

}

image_work

exit 0
