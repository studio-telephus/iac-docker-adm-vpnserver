#!/usr/bin/env bash

echo "Configure supervisor"
cat <<EOF > /etc/supervisor/conf.d/supervisord.conf
[supervisord]
nodaemon=true
user=root

[program:openvpn]
command=openvpn --config /etc/openvpn/server.conf
EOF
