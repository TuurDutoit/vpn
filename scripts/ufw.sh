#!/bin/bash

# Add NAT rules to UFW
cat ./build/nat.rules >> /etc/ufw/before.rules

# Add firewall rules to ufw
cp ./assets/ufw.conf /etc/ufw/applications.d/openvpn-gateway
sed -i "s;__REMOTE_BIND_PORT__;$REMOTE_BIND_PORT;" /etc/ufw/applications.d/openvpn-gateway
ufw app update 'OpenVPN Gateway'
ufw allow 'OpenVPN Gateway'

# Enable IPv4 packet forwarding
sed -i -E 's;#?\s*net/ipv4/ip_forward\s*=\s*[01];net/ipv4/ip_forward = 1;' /etc/ufw/sysctl.conf

# Reload UFW
ufw reload