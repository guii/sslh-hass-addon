ARG BUILD_FROM
FROM $BUILD_FROM

# Install sslh from edge community (not available in stable yet)
RUN \
    grep -q "edge" /etc/apk/repositories \
    || echo "https://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
    && apk update \
    && apk add --no-cache \
        sslh

# Copy run script
COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]
