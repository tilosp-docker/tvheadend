FROM linuxserver/tvheadend

RUN chown -R abc:abc /picons && sed -i '/\/picons/d' /etc/cont-init.d/30-config && sed -i 's/\/config \\/\/config/g' /etc/cont-init.d/30-config
