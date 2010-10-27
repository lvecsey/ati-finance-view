#!/bin/sh

bd=`cat env/bd`

#output_img=/tftpboot/initrds/finance-server.initrd.img
output_img=/mnt/cache/$USER/finance-server.initrd.img

(cd "$bd" ; find . | cpio --quiet -H newc -o | gzip -9 -n > "$output_img")

#chown tftpboot.tftpboot "$output_img"


