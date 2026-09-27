# EspoCRM in one service: Apache, the job daemon and the WebSocket server,
# supervised by railway-entrypoint.sh. Upstream's compose runs each as its own
# container sharing three volumes; a Railway volume can't be shared.
FROM espocrm/espocrm:10.0.8

# Railway flattens image layers and drops deletions, so change files in place
# rather than removing them. Access logs off: health checks and every API call
# would flood the log view.
RUN set -eux; \
    a2enmod remoteip; \
    sed -i '/CustomLog/d' /etc/apache2/sites-available/000-default.conf \
        /etc/apache2/conf-available/other-vhosts-access-log.conf
COPY railway.conf /etc/apache2/conf-enabled/railway.conf
COPY railway-entrypoint.sh /usr/local/bin/railway-entrypoint.sh

# The base image stops Apache with SIGWINCH, which the supervisor would ignore.
STOPSIGNAL SIGTERM
ENTRYPOINT ["railway-entrypoint.sh"]
CMD []
