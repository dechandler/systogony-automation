#!/bin/ash


# IPTABLES: Install and Create Rules
apk add iptables
service iptables stop
cp -f iptables /etc/iptables/rules-save
chmod 600 /etc/iptables/rules-save
rc-update add iptables
service iptables start


# iptables Manager for Rules Defined by DNS Names
cp -f dns-rules.conf /etc/iptables/dns-rules.conf
chmod 600 /etc/iptables/dns-rules.conf
cp -f dns-rules.sh /etc/periodic/15min/
chmod 700 /etc/periodic/15min/dns-rules.sh
