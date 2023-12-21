FROM alpine
EXPOSE 53/tcp 53/udp
ARG NEXTDNS_VERSION=1.41.0
# Docker variables that is automatically set by Docker's multi-arch build 
ARG TARGETARCH
ARG TARGETPLATFORM

# example: https://github.com/nextdns/nextdns/releases/download/v1.41.0/nextdns_1.41.0_linux_amd64.tar.gz
RUN case ${TARGETPLATFORM} in \
      # older arm archs
      "linux/arm/v7") TARGETARCH=armv7 ;; \
      "linux/arm/v6") TARGETARCH=armv6 ;; \
      # apple m1, pi 4, pi 5,
      "linux/arm64") TARGETARCH=arm64 ;; \
      # intel/amd
      "linux/amd64") TARGETARCH=amd64 ;; \ 
    esac \
    && wget -O /tmp/nextdns.tar.gz https://github.com/nextdns/nextdns/releases/download/v${NEXTDNS_VERSION}/nextdns_${NEXTDNS_VERSION}_linux_$TARGETARCH.tar.gz \
    && tar xf /tmp/nextdns.tar.gz -C /usr/bin nextdns \
    && rm /tmp/nextdns.tar.gz \
    && apk --no-cache add bind-tools

COPY docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]
LABEL org.opencontainers.image.source https://github.com/tecandrew/docker-nextdns