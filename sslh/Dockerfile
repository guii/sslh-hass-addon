ARG BUILD_FROM
FROM $BUILD_FROM

# Install sslh
RUN \
    apk add --no-cache \
        sslh

# Copy run script
COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]
