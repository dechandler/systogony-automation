#!/bin/sh

addgroup jump || true


# for ALGORITHM in rsa dsa ecdsa ed25519; do
#     ssh-keygen -b 4096 \
#         -f "/etc/ssh/ssh_host_${ALGORITHM}_key" \
#         -t "${ALGORITHM}" -N ""
#     chmod 600 "/etc/ssh/ssh_host_${ALGORITHM}_key"
# done

ssh-keygen -t rsa -b 4096 -f /etc/ssh/ssh_host_rsa_key -N "" >/dev/null 2>/dev/null
chmod 600 "/etc/ssh/ssh_host_rsa_key"


find /etc/ssh/authorized_keys -type f \
| awk -F'/' '{print $NF}' \
| while read JUMP_USER; do

    adduser -D -H -h /dev/null -s /bin/true -G jump "${JUMP_USER}" || true
    PASS="$(head -c1000 /dev/urandom | sha512sum | head -c128)"
    echo "${JUMP_USER}:${PASS}" | chpasswd || true
    passwd -u -d "${JUMP_USER}" || true

done


exec /usr/sbin/sshd
