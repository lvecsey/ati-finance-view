#!/bin/bash

#network modules and base modules.dep

bd=`cat env/bd`

mb=`cat env/mb`

if [ ! -e "env/uname_r" ]; then
    echo kernel version not found, please configure in env/uname_r
    exit 1
fi

uname_r=`cat env/uname_r`

mkdir -p "$bd"/lib/modules/"$uname_r"
mkdir -p "$bd"/lib/modules/"$uname_r"/kernel/drivers

mkdir -p /lib/modules/"$uname_r"

precise_minimal () {

target_dir="$bd"/lib/modules/"$uname_r"/kernel/drivers/net
mkdir -p $target_dir
cp "$mb"/"$uname_r"/kernel/drivers/net/mii.ko "$target_dir"
cp "$mb"/"$uname_r"/kernel/drivers/net/r8169.ko "$target_dir"

cp "$mb"/"$uname_r"/kernel/drivers/net/sky2.ko "$target_dir"

}

full_insert () {

cp -a "$mb"/"$uname_r"/kernel/drivers/net "$bd"/lib/modules/"$uname_r"/kernel/drivers/net

cp -a "$mb"/"$uname_r"/kernel/drivers/gpu "$bd"/lib/modules/"$uname_r"/kernel/drivers/gpu

cp -a "$mb"/"$uname_r"/kernel/drivers/i2c "$bd"/lib/modules/"$uname_r"/kernel/drivers/i2c

}

full_insert




