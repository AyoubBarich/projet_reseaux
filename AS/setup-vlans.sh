#!/bin/bash

# Check if running as root
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root"
    exit 1
fi

# Load the 8021q kernel module if not already loaded
if ! lsmod | grep -q 8021q; then
    echo "Loading 8021q kernel module..."
    modprobe 8021q
fi

# Define your main network interface (adjust as needed)
MAIN_INTERFACE="eno1"

# Define VLAN IDs for each network
INTERNAL_VLAN=10    # as_internal
ENTERPRISE_VLAN=16  # entreprise
PARTICULIER_VLAN=24 # particulier
EXTERNAL_VLAN=20    # external

echo "Creating VLANs on interface $MAIN_INTERFACE..."

# Create VLAN interfaces if they don't exist
if ! ip link show ${MAIN_INTERFACE}.${INTERNAL_VLAN} &>/dev/null; then
    echo "Creating VLAN ${INTERNAL_VLAN} for AS Internal network..."
    ip link add link $MAIN_INTERFACE name ${MAIN_INTERFACE}.${INTERNAL_VLAN} type vlan id ${INTERNAL_VLAN}
    ip link set ${MAIN_INTERFACE}.${INTERNAL_VLAN} up
    # No IP needed as Docker will manage this network
fi

if ! ip link show ${MAIN_INTERFACE}.${ENTERPRISE_VLAN} &>/dev/null; then
    echo "Creating VLAN ${ENTERPRISE_VLAN} for Enterprise network..."
    ip link add link $MAIN_INTERFACE name ${MAIN_INTERFACE}.${ENTERPRISE_VLAN} type vlan id ${ENTERPRISE_VLAN}
    ip link set ${MAIN_INTERFACE}.${ENTERPRISE_VLAN} up
fi

if ! ip link show ${MAIN_INTERFACE}.${PARTICULIER_VLAN} &>/dev/null; then
    echo "Creating VLAN ${PARTICULIER_VLAN} for Particulier network..."
    ip link add link $MAIN_INTERFACE name ${MAIN_INTERFACE}.${PARTICULIER_VLAN} type vlan id ${PARTICULIER_VLAN}
    ip link set ${MAIN_INTERFACE}.${PARTICULIER_VLAN} up
fi

if ! ip link show ${MAIN_INTERFACE}.${EXTERNAL_VLAN} &>/dev/null; then
    echo "Creating VLAN ${EXTERNAL_VLAN} for External network..."
    ip link add link $MAIN_INTERFACE name ${MAIN_INTERFACE}.${EXTERNAL_VLAN} type vlan id ${EXTERNAL_VLAN}
    ip link set ${MAIN_INTERFACE}.${EXTERNAL_VLAN} up
fi

# Display all network interfaces to verify
echo "Network interfaces after VLAN setup:"
ip -c link show

echo "VLAN setup complete!"
echo "NOTE: To make these changes persistent across reboots, add them to your network configuration."

# Remove existing networks if they exist
docker network rm as_internal entreprise particulier external

# Create networks manually
docker network create -d macvlan --subnet=10.0.1.0/24 --gateway=10.0.1.1 -o parent=eno1.10 as_internal
docker network create -d macvlan --subnet=120.0.16.0/24 --gateway=120.0.16.1 -o parent=eno1.16 entreprise
docker network create -d macvlan --subnet=120.0.24.0/24 --gateway=120.0.24.1 -o parent=eno1.24 particulier
docker network create -d macvlan --subnet=172.20.0.0/24 --gateway=172.20.0.1 -o parent=eno1.20 external 