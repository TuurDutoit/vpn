#!/bin/bash

mkdir /etc/openvpn/nat
cp ./build/nat.rules "/etc/openvpn/nat/$CLIENT_NAME.rules"

# Insert NAT rules into iptables via rc.local (executed when the server boots)
# FORWARD rules target LOCAL_PRIVATE_IP as destination, because of the PREROUTING DNAT rule
# SNAT happens in POSTROUTING, so destination is the real one
echo "
#!/bin/bash

# Firewall & NAT rules for OpenVPN gateway to $CLIENT_NAME
iptables-restore --no-flush /etc/openvpn/nat/$CLIENT_NAME.rules
" >> /etc/rc.local

chmod +x /etc/rc.local
sudo bash /etc/rc.local

# Enable IPv4 packet forwarding
sed -i -E 's;#?\s*net\.ipv4\.ip_forward\s*=\s*[01];net.ipv4.ip_forward = 1;' /etc/sysctl.conf
sysctl -p /etc/sysctl.conf