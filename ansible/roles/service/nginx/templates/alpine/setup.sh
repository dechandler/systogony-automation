#!/bin/ash

mkdir -p /var/nginx/conf.d \
         /var/nginx/tls \
         /var/nginx/log

cp -f nginx.conf /var/nginx/nginx.conf
cp -f upstream.conf /var/nginx/conf.d/upstream.conf
cp -f tls.conf /var/nginx/conf.d/tls.conf

cp -rf conf.d /var/nginx/
cp -rf tls /var/nginx/

./service-setup.sh
