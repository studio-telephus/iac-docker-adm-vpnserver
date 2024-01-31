#!/usr/bin/env bash

echo "Configure supervisor"
cat <<EOF > /etc/supervisor/conf.d/supervisord.conf
[supervisord]
nodaemon=true

[program:named]
command=/usr/sbin/named -c /etc/bind/named.conf -u bind -f
EOF
