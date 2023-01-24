#!/bin/ash

mkdir -p /var/mosquitto/data \
         /var/mosquitto/log

cp -f mosquitto.conf /var/mosquitto/mosquitto.conf


./service-setup.sh
