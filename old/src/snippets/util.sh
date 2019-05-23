function err {
    echo "$@" 1>&2
}

function error {
    err "${@:2}"
    exit "$1"
}

function check_root {
    USER=`whoami`

    if [ "$USER" != "root" ]; then
        error 1 "You need to run me with root!"
    fi
}

function confirm {
    MSG="${1:-Are you sure? [Y|n]} "
    CONFIRMATION='no'
    read -p "$MSG" -n 1 -r CONFIRMATION
    echo
    
    if ! [[ "$CONFIRMATION" =~ ^[Yy]$ ]] && ! [[ -z "$CONFIRMATION" ]]; then
        error 2 Aborting
    fi
}