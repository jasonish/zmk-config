#! /bin/bash

set -e

# To find these IDs, enable the virtual disk on one half and look in
# /dev/disk/by-id.
LEFT=GLV80LHBOOT
RGHT=GLV80RHBOOT

left_done=no
right_done=no

case "$1" in
    left)
        right_done=yes
        ;;
    right)
        left_done=yes
        ;;
    "")
        ;;
    *)
        echo "error: invalid argument: $1"
        exit 1
        ;;
esac

if [ "${left_done}" != "yes" ]; then
    make left
fi

if [ "${right_done}" != "yes" ]; then
    make right
fi

while true; do
    if [ "${right_done}" = "no" -a -e "/dev/disk/by-label/${RGHT}" ]; then
	echo "Found right, mounting"
	udisksctl mount -b "/dev/disk/by-label/${RGHT}"
	cp output/right.uf2 /run/media/${USER}/${RGHT}
	right_done=yes
    elif [ "${left_done}" = "no" -a -e "/dev/disk/by-label/${LEFT}" ]; then
	echo "Found left, mounting"
	udisksctl mount -b "/dev/disk/by-label/${LEFT}"
	echo "Copying firmware"
	cp output/left.uf2 /run/media/${USER}/${LEFT}
	left_done=yes
    elif [ "${left_done}" = "yes" -a "${right_done}" = "yes" ]; then
	break
    else
	echo "Waiting for device, hit CTRL-C if done."
	sleep 1
    fi
done
