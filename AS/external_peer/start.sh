
#!/bin/bash

# Enable IP forwarding
sysctl -w net.ipv4.ip_forward=1

# Start FRR
service frr start

# Keep container running
tail -f /dev/null 