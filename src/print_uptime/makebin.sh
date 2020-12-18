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
         gcc -D_LINUX ${OPT_ARG} print_uptime.c -o print_uptime -lm
         ;;

     "Darwin" )
        echo "Making binary for macOS."
         cc  -D_MACOS ${OPT_ARG} print_uptime.c -o print_uptime -lm
         ;;
esac

[ $? -eq 0 ] && ./print_uptime

