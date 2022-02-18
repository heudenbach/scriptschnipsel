#!/bin/sh

# this script frees swap
# usage: make executable (chmod +x) execute and wait, or use it with crontab
# crontab usage (needs killswap2ram.sh script):
# 30 5 * * * root /path/to/script/swap2ram.sh
# 0 8 * * * root /path/to/script/killswap2ram.sh
# this 2 lines will start the swap 2 ram at 5:30 AM, and kill it at 8:00 AM if it is not done 

# H.Eudenbach in 2021 - holger@eude.rocks - no warranties given!

mem=$(LC_ALL=C free  | awk '/Mem:/ {print $4}')
swap=$(LC_ALL=C free | awk '/Swap:/ {print $3}')

if [ $mem -lt $swap ]; then
    echo "ERROR: nicht genug RAM zur verfügung, Script NICHT ausgeführt!" >&2      #comment this out and following line in to change to english
#    echo "ERROR: not enough RAM, script not executed!" >&2
    exit 1
fi

swapoff -a &&
swapon -a