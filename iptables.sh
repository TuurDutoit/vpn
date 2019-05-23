#!/bin/bash

echo "
#!/bin/bash

# Firewall & NAT rules for OpenVPN gateway to $CLIENT_NAME
iptables -A FORWARD -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -s $LOCAL_PRIVATE_IP -j ACCEPT
iptables -A FORWARD -d $REMOTE_PUBLIC_IP -j ACCEPT
iptables -P FORWARD DROP
iptables -t nat -A PREROUTING -i $REMOTE_PUBLIC_INT -d $REMOTE_PUBLIC_IP -j DNAT --to-destination $LOCAL_PRIVATE_IP
iptables -t nat -A POSTROUTING -o $REMOTE_PUBLIC_INT -s $LOCAL_PRIVATE_IP -j SNAT --to-source $REMOTE_PUBLIC_IP
" >> /etc/rc.local

chmod +x /etc/rc.local
sudo bash /etc/rc.local