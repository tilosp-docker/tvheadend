FROM buildpack-deps:stretch AS builder

RUN set -ex; \
    apt-get update; \
    apt-get install -y \
        lsb-release \
        cmake \
        git \
        build-essential \
        pkg-config \
        gettext \
        libavahi-client-dev \
        libssl-dev \
        zlib1g-dev \
        wget \
        bzip2 \
        git-core \
        liburiparser-dev \
        libpcre3-dev \
        python \
        dvb-apps \
        debhelper \
        ccache \
    ; \
    git clone --depth=50 --branch=release/4.2 https://github.com/tvheadend/tvheadend.git; \
    cd tvheadend; \
    AUTOBUILD_CONFIGURE_EXTRA="--enable-ccache --enable-ffmpeg_static --disable-hdhomerun_client" ./Autobuild.sh -t stretch-amd64; \
    cd ..; \
    mv tvheadend_*_amd64.deb tvheadend_amd64.deb

FROM debian:stretch-slim

COPY --from=builder /tvheadend_amd64.deb /

RUN set -ex; \
    apt-get update; \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        /tvheadend_amd64.deb \
    ; \
    rm -rf /home/hts/.hts /var/lib/apt/lists/*

USER hts

RUN mkdir /home/hts/config

VOLUME /home/hts/config

CMD ["tvheadend", "-c", "/home/hts/config", "-C"]
