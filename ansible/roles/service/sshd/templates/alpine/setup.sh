#!/bin/ash


# SSHD setup
addgroup ssh

cp -f sshd_config /etc/ssh/sshd_config
echo 'rc_need="net"' >> /etc/conf.d/sshd
service sshd restart
