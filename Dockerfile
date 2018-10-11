FROM debian:stretch-slim

RUN set -ex; \
    fetchDeps=" \
        curl \
        ca-certificates \
    "; \
    apt-get update; \
    apt-get install -y --no-install-recommends $fetchDeps; \
    \
    curl -fsSL -o tvheadend.deb "https://doozer.io/artifact/m75xabceov/tvheadend_4.2.6-42~g406ba887c~stretch_amd64.deb"; \
    \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        ./tvheadend.deb \
    ; \
    rm -f tvheadend.deb; \
    rm -rf /home/hts/.hts; \
    \
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false $fetchDeps; \
    rm -rf /var/lib/apt/lists/*

USER hts

RUN mkdir /home/hts/config

VOLUME /home/hts/config

CMD ["tvheadend", "-c", "/home/hts/config", "-C"]
