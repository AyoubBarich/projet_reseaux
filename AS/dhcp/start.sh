#!/bin/bash

# Wait for network to be ready
sleep 5

# Get the actual IP address of the container in the particulier network
CONTAINER_IP=$(ip -4 addr show eth0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
CONTAINER_NETWORK=$(echo $CONTAINER_IP | sed 's/\.[0-9]*$/.0/')

echo "Container IP: $CONTAINER_IP"
echo "Container Network: $CONTAINER_NETWORK"

# Update dhcpd.conf with the correct subnet if needed
sed -i "s/subnet [0-9]*\.[0-9]*\.[0-9]*\.[0-9]* netmask/subnet $CONTAINER_NETWORK netmask/" /etc/dhcp/dhcpd.conf

# Ensure permissions are set correctly
chown -R dhcp:dhcp /var/lib/dhcp
chmod -R 755 /var/lib/dhcp

# Start the DHCP server with the correct interface
echo "Starting DHCP server on eth0 for network $CONTAINER_NETWORK..."
exec dhcpd -d -cf /etc/dhcp/dhcpd.conf -lf /var/lib/dhcp/dhcpd.leases -4 --no-pid -user dhcp -group dhcp eth0 