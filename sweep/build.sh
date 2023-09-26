#! /bin/sh

set -e
set -x

side=""

case "$1" in
    left)
        side="left"
        ;;
    right)
        side="right"
        ;;
    "")
        echo "error: no side provided"
        exit 1
        ;;
    *)
        echo "error: bad side: $1"
        exit 1
        ;;
esac

rm -rf .west && west init -l /app/config
west update
west zephyr-export

west build -s zmk/app -d build/${side} -b "nice_nano_v2" -- -DZMK_CONFIG=/app/config -DSHIELD="cradio_${side}"
mv ./build/${side}/zephyr/zmk.uf2 ./output/${side}.uf2
