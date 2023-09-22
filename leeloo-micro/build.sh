#! /bin/sh

set -e
set -x

SHIELD="leeloo_micro"

if ! test -e .west; then
    west init -l /app/config
    west update
    west zephyr-export
fi

build() {
    side="$1"
    west build -s zmk/app -d build/${side} -b nice_nano_v2 -- -DZMK_CONFIG=/app/config -DSHIELD=${SHIELD}_${side}
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
