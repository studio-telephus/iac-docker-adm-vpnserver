#!/usr/bin/env bash

echo "Install the base tools"

apt-get update
apt-get install -y \
 curl vim wget htop unzip gnupg2 netcat-traditional \
 bash-completion git openssh-server

## Run pre-install scripts
sh /mnt/setup-ca.sh


echo "Install and configure the necessary dependencies"
apt-get install -y curl openssh-server ca-certificates perl


## Openvpn

### Download and run debian10-vpn.sh script
wget https://raw.githubusercontent.com/Angristan/openvpn-install/master/openvpn-install.sh
chmod +x openvpn-install.sh

### Run the script manually to install OpenVPN server
