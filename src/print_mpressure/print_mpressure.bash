#!/bin/bash

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

# vim: ft=bash ts=2 sw=2 et fenc=utf-8
