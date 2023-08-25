#!/bin/ash


# Automatically update and selectively reboot via cron
cp update.sh        /etc/periodic/daily/update
cp update-reboot.sh /etc/periodic/weekly/reboot

chmod 755 /etc/periodic/*/*


# Run updates and reboot
apk update
apk upgrade
reboot
