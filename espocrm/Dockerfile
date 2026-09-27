# EspoCRM in one service: Apache, the job daemon and the WebSocket server,
# supervised by railway-entrypoint.sh. Upstream's compose runs each as its own
# container sharing three volumes; a Railway volume can't be shared.
FROM espocrm/espocrm:10.0.8

# One volume per service, mounted at data/. custom/ (entity and layout
# changes, extensions) and client/custom/ live on it too: they become symlinks
# into data/, seeded from the image on first boot.
RUN set -eux; \
    mkdir /usr/src/espocrm-seed; \
    mv custom /usr/src/espocrm-seed/custom; \
    mv client/custom /usr/src/espocrm-seed/client-custom; \
    ln -s /var/www/html/data/custom custom; \
    ln -s /var/www/html/data/client-custom client/custom; \
    a2enmod remoteip; \
    sed -i '/CustomLog/d' /etc/apache2/sites-enabled/000-default.conf; \
    a2disconf other-vhosts-access-log
COPY railway.conf /etc/apache2/conf-enabled/railway.conf
COPY railway-entrypoint.sh /usr/local/bin/railway-entrypoint.sh

# The base image stops Apache with SIGWINCH, which the supervisor would ignore.
STOPSIGNAL SIGTERM
ENTRYPOINT ["railway-entrypoint.sh"]
CMD []
