#!/usr/bin/env bash

echo "Configure supervisor"
cat <<EOF > /etc/supervisor/conf.d/supervisord.conf
[supervisord]
nodaemon=true
user=root

[unix_http_server]
file=/tmp/supervisor.sock

[inet_http_server]
port=:9001

[supervisorctl]
serverurl=unix:///tmp/supervisor.sock

[rpcinterface:supervisor]
supervisor.rpcinterface_factory = supervisor.rpcinterface:make_main_rpcinterface

[program:openvpn]
command=openvpn --config /etc/openvpn/openvpn.conf
autorestart=true
user=root
stdout_events_enabled = true
stderr_events_enabled = true

[program:nslcd]
command=/usr/sbin/nslcd -n
autorestart=true
user=root
stdout_events_enabled = true
stderr_events_enabled = true

[eventlistener:stdout]
command = supervisor_stdout
buffer_size = 100
events = PROCESS_LOG
result_handler = supervisor_stdout:event_handler
EOF
