FROM twinproduction/gatus:v5.18.1 AS gatus

FROM alpine:3.22.0 AS builder

COPY ./rootfs /build/
COPY --from=gatus /gatus /build/usr/local/bin
COPY --from=gatus /config/config.yaml /build/config/config.yaml
COPY --from=gatus /etc/ssl/certs/ca-certificates.crt /build/etc/ssl/certs/ca-certificates.crt

FROM alpine:3.22.0

COPY --from=builder /build /

RUN addgroup gatus && adduser -u 1000 -S -D -G gatus gatus && \
# install unbound
    apk add --no-cache bash unbound && \
# clean up
    rm -rf /apk /tmp/* /var/cache/apk/*

USER gatus

ENTRYPOINT ["entrypoint"]