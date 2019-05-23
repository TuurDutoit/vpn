#!/bin/bash

cp ./assets/client.conf ./client.ovpn

sed -i "s;__REMOTE_BIND_IP__;$REMOTE_BIND_IP" ./client.ovpn
sed -i "s;__REMOTE_BIND_PORT__;$REMOTE_BIND_PORT" ./client.ovpn
sed -i "s;__REMOTE_PRIVATE_IP__;$REMOTE_PRIVATE_IP" ./client.ovpn
sed -i "s;__LOCAL_PRIVATE_IP__;$LOCAL_PRIVATE_IP" ./client.ovpn
sed -i -e "s;__CA__;{r /etc/openvpn/ca.crt" -e 'd}' ./client.ovpn
sed -i -e "s;__CERT__;{r /etc/openvpn/$CLIENT_NAME.crt" -e 'd}' ./client.ovpn
sed -i -e "s;__KEY__;{r /etc/openvpn/$CLIENT_NAME.key" -e 'd}' ./client.ovpn
sed -i -e "s;__TLS__;{r /etc/openvpn/ta.key" -e 'd}' ./client.ovpn