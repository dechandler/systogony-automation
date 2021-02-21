

PKG="openssh-server"
NEW_VERSION="$(
    buildah run $CONTAINER apk info --no-cache -dq $PKG \
    | awk '$2~/^desc.*/{print substr($1, '$(wc -m <<< $PKG)' + 1)}'
)"

buildah images | grep -e '^localhost/'${PKG}' *'${NEW_VERSION} && {
    echo "${PKG} image already ${NEW_VERSION}, exiting"
    exit
}

