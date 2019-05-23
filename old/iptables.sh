#!/bin/bash
source vars
iptables -t nat -A PREROUTING -i "$REMOTE_PUBLIC_INT" -d "$REMOTE_PUBLIC_IP" -j DNAT --to-destination "$LOCAL_PRIVATE_IP"
iptables -t nat -A POSTROUTING -o "$REMOTE_PUBLIC_INT" -s "$LOCAL_PRIVATE_IP" -j SNAT --to-source "$REMOTE_PUBLIC_IP"