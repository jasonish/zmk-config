#! /bin/bash

set -e

# To find these IDs, enable the virtual disk on one half and look in
# /dev/disk/by-id.
LEFT=/dev/disk/by-id/usb-Adafruit_nRF_UF2_F8D66D18C046E74C-0:0
RIGHT=/dev/disk/by-id/usb-Adafruit_nRF_UF2_182B851DD5F69A2E-0:0

case "$1" in
    left)
	side="left"
	;;
    right)
	side="right"
	;;
    *)
	side=
	;;
esac

left_done=no
right_done=no

make ${side}

while true; do
    if test -e "${RIGHT}"; then
	echo "Found right"
	udisksctl mount -b "${RIGHT}"
	cp output/right.uf2 /run/media/${USER}/NICENANO
	right_done=yes
    elif test -e "${LEFT}"; then
	echo "Found left, mounting"
	udisksctl mount -b "${LEFT}"
	echo "Copying firmware"
	cp output/left.uf2 /run/media/${USER}/NICENANO
	left_done=yes
    elif [ "${left_done}" = "yes" -a "${right_done}" = "yes" ]; then
	break
    else
	echo "Waiting for device, hit CTRL-C if done."
	sleep 1
    fi
done
