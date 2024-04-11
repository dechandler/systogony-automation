#!/bin/ash

mkdir -p /var/prometheus/data

chown 65534:65534 /var/prometheus/data

cp -f prometheus.yml /var/prometheus/prometheus.yml

cp -f prometheus.rc /etc/init.d/prometheus
rc-update add prometheus
service prometheus start
