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
$ git clone git@github.com:TuurDutoit/vpn.git && cd vpn
```

2. Fill in all the variables in `assets/vars.sh`
3. Execute the `vpn.sh` script - as `root` or with `sudo`. Make sure you are inside the `vpn` directory!

```bash
$ sudo ./vpn.sh
```

4. OpenVPN is installed, the server configuration files and certificates, as well as a client configuration file, are placed in `/etc/openvpn`, a few NAT rules are added to iptables and IPv4 packet forwarding is enabled.