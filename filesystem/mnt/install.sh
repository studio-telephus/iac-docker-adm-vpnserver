#!/usr/bin/env bash

## Openvpn

apt-get install -y openvpn iptables

### Download and run debian10-vpn.sh script

curl -Lo /tmp/openvpn-install.sh https://raw.githubusercontent.com/Angristan/openvpn-install/master/openvpn-install.sh
chmod +x /tmp/openvpn-install.sh

### Run the script manually to install OpenVPN server
