ARG BUILD_FROM
FROM $BUILD_FROM

# sslh is only in edge. Install it along with its deps from edge.
RUN \
    echo "https://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories \
    && echo "https://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
    && apk update \
    && apk add --no-cache \
        sslh \
    && sed -i '/edge/d' /etc/apk/repositories \
    && apk update

# Copy s6 service definition
COPY rootfs /
