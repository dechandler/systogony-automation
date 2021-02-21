#!/bin/bash

IMAGE_VERSION="${1}"

CONTAINER=$(buildah from registry.access.redhat.com/ubi9/ubi-micro);
MOUNT=$(buildah mount $CONTAINER);
[[ -z $MOUNT ]] && exit 1;

dnf install --installroot $MOUNT \
    --releasever 9 --nodocs -y \
    openssh-server;

dnf clean all --installroot $MOUNT;
rm -rf  $MOUNT/var/lib/rpm \
        $MOUNT/var/lib/dnf \
        $MOUNT/var/cache \
        $MOUNT/var/log/*;
buildah umount $CONTAINER;
buildah commit $CONTAINER git-sshd:$IMAGE_VERSION;
buildah tag git-sshd:$IMAGE_VERSION git-sshd:latest;
