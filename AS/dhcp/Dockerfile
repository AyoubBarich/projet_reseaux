FROM alpine:latest

# Install dnsmasq instead of DHCP server
RUN set -xe \
    && apk update \
    && apk add --update --no-progress dnsmasq iproute2 \
    && rm -rf /var/cache/apk/*

# Create directory for leases file
RUN mkdir -p /var/lib/misc \
    && touch /var/lib/misc/dnsmasq.leases \
    && chmod -R 755 /var/lib/misc

# Copy our configuration
COPY config/dnsmasq.conf /etc/dnsmasq.conf

# Create a startup script
COPY start.sh /start.sh
RUN chmod +x /start.sh

CMD ["/start.sh"] 