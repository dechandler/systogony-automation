#!/bin/bash

START_TEMP=4500
TEMP_FILE="${HOME}/shm/.redshift-temp"
echo "$START_TEMP" > $TEMP_FILE

function kill_redshift () {
    pgrep -x redshift-wl | xargs kill &>/dev/null
}

function on_exit () {
    kill_redshift
    kill $WAIT_PID
}

trap on_exit EXIT

while /bin/true; do
    kill_redshift
    redshift-wl -O $(cat $TEMP_FILE) &>/dev/null &
    inotifywait -e modify -qq $TEMP_FILE &
    WAIT_PID=$!;
    wait $WAIT_PID;
done
