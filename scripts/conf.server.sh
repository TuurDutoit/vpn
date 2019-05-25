#!/bin/bash

cp ./assets/server.conf /etc/openvpn/server.conf

sed -i "s;__REMOTE_BIND_PORT__;$REMOTE_BIND_PORT;" /etc/openvpn/server.conf
sed -i "s;__REMOTE_BIND_IP__;$REMOTE_BIND_IP;" /etc/openvpn/server.conf
sed -i "s;__REMOTE_PRIVATE_IP__;$REMOTE_PRIVATE_IP;" /etc/openvpn/server.conf
sed -i "s;__LOCAL_PRIVATE_IP__;$LOCAL_PRIVATE_IP;" /etc/openvpn/server.conf
sed -i "s;__KEY_SIZE__;$KEY_SIZE;" /etc/openvpn/server.conf
sed -i "s;__VERB__;$OPENVPN_SERVER_VERB;" /etc/openvpn/server.conf