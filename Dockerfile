FROM twinproduction/gatus:v5.7.0 as gatus

FROM alpine:3.19.0 as builder

COPY --from=gatus /gatus /build/
COPY --from=gatus /config/config.yaml /build/config/config.yaml
COPY --from=gatus /etc/ssl/certs/ca-certificates.crt /build/etc/ssl/certs/ca-certificates.crt

FROM alpine:3.19.0

COPY --from=builder /build /

RUN addgroup gatus && adduser -u 1000 -S -D -G gatus gatus && \
# install tinydns
    apk add --no-cache unbound && \
# clean up
    rm -rf /apk /tmp/* /var/cache/apk/*

USER gatus

ENTRYPOINT ["/gatus"]