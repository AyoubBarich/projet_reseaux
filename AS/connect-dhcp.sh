#!/bin/bash

# Wait for DHCP server to start
echo "Waiting for DHCP server container to start..."
sleep 5

# Connect DHCP server to particulier network
echo "Connecting DHCP server to particulier network..."
docker network connect --ip 120.0.24.2 particulier dhcp-server

# Give the container time to process the network change
sleep 2

# Restart DHCP server container to apply changes
echo "Restarting DHCP server..."
docker restart dhcp-server

echo "Done! Check logs with: docker logs dhcp-server" 