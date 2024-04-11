#!/bin/bash
#
# Workspaces i3blocklet backend daemon
#
# args are output names
# subscribes to i3 window and workspace events and
# updates a file that py3status reads for output
#
cd /usr/local/libexec/py3status

./workspaces.py update "$@"

./i3-subscribe.pl window workspace | while read -r EVENT; do
    grep -qs 'focus$' <<< $EVENT || ./workspaces.py update "$@";
done