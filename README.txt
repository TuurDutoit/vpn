This project sets up a p2p VPN that tunnels a public IP to the connected client

Files:
- vpn.sh: installs the VPN server, initializes the PKI and generates a client config
- vpn-del.sh: removes the installed packages and created files, in order to avoid clashes when running vpn.sh again
- iptables.sh: sets up static 1:1 NAT to the connected client. Called by vpn.sh
- client.conf: the client configuration file. Some variables are substituted
- server.conf: the server configuration file. Some variables are substituted