#!/bin/ash

REPOS="$(grep -Ev '#|^$' /etc/apk/repositories)"

echo "${REPOS}" | grep -E '/community$' || {
    echo "${REPOS}" > /etc/apk/repositories
    echo "${REPOS}" | sed 's/main$/community/' >> /etc/apk/repositories
}
