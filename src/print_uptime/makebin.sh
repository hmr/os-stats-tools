#!/bin/sh

if [ "$1" = "debug" ]; then
    echo "Debug build."
    OPT_ARG="-DDEBUG -O0 -g"
else
    OPT_ARG="-O3"
fi

case "$(uname -s)" in
    "Linux" )
        echo "Making binary for Linux."
        gcc -D_LINUX "${OPT_ARG}" print_uptime.c -o print_uptime -lm
        ;;

    "Darwin" )
        echo "Making binary for macOS."
        # Make universal binary
        # cc  -arch arm64 -D_MACOS "${OPT_ARG}" -o print_uptime.arm64 -lm print_uptime.c
        # cc  -arch x86_64 -D_MACOS "${OPT_ARG}" -o print_uptime.x86_64 -lm print_uptime.c
        # lipo -create -output print_uptime print_uptime.arm64 print_uptime.x86_64
        cc  -arch arm64 -arch x86_64 -D_MACOS "${OPT_ARG}" -o print_uptime -lm print_uptime.c
        ;;
esac

[ $? -eq 0 ] && ./print_uptime

