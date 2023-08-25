#!/bin/ash

find /boot -name "initramfs-vanilla" -mtime -7 | grep i || reboot
