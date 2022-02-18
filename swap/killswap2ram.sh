#!/bin/sh

# This Kills the swapoff command, swapoff can get heavy on performance so you dont want it in production times
# this script is used if the swap2ram.sh script runs too long

# H.Eudenbach in 2021 - holger@eude.rocks - no warranties given!

kill $(ps aux | grep 'swapoff -a' | awk '{print $2}') > /dev/null
