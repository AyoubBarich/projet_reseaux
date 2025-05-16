#!/bin/bash

# Enable IP forwarding
sysctl -w net.ipv4.ip_forward=1

# Fix permissions for FRR config files
chown -R frr:frr /etc/frr
chmod 640 /etc/frr/frr.conf
chmod 640 /etc/frr/vtysh.conf
chmod 640 /etc/frr/daemons

# Start FRR
service frr stop || true
service frr start

# Enable multicast
sysctl -w net.ipv4.icmp_echo_ignore_broadcasts=0
sysctl -w net.ipv4.conf.all.mc_forwarding=1
sysctl -w net.ipv4.conf.eth0.mc_forwarding=1

# Keep container running
tail -f /dev/null 