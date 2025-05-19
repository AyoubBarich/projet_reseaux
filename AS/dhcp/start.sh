#!/bin/sh

# Wait for network to be ready
echo "Waiting for network to be ready..."
sleep 5

# Get network information
INTERFACES=$(ip -o link show | awk -F': ' '{print $2}')
echo "Available interfaces: $INTERFACES"

# Get the IP address of the eth0 interface
CONTAINER_IP=$(ip -4 addr show eth0 2>/dev/null | grep -oP '(?<=inet\s)\d+(\.\d+){3}' || echo "")

if [ -z "$CONTAINER_IP" ]; then
    echo "No IP address found on eth0. Using default subnet."
    CONTAINER_NETWORK="120.0.24.0"
    DHCP_RANGE="120.0.24.100,120.0.24.200"
    ROUTER="120.0.24.10"
else
    echo "Container IP: $CONTAINER_IP"
    CONTAINER_NETWORK=$(echo $CONTAINER_IP | sed 's/\.[0-9]*$/.0/')
    echo "Container Network: $CONTAINER_NETWORK"
    
    # Extract the first three octets for DHCP configuration
    NETWORK_PREFIX=$(echo $CONTAINER_NETWORK | cut -d. -f1-3)
    DHCP_RANGE="${NETWORK_PREFIX}.100,${NETWORK_PREFIX}.200"
    ROUTER="${NETWORK_PREFIX}.10"
    
    # Update dnsmasq.conf with the correct subnet
    sed -i "s/dhcp-range=.*/dhcp-range=${DHCP_RANGE},255.255.255.0,12h/" /etc/dnsmasq.conf
    sed -i "s/dhcp-option=option:router,.*/dhcp-option=option:router,${ROUTER}/" /etc/dnsmasq.conf
fi

# Make sure permissions are correct
chmod -R 755 /var/lib/misc
chmod 644 /etc/dnsmasq.conf

# Display the final configuration
echo "------- DHCP Configuration -------"
cat /etc/dnsmasq.conf
echo "---------------------------------"

# Start dnsmasq in the foreground
echo "Starting dnsmasq server on eth0..."
exec dnsmasq -k -d --interface=eth0 