FROM debian:stretch-slim

# Setup apt repo
RUN set -ex; \
    \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        wget \
        gnupg \
        ca-certificates \
    ; \
    \
    wget -qO- https://doozer.io/keys/tvheadend/tvheadend/pgp | apt-key add -; \
    echo "deb http://apt.tvheadend.org/stable stretch main" | tee -a /etc/apt/sources.list.d/tvheadend.list; \
    \
    apt-get purge -y --auto-remove \
        wget \
        gnupg \
        ca-certificates \
    ; \
    rm -rf /var/lib/apt/lists/*

# Install tvheadend
RUN set -ex; \
    \
    apt-get update; \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        tvheadend \
    ; \
    rm -rf /home/hts/.hts; \
    rm -rf /var/lib/apt/lists/*

USER hts

RUN mkdir /home/hts/config

VOLUME /home/hts/config

CMD ["tvheadend", "-c", "/home/hts/config", "-C"]
