#!/bin/ash

mkdir -p /var/grafana/data
chown 472:472 /var/grafana/data

podman run -d \
    --name grafana \
    --network host \
    --restart unless-stopped \
    -v /var/grafana/data:/var/lib/grafana \
    grafana/grafana:latest


podman exec grafana {#
    #}grafana-cli admin {#
    #}reset-admin-password {{ grafana_admin_pass }}
