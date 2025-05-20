#!/bin/bash

# Create a test DHCP client container to verify DHCP server is working
echo "Creating DHCP test client on particulier network..."
docker run --rm -it \
  --name dhcp-test-client \
  --network as_particulier \
  --privileged \
  --ip 120.0.24.99 \
  --cap-add=NET_ADMIN \
  alpine:latest \
  /bin/sh -c "echo 'Current network configuration:' && \
              ip addr && \
              echo '------------------------------' && \
              echo 'Testing ping to router (120.0.24.10)...' && \
              ping -c 3 120.0.24.10 && \
              echo '------------------------------' && \
              echo 'Testing ping to DHCP server (120.0.24.2)...' && \
              ping -c 3 120.0.24.2 && \
              echo '------------------------------' && \
              echo 'Running simple DHCP client (udhcpc)...' && \
              # Busybox udhcpc is included in Alpine by default
              udhcpc -i eth0 -f -v -R && \
              echo '------------------------------' && \
              echo 'Network config after DHCP:' && \
              ip addr" 