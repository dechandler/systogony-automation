#!/bin/bash

CONTAINER=$(buildah from alpine:3);

PKG="openssh-server"
NEW_VERSION="$(
    buildah run $CONTAINER apk info --no-cache -dq $PKG \
    | awk '$2~/^desc.*/{print substr($1, '$(wc -m <<< $PKG)' + 1)}'
)"

buildah images | grep -e '^localhost/'${PKG}' *'${NEW_VERSION} && {
    echo "${PKG} image already ${NEW_VERSION}, exiting"
    buildah rm $CONTAINER
    exit
}

buildah run $CONTAINER apk add --no-cache openssh-server

buildah config --volume /etc/ssh/sshd_config $CONTAINER
buildah config --entrypoint '/usr/sbin/sshd' $CONTAINER
buildah config --cmd '-D' $CONTAINER
buildah config --port 22 $CONTAINER

buildah commit ${CONTAINER} sshd:${NEW_VERSION};
buildah rm $CONTAINER

buildah tag sshd:${NEW_VERSION} sshd:latest;
