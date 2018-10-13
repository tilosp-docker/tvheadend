FROM debian:stretch-slim

RUN set -ex; \
    fetchDeps=" \
        gnupg \
        dirmngr \
        apt-transport-https \
        ca-certificates \
    "; \
    apt-get update; \
    apt-get install -y --no-install-recommends $fetchDeps; \
    \
    apt-key adv --keyserver ha.pool.sks-keyservers.net --recv-keys 379CE192D401AB61; \
    echo "deb https://dl.bintray.com/tvheadend/deb stretch stable-4.2" | tee -a /etc/apt/sources.list.d/tvheadend.list; \
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
