
alias curlt="curl -ksLw 'time_namelookup    : %{time_namelookup}
time_connect       : %{time_connect}
time_appconnect    : %{time_appconnect}
time_pretransfer   : %{time_pretransfer}
time_redirect      : %{time_redirect}
time_starttransfer : %{time_starttransfer}
---------------------------------
time_total         : %{time_total}

http_code          : %{http_code}
' -o /dev/null"

alias vim="nvim"

function pwgen () {
    # Exclude characters that divide words in the terminal
    #     so it highlights correctly with double-click
    A='`~!@$^*()+=[]{}\|<>;"'
    B="${A}'"
    /usr/bin/pwgen -yr "$B" ${@}
}

function keys () {
    ADDED="$(ssh-add -l | cut -d' ' -f3)"
    export SSH_ASKPASS="${HOME}/shm/.ssh-askpass"
    find "${HOME}/.ssh/private" -type f | while read KEYPATH; do
        echo -n "#!/bin/bash\npass show ssh/$(basename $KEYPATH)" > $SSH_ASKPASS
        chmod 700 $SSH_ASKPASS
        grep -q $KEYPATH <<< "$ADDED" || ssh-add $KEYPATH
    done
    rm -f $SSH_ASKPASS
}

# function curlt () {
# curl -ksLw 'time_namelookup    : %{time_namelookup}
# time_connect       : %{time_connect}
# time_appconnect    : %{time_appconnect}
# time_pretransfer   : %{time_pretransfer}
# time_redirect      : %{time_redirect}
# time_starttransfer : %{time_starttransfer}
# ---------------------------------
# time_total         : %{time_total}

# http_code          : %{http_code}
# ' -o /dev/null
# }

function http() {
    curl http://httpcode.info/$1
}

function du_hum() {
    awk '
        function hum(y, h, k) {
            for(x=k^3;x>=k;x/=k) {
                if (y >= x) { return sprintf("%.2f %s",y/x,h[x]) }
            }
        }
        BEGIN {
            k=1024;
            h[k^3]="TB";
            h[k^2]="GB";
            h[k]="MB";
            h[1]="KB"
        }
        { printf "%11s   %s\n", hum($1,h,k), substr($0,index($0,$2)) }
    '
}

function newrole() {
    ROLE="$1"
    mkdir -p ${PWD}/roles/${ROLE}/{defaults,tasks}

    echo '---' > ${PWD}/roles/${ROLE}/defaults/main.yml
    echo -e '---\n- include_tasks: install.yml' > ${PWD}/roles/${ROLE}/tasks/main.yml
    echo '---' > ${PWD}/roles/${ROLE}/tasks/install.yml
    echo '---' > ${PWD}/roles/${ROLE}/tasks/user-config.yml
}

function ergoflash() {
    ZIPFILE=$1
    CURRENTZIP="$HOME/.local/share/ergodox-current.zip"
    TMPDIR="${HOME}/shm/ergoflash"

    mv -f $ZIPFILE $CURRENTZIP

    mkdir $TMPDIR
    unzip -d $TMPDIR $CURRENTZIP

    sudo dfu-util -D $TMPDIR/left_kiibohd.dfu.bin
    sudo dfu-util -D $TMPDIR/right_kiibohd.dfu.bin

    rm -rf $TMPDIR
}