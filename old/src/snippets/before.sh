#!/bin/bash
# This snippet is added before all the scripts

# Check if we're running in Bash
if ! [ -n "$BASH_VERSION" ];then
    echo "This is not bash, calling self with bash....";
    SCRIPT=$(readlink -f "$0")
    /bin/bash $SCRIPT
    exit;
fi

# Import some useful snippets
source snippets/util.sh

# Check have sudo/root permissions.


# Check which package manager to use
if [ -x "$(command -v apt)" ]; then
    PACKAGE_MANAGER="$(command -v apt)"
elif [ -x "$(command -v apt-get)" ]; then
    PACKAGE_MANAGER="$(command -v apt-get)"
else
    error 1 "No valid package manager found" 
fi

# Some scripts can be executed as standalone script OR as part of another script
# When called from another script, we should avoid updating again
if [ -n "$VPN_CONTEXT_INITIALIZED" ]; then
    export VPN_CONTEXT_INITIALIZED='yes'
    
    # Make sure system is up to date
    $PACKAGE_MANAGER update
    $PACKAGE_MANAGER dist-upgrade
fi