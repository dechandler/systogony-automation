#!/bin/sh

CONF_FILE=/etc/iptables/dns-rules.conf
# INPUT uranus.dechandler.net:832
# FWD uranus.dechandler.net:8443::192.168.0.11:443

VOLATILE_DIR=/dev/shm


# Prints IP of Hostname
function local_lookup () {
    local HOSTNAME=$1

    cat "${VOLATILE_DIR}/${HOSTNAME}.ip" 2>/dev/null || true
}

# Prints A-Record Value for DNS Name
function dns_lookup () {
    local HOSTNAME=$1

    nslookup ${HOSTNAME} \
    | grep -A1 "Name:.*${HOSTNAME}" \
    | awk '/Address/ {print $2}'
}

# Returns Non-Zero if Arg is not a valid IP
function is_ip () {
    ipcalc -h $1 &>/dev/null
}


# Lookup DNS and Compare to Last Known
# Tracks Changed, Stable, and Missing (no DNS record) names
# Manages file used in local_lookup
#
# Out: IP Address corresponding to the host (empty if DNS query failed)
# Return Codes
#   0 : Address is changing this run
#   1 : Address is known and unchanged
#   2 : DNS query failed
CHANGED_HOSTS=""
STABLE_HOSTS=""
MISSING_HOSTS=""
function get_ip () {
    local HOST=$1

    # If this host has already been handled in other
    #     rules, return accordingly
    echo -e "$CHANGED_HOSTS" | grep -q ${HOST} && {
        local_lookup ${HOST}
        return 0
    }
    echo -e "$STABLE_HOSTS" | grep -q ${HOST} && {
        local_lookup ${HOST}
        return 1
    }
    echo -e "$MISSING_HOSTS" | grep -q ${HOST} && {
        return 2
    }

    # Lookup DNS and Last Known IPs for HOST
    local IP=`dns_lookup ${HOST}`
    local PREV_IP=`local_lookup ${HOST}`


    # IP has not changed
    if [[ "$IP" == "$PREV_IP" ]]; then
        STABLE_HOSTS="${STABLE_HOSTS}\n${HOST}"
        echo $IP
        return 1
    # No such DNS Record Found
    elif [[ "$IP" == "" ]]; then
        MISSING_HOSTS="${MISSING_HOSTS}\n${HOST}"
        return 2
    # IP has changed
    else
        # Store IP in file referenced by local_lookup
        echo $IP | tee "${VOLATILE_DIR}/${HOST}.ip"
        chmod 600 "${VOLATILE_DIR}/${HOST}.ip"
        
        CHANGED_HOSTS="${CHANGED_HOSTS}\n${HOST}"
        return 0
    fi
}


# Remove existing port forward and replace with updated IP
function forward_update () {
    local SRC=$1
    local PORT=$2
    local FWD_HOST=$3
    local FWD_PORT=$4

    # Delete Old PREROUTING Rule
    iptables -nvL PREROUTING -t nat --line-numbers 2>/dev/null \
    | awk '$12~/^dpt:'${PORT}'$/ {print $1}' \
    | sort -rn \
    | xargs -I {} iptables -t nat -D PREROUTING {}

    # Delete Old FORWARD Rule
    iptables -nvL FORWARD --line-numbers 2>/dev/null \
    | awk '$12~/^dpt:'${PORT}'$/
        && $9!~/^0\.0\.0\.0\/0$/
        {print $1}' \
    | sort -rn \
    | xargs -I {} iptables -D FORWARD {}

    iptables -I PREROUTING -t nat -i eth0 \
        -p tcp -s ${SRC} --dport ${PORT} \
        -j DNAT --to ${FWD_HOST}:${FWD_PORT}
    
    iptables -I FORWARD \
        -p tcp -s ${SRC} -d ${FWD_HOST} \
        --dport ${FWD_PORT} \
        -j ACCEPT
}

# Remove existing rules for direct access to router
#     and replace with updated IP
function input_update () {
    local SRC=$1
    local PORT=$2

    # Remove Old Rule
    iptables -nvL INPUT --line-numbers 2>/dev/null \
    | awk '$12~/^dpt:'${PORT}'$/ {print $1}' \
    | sort -rn \
    | xargs iptables -D INPUT

    # Set New Rule
    iptables -I INPUT -i eth0 \
    -s ${SRC} -p tcp --dport ${PORT} \
    -j ACCEPT
}


# Rule for direct access to router
#
# INPUT uranus.derp.net:123
function input_rule () {
    local RULE=$1
    local SRC="`echo $RULE | awk -F':' '{print $1}'`"
    local PORT="`echo $RULE | awk -F':' '{print $2}'`"

    local UPDATE=0

    is_ip $SRC || {
        SRC=`get_ip $SRC` && UPDATE=1
    }

    if [[ $UPDATE == 1 ]]; then
        input_update $SRC $PORT
    fi
}

# Port forwarding rule
#   
# FWD uranus.derp.net:8443::192.168.0.111:443
function forward_rule () {
    local RULE=$1
    local SRC="`echo $RULE | awk -F':' '{print $1}'`"
    local PORT="`echo $RULE | awk -F':' '{print $2}'`"
    local FWD_HOST="`echo $RULE | awk -F':' '{print $4}'`"
    local FWD_PORT="`echo $RULE | awk -F':' '{print $5}'`"

    local UPDATE=0

    is_ip $FWD_HOST || {
        FWD_HOST=`get_ip $FWD_HOST` && UPDATE=1
    }

    is_ip $SRC || {
        SRC=`get_ip $SRC` && UPDATE=1
    }

    if [[ $UPDATE == 1 ]]; then
        forward_update $SRC $PORT $FWD_HOST $FWD_PORT
    fi
}




while read LINE; do
    RULE_TYPE=`echo "$LINE" | awk '{print $1}'`
    RULE=`echo "$LINE" | awk '{print $2}'`

    case $RULE_TYPE in
        INPUT) input_rule   $RULE ;;
        FWD)   forward_rule $RULE ;;
    esac

done < $CONF_FILE
