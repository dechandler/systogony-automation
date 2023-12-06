#!/bin/ash


# Setup dnsmasq
apk add dnsmasq
cp -f dnsmasq.conf /etc/dnsmasq.conf
rc-update add dnsmasq
service dnsmasq restart
