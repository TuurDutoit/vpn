#!/bin/bash

# Update OS to latest
sudo apt-get update && sudo apt-get dist-upgrade -y

# Install needed packages
sudo apt-get install easy-rsa openvpn openssl udev -y