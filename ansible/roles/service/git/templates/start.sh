#!/bin/bash

# Check for image update from upstream (localhost for now)

IMAGE="localhost/sshd:latest"


# Build local image, adding and incorporating ssh users

CONTAINER=$(buildah from $IMAGE);

RUN_ARGS="\
    -p 22:1227 \
    -v /var/lib/git-server/sshd_config:/etc/ssh/sshd_config:Z,ro \
    -v /var/lib/git-server/authorized_keys:/etc/ssh/authorized_keys:Z,ro \
    -v /var/lib/git-server/home:/home:Z,rw \
"

buildah run $RUN_ARGS $CONTAINER addgroup -g 774 ssh

jq '.git_server_users.[]' <<< "${CONFIG}" | while read USER_CONFIG; do
    USERNAME=$(jq '.name' <<< $USER_CONFIG)
    UID=$(jq '.uid' <<< $USER_CONFIG)

    buildah run $RUN_ARGS $CONTAINER \
        adduser -HD -s /sbin/nologin -G ssh -u ${UID} ${USERNAME}

done

buildah commit ${CONTAINER} git-server:latest;
buildah rm $CONTAINER


podman run -d $RUN_ARGS git-server:latest
