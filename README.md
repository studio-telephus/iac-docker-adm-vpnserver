# OpenVPN

This guide explains the process of setting up an OpenVPN container on an unprivileged Debian container with LXC.

## LXC server

Init container from base image

    lxc init images:debian/bullseye container-vpnserver

Network configuration

    lxc config device override container-vpnserver eth0
    lxc config device set container-vpnserver eth0 ipv4.address 10.0.10.110

Start & enter the container

    lxc start container-vpnserver
    lxc exec container-vpnserver -- /bin/bash

## Inside container-vpnserver

Pre-flight

    apt update && apt install -y vim curl wget htop openssh-server unzip gnupg2 netcat

Add ssh key

    mkdir -p $HOME/.ssh
    echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDz+bA5VtpymU3cwqd1yrbsLNAzEdP5c+IVgb/OHlEzhLj7+ZOlWgWEFkoTTRJO3R1nU19yeMSKyAqG6xU+PWt8zlipgGfINuD168oytTM8UOmX16VZaAoUHFwAB+C7Xd814Os2FB7iXeolQVNRZADWUOF7/XOQVjEpbGVM5InoCvPTWPY9cFgRxJ2qwPZ08f0P6NupymK83LJYj9ELYlMfErxBF2WVObysw9c82oXq1VDLq+/clctVq+EhPkIhdRD1BIqNybQQnfvYnC1jfjHBSGIAfXtvJsjZ8TsHqFyXqOFYkj36/ZZ5GPBpIOsN1JA6NfF080g0Cz3iJohmjZh3 kristoa@telephus" > $HOME/.ssh/authorized_keys

### Openvpn

Download and run debian10-vpn.sh script

    wget https://raw.githubusercontent.com/Angristan/openvpn-install/master/openvpn-install.sh -O openvpn-install.sh

Setup permissions

    chmod +x openvpn-install.sh

Run the script to install OpenVPN server

     ./openvpn-install.sh

Answer like so:

    openvpn.answers.txt

Check for errors

    journalctl --identifier ovpn-server

## Client Setup

### Ubuntu 20.04 LTS

Add VPN -> OpenVPN

Identity
- General
  -- Gateway: telephus.k-space.ee
- Authentication
  -- Type: Certificates (TLS)
  -- CA Certificate acmevpn-ca.pem
  -- User certificate: acmevpn-cert.pem
  -- User private key: acmevpn-key.pem

Advanced
- General
  -- Use custom gateway port: 11150
  -- Set virtual device type: TAP and name: tun
- Security
  -- Cipher: AES-128-GCM
  -- HMAC-Authentication: SHA-256
- TLS Authentication
  -- Server Certificate Check: Don't verify certificate identification
  -- Verify peer (server) certificate usage signature
  -- Remote peer certificate TLS type: Server
  -- Additional TLS authentication or encryption
  --- Mode: TLS-Crypt
  --- Key file: acmevpn-tls-crypt.pem
  -- TLS min version: 1.2

    sudo cp ~/.openvpn-custom/fname-sname-tel.ovpn /etc/openvpn/client/fname-sname-tel.ovpn

    sudo nmcli connection import type openvpn file /etc/openvpn/client/fname-sname-tel.ovpn

    tcpdump -ni eth0 udp and port 11150

    nc -zv -u 10.0.10.110 1150
    nc -zv -u 193.40.103.103 11150

    echo -n "hello" >/dev/udp/10.0.10.110/1150
    echo -n "hello" >/dev/udp/193.40.103.103/11150

###

    iptables -t nat -A PREROUTING -i eth0 -p udp --dport 11150 -j DNAT --to-destination 10.0.10.110:11150

## Links

https://serverfault.com/questions/187915/openvpn-port-share-with-apache-ssl
https://www.cyberciti.biz/faq/debian-10-set-up-openvpn-server-in-5-minutes/

## Deprecated

    sudo openvpn --client --config /etc/openvpn/client/kristo-aun-tel.ovpn
    iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 22110 -j DNAT --to-destination 10.0.10.110:22
