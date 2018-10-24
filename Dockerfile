FROM debian:stretch-slim

RUN set -ex; \
    fetchDeps=" \
        gnupg \
        dirmngr \
        apt-transport-https \
        ca-certificates \
        wget \
    "; \
    apt-get update; \
    apt-get install -y --no-install-recommends $fetchDeps; \
    \
    wget -qO- https://doozer.io/keys/tvheadend/tvheadend/pgp | apt-key add -; \
    echo "deb https://apt.tvheadend.org/unstable $(lsb_release -sc) main" | tee -a /etc/apt/sources.list.d/tvheadend.list; \
    \
    apt-get update; \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        tvheadend \
    ; \
    rm -rf /home/hts/.hts; \
    \
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false $fetchDeps; \
    rm -rf /var/lib/apt/lists/*

USER hts

RUN mkdir /home/hts/config

VOLUME /home/hts/config

CMD ["tvheadend", "-c", "/home/hts/config", "-C"]
