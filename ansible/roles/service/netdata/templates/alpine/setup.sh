#!/bin/ash

apk add netdata

#cp -f netdata.conf /etc/netdata/netdata.conf

rc-update add netdata
service netdata start
