#!/bin/ash

podman pull alpine:latest

cd /var/sshd-jump/build

service sshd-jump status | grep started && {
    STARTED="1"
    service sshd-jump stop
}

podman rmi localhost/sshd-jump:latest || true
podman build -t sshd-jump:latest .

if [ $STARTED == "1" ]; then
    service sshd-jump start
fi
