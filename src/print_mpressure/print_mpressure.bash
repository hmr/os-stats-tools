#!/usr/bin/env -S nice -n 17 /bin/bash
# vim: ft=sh ts=2 sw=2 et ff=unix fenc=utf-8

# part of os-stats-tools
# print_mpressure
#   Print memory pressure.
#
# ORIGIN: 2020-12-04 by hmr


set -eu

trap 'exit 255' HUP QUIT TERM
trap 'echo SIGINT caught; exit 254' 2
trap 'echo SIGUSR1 caught; exit 253' USR1

_SYSTEM=$(uname -s | tr "[:upper:]" "[:lower:]")

case "${_SYSTEM}" in

  "darwin" )
    WIRED=5     # Pages wired down
    CMPRSSOR=15 # Pages occupied by compressor
    #vm_stat -c 1 1 | pbcopy;
    #pbpaste;
    #VMSTATS=($(pbpaste | tail -n 1))
    VMSTATS=($(vm_stat -c 1 1 | tail -n 1))

    #echo wired: ${VMSTATS[$WIRED]}
    #echo cmprssor: ${VMSTATS[$CMPRSSOR]}
    #echo -n "wired+cmprssor(KiB): "
    #echo "( ${VMSTATS[$WIRED]} + ${VMSTATS[$CMPRSSOR]} ) * 4" | bc
    #echo "scale=4; ( ${VMSTATS[$WIRED]} + ${VMSTATS[$CMPRSSOR]} ) * 4 / ($(sysctl hw.memsize | cut -d' ' -f2) / 1024) * 100" | bc
    #MEM_PRESS=$(echo "scale=4; (${VMSTATS[$WIRED]} + ${VMSTATS[$CMPRSSOR]}) / ($(sysctl hw.memsize | cut -d' ' -f2) / 4096) * 100" | bc)
    MEM_PRESS=$(echo "scale=7; (${VMSTATS[$WIRED]} + ${VMSTATS[$CMPRSSOR]}) / ($(sysctl hw.memsize | cut -d' ' -f2) ) * 409600" | bc)
    printf '%.1f\n' "$MEM_PRESS"
    ;;

  "linux" )

    read ALLMEM AVAMEM  <<< $(cat /proc/meminfo | grep -P "MemTotal|MemAvailable" | awk '{printf("%s ", $2);}')
    printf '%.1f\n' "$(echo "scale=7;100-($AVAMEM/$ALLMEM)*100" | bc)"
    ;;

  esac

