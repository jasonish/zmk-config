#! /bin/bash

set -e

# To find these IDs, enable the virtual disk on one half and look in
# /dev/disk/by-id.
L=/dev/disk/by-id/usb-Adafruit_nRF_UF2_D485DDB15D99F80F-0:0
R=/dev/disk/by-id/usb-Adafruit_nRF_UF2_63B8A179D858F871-0:0

left_done=no
right_done=no

make

while true; do
    if test -e "${R}"; then
	echo "Found right"
	udisksctl mount -b "${R}"
        sleep 1
	cp output/right.uf2 /run/media/${USER}/NICENANO
        echo "Copy done"
	right_done=yes
    elif test -e "${L}"; then
	echo "Found left, mounting"
	udisksctl mount -b "${L}"
        sleep 1
	echo "Copying firmware"
	cp output/left.uf2 /run/media/${USER}/NICENANO
        echo "Copy done"
	left_done=yes
    elif [ "${left_done}" = "yes" -a "${right_done}" = "yes" ]; then
	break
    else
	echo "Waiting for device, hit CTRL-C if done."
	sleep 1
    fi
done

while true; do
    if [ "${right_done}" = "no" -a -e "/dev/disk/by-label/${RGHT}" ]; then
	echo "Found right, mounting"
	udisksctl mount -b "/dev/disk/by-label/${RGHT}"
	cp output/right.uf2 /run/media/${USER}/${RGHT}
	right_done=yes
    elif [ "${left_done}" = "no" -a -e "/dev/disk/by-label/${L}" ]; then
	echo "Found left, mounting"
	udisksctl mount -b "/dev/disk/by-label/${L}"
	echo "Copying firmware"
	cp output/left.uf2 /run/media/${USER}/${L}
	left_done=yes
    elif [ "${left_done}" = "yes" -a "${right_done}" = "yes" ]; then
	break
    else
	echo "Waiting for device, hit CTRL-C if done."
	sleep 1
    fi
done
