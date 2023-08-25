#!/bin/ash


function authorized_keys () {
    SRC=$1; DEST=$2; OWNERSHIP=$3; MODE=$4;
    cp -f ${SRC} ${DEST}
    chown ${OWNERSHIP} ${DEST}
    chmod ${MODE} ${DEST}
}


addgroup ssh

{% for u in login_users|default([login_user]) %}

adduser -u {{ u.uid }} -D {{ u.name }}
adduser {{ u.name }} ssh

PASS="$(head -c1000 /dev/urandom | sha512sum | head -c128)"
echo "{{ u.name }}:${PASS}" | chpasswd
passwd -u -d {{ u.name }}

{% if login_user|default({}) %}
authorized_keys \
    authorized_keys \
    /etc/ssh/authorized_keys \
    root:{{ u.name }} \
    640
{% else %}
authorized_keys \
    {{ u.name }}.authorized_keys
    /home/{{ u.name }}/.ssh/authorized_keys \
    {{ u.name }}:{{ u.name }} \
    600
{% endif %}


{% endfor %}
