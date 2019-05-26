#!/bin/bash

# Enable IPv4 packet forwarding
sed -i -E 's;#?\s*net\.ipv4\.ip_forward\s*=\s*[01];net.ipv4.ip_forward = 1;' /etc/sysctl.conf
sysctl -p /etc/sysctl.conf

# Insert NAT rules into iptables via rc.local (executed when the server boots)
# FORWARD rules target LOCAL_PRIVATE_IP as destination, because of the PREROUTING DNAT rule
# SNAT happens in POSTROUTING, so destination is the real one
echo "
#!/bin/bash

# Firewall & NAT rules for OpenVPN gateway to $CLIENT_NAME
iptables -A FORWARD -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -s $LOCAL_PRIVATE_IP -j ACCEPT
iptables -A FORWARD -d $LOCAL_PRIVATE_IP -j ACCEPT
iptables -P FORWARD DROP
iptables -t nat -A PREROUTING -i $REMOTE_PUBLIC_INT -d $REMOTE_PUBLIC_IP -j DNAT --to-destination $LOCAL_PRIVATE_IP
iptables -t nat -A POSTROUTING -o $REMOTE_PUBLIC_INT -s $LOCAL_PRIVATE_IP -j SNAT --to-source $REMOTE_PUBLIC_IP
" >> /etc/rc.local

chmod +x /etc/rc.local
sudo bash /etc/rc.local