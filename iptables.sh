#!/bin/bash
source vars
iptables -t nat -A POSTROUTING -o "$PUBLIC_INT" -i "$PRIVATE_INT" -s "$SERVER_IP" -j SNAT --to-source "$PUBLIC_IP"
iptables -t nat -A PREROUTING -i "$PUBLIC_INT" -d "PUBLIC_IP" -j DNAT --to-destination "$SERVER_IP"