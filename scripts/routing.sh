#!/bin/bash

cp ./assets/nat.rules ./build/

sed -i "s;__CLIENT_NAME__;$CLIENT_NAME" ./build/before.rules
sed -i "s;__LOCAL_PRIVATE_IP__;$LOCAL_PRIVATE_IP" ./build/before.rules
sed -i "s;__REMOTE_PUBLIC_INT__;$REMOTE_PUBLIC_INT" ./build/before.rules
sed -i "s;__REMOTE_PUBLIC_IP__;$REMOTE_PUBLIC_IP" ./build/before.rules

if [ -z `command -v ufw` ]; then
    ./scripts/iptables.sh
else
    ./scripts/ufw.sh
fi