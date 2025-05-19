#!/bin/bash

# Create a test DHCP client container to verify DHCP server is working
docker run --rm -it \
  --name dhcp-test-client \
  --network particulier \
  --cap-add=NET_ADMIN \
  alpine:latest \
  /bin/sh -c "apk add --no-cache dhclient iproute2 && \
              ip link set eth0 down && \
              ip addr flush dev eth0 && \
              ip link set eth0 up && \
              echo 'Testing DHCP request...' && \
              dhclient -v eth0 && \
              echo 'DHCP lease obtained:' && \
              ip addr show eth0" 