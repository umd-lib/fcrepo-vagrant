#!/bin/bash

for port in "$@"; do
    iptables -I INPUT -p tcp --dport "$port" -j ACCEPT
done

if [ $# -gt 0 ]; then
    service iptables save
fi
