#!/bin/bash

bd=`cat env/bd`

xorg_conf=`cat env/xorg_conf`

cp "$xorg_conf" "$bd"/etc/X11/xorg.conf
chmod 644 "$bd"/etc/X11/xorg.conf
