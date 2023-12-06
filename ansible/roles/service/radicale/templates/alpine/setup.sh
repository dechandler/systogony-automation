#!/bin/ash

mkdir -p /var/radicale/data
chown 2999 /var/radicale/data

cp -f config /var/radicale/config

cp -f users.htpasswd /var/radicale/users.htpasswd
chown 2999 /var/radicale/users.htpasswd
chmod 640 /var/radicale/users.htpasswd

./service-setup.sh
