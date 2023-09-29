#! /bin/sh

set -e
set -x

SHIELD="leeloo_micro"

rm -rf .west && west init -l /app/config
west update
west zephyr-export

build() {
    side="$1"
    west build -s zmk/app -d build/${side} -b nice_nano_v2 -- -DZMK_CONFIG=/app/config -DSHIELD="${SHIELD}_${side} nice_view_adapter nice_view"
    mv ./build/${side}/zephyr/zmk.uf2 ./output/${side}.uf2
}

case "$1" in
    left)
	build left
	;;
    right)
	build right
	;;
    *|both)
	build left
	build right
	;;
esac
