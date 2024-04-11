#!/bin/ash


# SSHD setup
cp -f sshd_config /etc/ssh/sshd_config
echo 'rc_need="net"' >> /etc/conf.d/sshd
service sshd restart


# SSH Admin User
addgroup ssh
adduser -u {{ login_user.uid }} -G ssh -D {{ login_user.name }}
adduser {{ login_user.name }} ssh
PASS="$(head -c1000 /dev/urandom | sha512sum | head -c128)"
echo "{{ login_user.name }}:${PASS}" | chpasswd
passwd -u -d {{ login_user.name }}

cp -f authorized_keys /etc/ssh/authorized_keys
chown root:{{ login_user.name }} /etc/ssh/authorized_keys
chmod 640 /etc/ssh/authorized_keys
