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

### pfSense