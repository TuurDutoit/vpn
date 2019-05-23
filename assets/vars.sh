# Remote: a server with 2 public IPs - one for the VPN tunnel and 1 that is forwarded to the local server
# Local: a server that is not reachable from the public internet because of NAT. It will receive a public IP through a VPN tunnel to the remote
# Public IP: the IP address on the remote server that is forwarded throught the VPN tunnel to the local server
# Bind IP: the IP address on the remote server that OpenVPN binds to

export REMOTE_BIND_IP='134.209.197.36' # Remote IP used for VPN connection (must be different from PUBLIC_IP)
export REMOTE_BIND_PORT='1194'         # The port used by OpenVPN
export REMOTE_PUBLIC_IP='10.18.0.7'    # The public IP that will be tunneled to the private server
export REMOTE_PUBLIC_INT='eth0'        # The NIC for the public (tunneled) IP
export REMOTE_PRIVATE_IP='172.16.0.1'  # The IP of the remote end of the VPN tunnel
export LOCAL_PRIVATE_IP='172.16.0.2'   # The IP of the local end of the VPN tunnel. Must be adjacent to REMOTE counterpart
export CLIENT_NAME='client1'           # Mainly used for filenames