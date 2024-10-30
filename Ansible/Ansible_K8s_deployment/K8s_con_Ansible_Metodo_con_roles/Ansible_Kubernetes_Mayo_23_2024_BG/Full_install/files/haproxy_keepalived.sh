#!/bin/bash
while true; do
    haproxy_status=$(systemctl is-active haproxy)
    if [[ $haproxy_status != "active" ]]; then
        systemctl restart keepalived
    fi
    sleep 10
done
