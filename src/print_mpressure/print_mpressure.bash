#!/usr/bin/env -S nice -n 19 bash
# vim: syn=bash ft=sh ts=2 sw=2 et fenc=utf-8 ff=unix
# shellcheck shell=bash disable=SC1091,SC3006,SC3010,SC3021,SC3043,SC3037 source=${GPP_HOME}

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
    COL_PGSIZE=0   # Col# Page size
    COL_WIRED=7    # Col# Pages wired down
    COL_CMPRSR=17  # Col# Pages occupied by compressor
    #vm_stat -c 1 1 | pbcopy;
    #pbpaste;
    #VMSTATS=($(pbpaste | tail -n 1))
    MEMSIZE="$(echo "$(/usr/sbin/sysctl hw.memsize | cut -d' ' -f2) / 1024" | bc)" # Memory size in KiB
    VMSTATS=($(vm_stat -c 1 1 | grep -Po "\d+" | tr "\n" " "))
    # echo page size: "${VMSTATS[$COL_PGSIZE]}" Bytes
    # echo wired: "${VMSTATS[$COL_WIRED]}" Pages
    # echo cmprssor: "${VMSTATS[$COL_CMPRSR]}" Pages
    # echo "wired + cmprssor: $(echo "( ${VMSTATS[$COL_WIRED]} + ${VMSTATS[$COL_CMPRSR]} ) * ( ${VMSTATS[$COL_PGSIZE]} / 1024 )" | bc) KiB"
    # echo "memsize: ${MEMSIZE} KiB"
    # echo "scale=4; ( ${VMSTATS[$COL_WIRED]} + ${VMSTATS[$COL_CMPRSR]} ) * ( ${VMSTATS[$COL_PGSIZE]} / 1024 ) / ( ${MEMSIZE} ) * 100" | bc
    #MEM_PRESS=$(echo "scale=4; (${VMSTATS[$COL_WIRED]} + ${VMSTATS[$COL_CMPRSR]}) / ($(sysctl hw.memsize | cut -d' ' -f2) / 4096) * 100" | bc)
    # MEM_PRESS=$(echo "scale=7; ( ${VMSTATS[$COL_WIRED]} + ${VMSTATS[$COL_CMPRSR]} ) / ( $(/usr/sbin/sysctl hw.memsize | cut -d' ' -f2) ) * 409600" | bc)
    MEM_PRESS=$(echo "scale=7; ( ( ${VMSTATS[$COL_WIRED]} + ${VMSTATS[$COL_CMPRSR]} ) * ( ${VMSTATS[$COL_PGSIZE]} / 1024 ) ) / ${MEMSIZE} * 100" | bc)
    printf '%.1f\n' "$MEM_PRESS"
    ;;

  "linux" )
    read ALLMEM AVAMEM  <<< $(cat /proc/meminfo | grep -P "MemTotal|MemAvailable" | awk '{printf("%s ", $2);}')
    printf '%.1f\n' "$(echo "scale=7;100-($AVAMEM/$ALLMEM)*100" | bc)"
    ;;

  * )
    echo "Unsupported Platform"
esac

