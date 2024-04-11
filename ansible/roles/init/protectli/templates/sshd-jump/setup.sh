#!/bin/ash

mkdir -p /var/sshd-jump/authorized_keys \
         /var/sshd-jump/build


cp update-image.sh /etc/periodic/weekly/update-sshd-jump-image.sh
cp Containerfile /var/sshd-jump/build/Containerfile
cp container-entrypoint.sh /var/sshd-jump/build/container-entrypoint.sh

cp authorized_keys/* /var/sshd-jump/authorized_keys/
cp sshd_config /var/sshd-jump/sshd_config

cp -f sshd-jump.rc /etc/init.d/sshd-jump


exec /etc/periodic/weekly/update-sshd-jump-image.sh
rc-update add sshd-jump
service sshd-jump start
