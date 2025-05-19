FROM 3x3cut0r/isc-dhcp-server:latest

# Set environment variables for our specific configuration
ENV TZ="Europe/Paris"
ENV IFACE="eth0"
ENV SUBNET="120.0.24.0"
ENV NETMASK="255.255.255.0"
ENV RANGE_BEGIN="120.0.24.100"
ENV RANGE_END="120.0.24.200"
ENV ROUTERS="120.0.24.10"
ENV DOMAIN_NAME_SERVERS="8.8.8.8, 8.8.4.4"

# You can add custom configurations here if needed
COPY config/dhcpd.conf /etc/dhcp/dhcpd.conf 