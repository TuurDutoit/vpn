VPN
===
This repo contains some scripts that set up an OpenVPN server and generate the corresponding client config, to make it possible to forward a public IP to a client server on a private network through a VPN tunnel.

## Supported platforms
Only Debian-based systems are supported. Tested on Ubuntu 18.04.

## Usage
Follow the steps below to set up your VPN server and client. The scripts have to be run as `root` (or with `sudo`).

### Server
1. Clone this repo on the server where you want to install the OpenVPN server:

```bash
$ git clone https://github.com/TuurDutoit/vpn.git && cd vpn
```

2. Fill in all the variables in `assets/vars.sh`
3. Execute the `vpn.sh` script - as `root` or with `sudo`. Make sure you are inside the `vpn` directory!

```bash
$ sudo ./vpn.sh
```

4. OpenVPN is installed, the server configuration files and certificates, as well as a client configuration file, are placed in `/etc/openvpn`, a few NAT rules are added to iptables and IPv4 packet forwarding is enabled.

### Client
1. Install OpenVPN (as `root` or with `sudo`):

```bash
$ apt install openvpn
```

2. Upload the client config (the `.ovpn` file placed in the `clients` folder during the server setup) to the client server

3. Start OpenVPN (as `root` or with `sudo`):

```bash
$ openvpn --config client1.ovpn
```

Note that the default gateway of the client will be overriden, which might cut off your SSH connection. You can however connect to the public IP on the remote server, which will tunnel your SSH traffic to the client.  
You can do this with a service file if you want it to run constantly.

## pfSense
If you'll be using pfSense as the client server, use the following settings.

### 1. Register the CA
Under `System > Cert. Manager > CAs`, click `Add`. Fill in a name for the CA and choose `Import an existing Certificate Authority` under `Method`. Paste the contents of the `ca.crt` file (under `/etc/openvpn` on the remote server) into the `Certificate data` field. You can leave the `Certificate Private Key` field empty. Click `Save`.

### 2. Register the server certificate
Under `System > Cert. Manager > Certificates`, click `Add/Sign`. Select `Import an existing Certificate` as `Method`, fill in a name, and then paste the contents of the `client.crt` and `client.key` files (found under `/etc/openvpn` on the remote server) into the `Certificate data` and `Private key data` fields respectively. The names of the files can be different for you: they correspond to the value of the `CLIENT_NAME` variable. Click `Save`.

### 3. Register the OpenVPN connection
Under `VPN > OpenVPN > Clients`, click `Add`. Use the settings below; ones that aren't mentioned probably aren't important.

### 4. Enable the interface
Under `Interfaces > Assignments`, select the OpenVPN connection next to `Available network ports` and click `Add`. The OpenVPN tunnel should now be up and running!

### Settings
In short:
 - Server host or address: the IP of the remote server
 - TLS configuration: use the TLS key generated on the remote
 - Select the CA and client certificate
 - Encryption algorithms: AES-256-CBC and SHA256
 - Compression: disable
 - Topology: net30
 - Extra options: `ifconfig $LOCAL_PRIVATE_IP $REMOTE_PRIVATE_IP;remote-cert-tls server`

All settings:
 - Server mode: Peer to peer (SSL / TLS)
 - Protocol: UDP on IPv4 only (you might have to change firewall rules if you want to use TCP. IPv6 is completely unsupported)
 - Device mode: tun
 - Interface: choose the interface you want to initiate the tunnel from. Probably `WAN`.
 - Local port: you can leave this field empty (a random port will be used), but filling in a value here makes the firewall rules easier
 - Server host or address: the IP of the remote server, corresponding to the `REMOTE_BIND_IP` variable
 - TLS configuration: use a TLS Key
 - Automatically generate a TLS key: no (uncheck)
 - TLS Key: paste the contents of the `ta.key` file (under `/etc/openvpn` on the remote server)
 - TLS Key Usage Mode: Authentication
 - Peer Certificate Authority: select the CA you registered in step 1
 - Client certificate: select the certificate you registered in step 2
 - Encryption algorithm: AES-256-CBC
 - Auth digest algorithm: SHA256
 - Compression: Disable compression (`comp-lzo` is deprecated since OpenVPN 2.4, as it trumps the strength of the encryption)
 - Topology: net30
 - Don't pull routes: I enable this (checked) and choose the OpenVPN interface as default gateway, but it should work with this option disabled
 - Don't add/remove routes: I leave this unchecked
 - Custom options: very important! Set to the following value: `ifconfig 172.16.0.2 172.16.0.1;remote-cert-tls server`. Substitute the two IP adresses with your choice for `LOCAL_PRIVATE_IP` and `REMOTE_PRIVATE_IP` respectively
 - Gateway creation: IPv4 only
 - Verbosity level: you can increase this when debugging

This is the configuration file that pfSense generated for me (`/var/etc/openvpn/client2.conf`):
```openvpn
dev ovpnc2
verb 3
dev-type tun
dev-node /dev/tun2
writepid /var/run/openvpn_client2.pid
#user nobody
#group nobody
script-security 3
daemon
keepalive 10 60
ping-timer-rem
persist-tun
persist-key
proto udp4
cipher AES-256-CBC
auth SHA256
up /usr/local/sbin/ovpn-linkup
down /usr/local/sbin/ovpn-linkdown
local 192.168.5.202
tls-client
client
lport 1195
management /var/etc/openvpn/client2.sock unix
remote x.x.x.x 1194
ca /var/etc/openvpn/client2.ca 
cert /var/etc/openvpn/client2.cert 
key /var/etc/openvpn/client2.key 
tls-auth /var/etc/openvpn/client2.tls-auth 1
ncp-ciphers AES-128-GCM
resolv-retry infinite
route-nopull
ifconfig 172.16.0.2 172.16.0.1
remote-cert-tls server
```