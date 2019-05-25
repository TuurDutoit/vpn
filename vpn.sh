#!/bin/bash
if ! [ -n "$BASH_VERSION" ]; then
    echo "This is not bash, calling self with bash....";
    SCRIPT=$(readlink -f "$0")
    /bin/bash $SCRIPT
    exit;
fi

# Check have sudo/root permissions.
USER=`whoami`

if [ "$USER" != "root" ]; then
        echo "You need to run me with sudo!"
        exit
fi

source ./assets/vars
./scripts/install.sh
./scripts/pki.sh
./scripts/iptables.conf
./scripts/conf.server.sh
./scripts/conf.client.sh
./scripts/service.sh
