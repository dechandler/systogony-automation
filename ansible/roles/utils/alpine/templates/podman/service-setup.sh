#!/bin/ash

cp -f service.rc /etc/init.d/{{ setup_name }}

rc-update add {{ setup_name }}

service {{ setup_name }} stop
service {{ setup_name }} start
