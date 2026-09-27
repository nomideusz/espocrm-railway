#!/usr/bin/env bash
# Railway entrypoint: install or migrate, then run Apache, the job daemon and
# the WebSocket server in this one container. If any of them exits, stop the
# rest and exit non-zero so Railway restarts the whole service.
set -euo pipefail
cd /var/www/html

# The volume is mounted at data/; custom/ and client/custom/ point into it.
rm -rf data/lost+found
[ -d data/custom ] || cp -a /usr/src/espocrm-seed/custom data/custom
[ -d data/client-custom ] || cp -a /usr/src/espocrm-seed/client-custom data/client-custom

# Re-applied on every boot, so a custom domain only needs ESPOCRM_SITE_URL
# changed; the WebSocket address follows the site URL.
export ESPOCRM_CONFIG_SITE_URL="$ESPOCRM_SITE_URL"
export ESPOCRM_CONFIG_USE_WEB_SOCKET="${ESPOCRM_CONFIG_USE_WEB_SOCKET:-true}"

# Upstream's entrypoint installs on first boot, migrates on upgrade and applies
# ESPOCRM_CONFIG_* - but only when starting Apache. `apache2 -v` only prints
# the version.
docker-entrypoint.sh apache2 -v >/dev/null
# It runs as root; keep everything writable by Apache and the daemon.
chown -R www-data:www-data data

pids=()
runuser -u www-data -- php daemon.php & pids+=($!)
runuser -u www-data -- php websocket.php & pids+=($!)
apache2-foreground & pids+=($!)

trap 'kill -TERM "${pids[@]}" 2>/dev/null; wait' TERM INT
set +e
wait -n "${pids[@]}"
status=$?
echo "An EspoCRM process exited ($status), stopping the rest" >&2
kill -TERM "${pids[@]}" 2>/dev/null
wait
[ "$status" -eq 0 ] && status=1
exit "$status"
