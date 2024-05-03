FROM caddy:2-alpine AS caddy-base

FROM alpine:latest AS xray-builder
ARG XRAY_VERSION="1.8.11"
RUN wget https://github.com/XTLS/Xray-core/releases/download/v${XRAY_VERSION}/Xray-linux-64.zip -O /tmp/xray.zip && \
    unzip /tmp/xray.zip -d /tmp/xray/ && \
    chmod +x /tmp/xray/xray

FROM caddy:2-alpine
COPY --from=xray-builder /tmp/xray/xray /usr/local/bin/xray
COPY xray-config.json /etc/xray/config.json
COPY Caddyfile /etc/caddy/Caddyfile

CMD ["sh", "-c", "xray -config /etc/xray/config.json & exec caddy run --config /etc/caddy/Caddyfile --adapter caddyfile"]
