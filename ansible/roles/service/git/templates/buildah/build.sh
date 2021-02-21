#!/bin/bash

CONTAINER=$(buildah from registry.access.redhat.com/ubi9/ubi-micro);
MOUNT=$(buildah mount $CONTAINER);
[[ -z $MOUNT ]] && exit 1;

dnf install --installroot $MOUNT \
    --releasever 9 --nodocs -y \
    sshd;

dnf clean all --installroot $MOUNT;

rm -rf  $MOUNT/var/lib/rpm \
        $MOUNT/var/lib/dnf \
        $MOUNT/var/cache \
        $MOUNT/var/log/*;

buildah umount $CONTAINER;

buildah commit $CONTAINER git-sshd:{{ image_version }};
buildah tag git-sshd:{{ image_version }} git-sshd:latest;
