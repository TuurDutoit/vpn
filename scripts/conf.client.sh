#!/bin/bash

cp ./assets/client.conf "./clients/$CLIENT_NAME.ovpn"

sed -i "s;__REMOTE_BIND_IP__;$REMOTE_BIND_IP;" "./clients/$CLIENT_NAME.ovpn"
sed -i "s;__REMOTE_BIND_PORT__;$REMOTE_BIND_PORT;" "./clients/$CLIENT_NAME.ovpn"
sed -i "s;__REMOTE_PRIVATE_IP__;$REMOTE_PRIVATE_IP;" "./clients/$CLIENT_NAME.ovpn"
sed -i "s;__LOCAL_PRIVATE_IP__;$LOCAL_PRIVATE_IP;" "./clients/$CLIENT_NAME.ovpn"
sed -i -e "/__CA__/{r /etc/openvpn/ca.crt" -e 'd}' "./clients/$CLIENT_NAME.ovpn"
sed -i -e "/__CERT__/{r /etc/openvpn/$CLIENT_NAME.crt" -e 'd}' "./clients/$CLIENT_NAME.ovpn"
sed -i -e "/__KEY__/{r /etc/openvpn/$CLIENT_NAME.key" -e 'd}' "./clients/$CLIENT_NAME.ovpn"
sed -i -e "/__TLS__/{r /etc/openvpn/ta.key" -e 'd}' "./clients/$CLIENT_NAME.ovpn"