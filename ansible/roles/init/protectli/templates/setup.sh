#!/bin/ash

SETUP_DIR="/home/{{ login_user.name }}/setup"

ARGS="${@}"
if [ "${ARGS}" == "" ]; then
    ARGS="router,sshd-login,apk-community,podman,sshd-jump,netdata,prometheus,pihole,updates"
fi

setup_role () {
    cd "${SETUP_DIR}/${1}"
    /bin/ash setup.sh
}

for ROLE in \
    router \
    sshd-login \
    netdata \
    apk-community \
    podman \
    sshd-jump \
    prometheus \
    grafana \
    updates
do
    echo "$ARGS" | grep -q $ROLE && setup_role $ROLE
done
