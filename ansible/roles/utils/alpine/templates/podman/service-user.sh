#!/bin/ash


addgroup -g 7962 syncthing


adduser -u 7962 -G syncthing -S -D syncthing


PASS="$(head -c1000 /dev/urandom | sha512sum | head -c128)"
echo "syncthing:${PASS}" | chpasswd


passwd -u -d syncthing