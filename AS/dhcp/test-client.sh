#!/bin/bash

# Create a test DHCP client container to verify DHCP server is working
echo "Creating DHCP test client..."
docker run --rm -it \
  --name dhcp-test-client \
  --network particulier \
  --ip 120.0.24.99 \
  --cap-add=NET_ADMIN \
  alpine:latest \
  /bin/sh -c "apk add --no-cache dhclient iproute2 && \
              echo 'Current network configuration:' && \
              ip addr show && \
              echo 'Releasing any existing IP and requesting from DHCP...' && \
              ip addr flush dev eth0 && \
              echo 'Running DHCP client...' && \
              dhclient -v eth0 && \
              echo 'DHCP lease obtained:' && \
              ip addr show eth0 && \
              echo 'Testing connection to router...' && \
              ping -c 3 120.0.24.10" 