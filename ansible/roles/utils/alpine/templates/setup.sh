#!/bin/ash

{% set stage_order = [
    "updates", "network", "iptables", "dnsmasq",
    "login-users", "sshd",
    "apk-community", "netdata", "podman", "sshd-jump",
    "syncthing", "prometheus", "grafana",
    "home-assistant", "mosquitto", "radicale"
] | select("in", setup_stages) %}

SETUP_DIR="/home/{{ login_users.0.name }}/setup"


ARGS="${@}"
if [ "${ARGS}" == "" ]; then
    ARGS="{{ stage_order | join(',') }}"
fi

setup_role () {
    cd "${SETUP_DIR}/${1}" && /bin/ash setup.sh
}

for ROLE in {{ stage_order | join(' ') }}
do
    echo "$ARGS" | grep -q $ROLE && setup_role $ROLE
done
