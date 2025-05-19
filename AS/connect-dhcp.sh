#!/bin/bash

# Make sure the DHCP server container is running
echo "Checking if DHCP server is running..."
if ! docker ps | grep dhcp-server > /dev/null; then
    echo "DHCP server is not running. Starting it..."
    docker-compose up -d dhcp-server
    sleep 5
fi

# Disconnect from temporary network
echo "Disconnecting from temporary network..."
docker network disconnect as_temp_net dhcp-server || echo "Already disconnected"

# Connect DHCP server to particulier network
echo "Connecting DHCP server to particulier network..."
docker network connect --ip 120.0.24.2 as_particulier dhcp-server || echo "Already connected or connection failed"

# Give the container time to process the network change
echo "Waiting for network configuration..."
sleep 3

# Restart DHCP server container to apply changes
echo "Restarting DHCP server..."
docker restart dhcp-server

echo "Waiting for DHCP server to start..."
sleep 5

# Check the logs
echo "DHCP server logs:"
docker logs dhcp-server | tail -30

echo "Done! DHCP server should now be running on the particulier network."
echo "Test with: ./dhcp/test-client.sh" 