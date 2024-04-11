#!/bin/ash

mkdir -p /var/mosquitto/data \
         /var/mosquitto/log

cp -f mosquitto.conf /var/mosquitto/mosquitto.conf

cp -f mosquitto.rc /etc/init.d/mosquitto
rc-update add mosquitto
service mosquitto start
