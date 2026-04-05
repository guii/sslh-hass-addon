#!/usr/bin/with-contenv bashio
set -euo pipefail

bashio::log.info "sslh addon starting..."

# Generate sslh configuration from Home Assistant addon options
LISTEN_HOST=$(bashio::config 'listen_host')
LISTEN_PORT=$(bashio::config 'listen_port')
VERBOSE=$(bashio::config 'verbose')
TRANSPARENT=$(bashio::config 'transparent')
TIMEOUT=$(bashio::config 'timeout')

CONFIG_FILE="/etc/sslh.cfg"

{
    echo "foreground: true;"
    echo "inetd: false;"
    echo "numeric: false;"
    echo "timeout: ${TIMEOUT};"
    echo "pidfile: \"/var/run/sslh.pid\";"

    if bashio::var.true "${TRANSPARENT}"; then
        echo "transparent: true;"
    fi

    if bashio::var.true "${VERBOSE}"; then
        echo "verbose-config: 3;"
        echo "verbose-connections: 3;"
        echo "verbose-connections-error: 3;"
        echo "verbose-probe-info: 3;"
        echo "verbose-probe-error: 3;"
    else
        echo "verbose-config-error: 3;"
        echo "verbose-connections-error: 3;"
        echo "verbose-probe-error: 3;"
        echo "verbose-system-error: 3;"
    fi

    echo "listen:"
    echo "("
    echo "    { host: \"${LISTEN_HOST}\"; port: \"${LISTEN_PORT}\"; }"
    echo ");"

    echo "protocols:"
    echo "("

    PROTOCOL_COUNT=$(bashio::config 'protocols | length')
    for i in $(seq 0 $((PROTOCOL_COUNT - 1))); do
        ENABLED=$(bashio::config "protocols[${i}].enabled")
        if bashio::var.true "${ENABLED}"; then
            NAME=$(bashio::config "protocols[${i}].name")
            HOST=$(bashio::config "protocols[${i}].host")
            PORT=$(bashio::config "protocols[${i}].port")
            echo "    { name: \"${NAME}\"; host: \"${HOST}\"; port: \"${PORT}\"; log_level: 0; },"
        fi
    done

    echo ");"

} > "${CONFIG_FILE}"

bashio::log.info "Listening on ${LISTEN_HOST}:${LISTEN_PORT}"
bashio::var.true "${TRANSPARENT}" && bashio::log.info "Transparent mode: enabled"

for i in $(seq 0 $((PROTOCOL_COUNT - 1))); do
    ENABLED=$(bashio::config "protocols[${i}].enabled")
    if bashio::var.true "${ENABLED}"; then
        NAME=$(bashio::config "protocols[${i}].name")
        HOST=$(bashio::config "protocols[${i}].host")
        PORT=$(bashio::config "protocols[${i}].port")
        bashio::log.info "Forwarding ${NAME} -> ${HOST}:${PORT}"
    fi
done

bashio::log.info "Starting sslh..."
exec sslh-select -F "${CONFIG_FILE}"
