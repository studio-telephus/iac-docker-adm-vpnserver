# OpenVPN

This guide explains the process of setting up an OpenVPN container on a Debian container created with LXC.

After completing the automated TF, run the script to install OpenVPN server

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

    nmcli connection import type openvpn file fname-sname-tel.ovpn

    tcpdump -ni eth0 udp and port 11150

    nc -zv -u 10.10.0.110 11150
    nc -zv -u 193.40.103.103 11150

    echo -n "hello" >/dev/udp/10.10.0.110/11150
    echo -n "hello" >/dev/udp/193.40.103.103/11150

###

Allow Packet Forwarding in Docker (by default, Docker restricts forwarding)

    echo "net.ipv4.conf.all.forwarding = 1" | tee -a /etc/sysctl.conf
    sysctl -p

Then

    iptables -t nat -A PREROUTING -i eth0 -p udp --dport 11150 -j DNAT --to-destination 10.10.0.110:11150

Manually Adjust Docker’s iptables Rules

    iptables -I DOCKER-USER -p udp --dport 11150 -j ACCEPT
    
Make it persistent    
    
    iptables-save > /etc/iptables/rules.v4

Your current MASQUERADE rules are only applying to Docker networks. Explicitly allow VPN clients to be NATed.

    iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -o eth0 -j MASQUERADE

Ensure packet forwarding is enabled

    sysctl -w net.ipv4.ip_forward=1
    echo "net.ipv4.ip_forward = 1" | tee -a /etc/sysctl.conf
    sysctl -p

## Links

- https://serverfault.com/questions/187915/openvpn-port-share-with-apache-ssl
- https://www.cyberciti.biz/faq/debian-10-set-up-openvpn-server-in-5-minutes/
- [OpenVPN vs Wireguard](https://www.google.com/search?q=wireguard+vs+openvpn&oq=wireguard+vs+&gs_lcrp=EgZjaHJvbWUqDAgAEAAYQxiABBiKBTIMCAAQABhDGIAEGIoFMgYIARBFGDkyBwgCEAAYgAQyBwgDEAAYgAQyBwgEEAAYgAQyCAgFEAAYFhgeMggIBhAAGBYYHjIICAcQABgWGB4yCAgIEAAYFhgeMgoICRAAGAoYFhgeqAIAsAIA&sourceid=chrome&ie=UTF-8#ip=1)
- https://github.com/eBayClassifiedsGroup/PanteraS/blob/master/optional/openvpn/Dockerfile

## Deprecated

    sudo openvpn --client --config /etc/openvpn/client/kristo-aun-tel.ovpn
    iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 22110 -j DNAT --to-destination 10.10.0.110:22
