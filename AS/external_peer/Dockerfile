
FROM debian:bullseye-slim

RUN apt-get update && apt-get install -y \
    frr \
    iptables \
    iputils-ping \
    traceroute \
    tcpdump \
    net-tools \
    dnsutils \
    curl \
    vim \
    iproute2 \
    && rm -rf /var/lib/apt/lists/*

# Enable FRR daemons
RUN sed -i 's/bgpd=no/bgpd=yes/' /etc/frr/daemons && \
    sed -i 's/ospfd=no/ospfd=yes/' /etc/frr/daemons && \
    sed -i 's/zebra=no/zebra=yes/' /etc/frr/daemons

# Create /run/frr
RUN mkdir -p /run/frr && chown frr:frr /run/frr

# Script to start FRR
COPY start.sh /start.sh
RUN chmod +x /start.sh

CMD ["/start.sh"] 