#!/usr/bin/env bash

echo "Configure supervisor"
cat <<EOF > /etc/supervisor/conf.d/supervisord.conf
[supervisord]
nodaemon=true

[program:openvpn]
command=openvpn --config /etc/openvpn/openvpn.conf
EOF
