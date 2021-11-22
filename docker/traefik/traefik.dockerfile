# http, https
ARG SERVER_SCHEME=http

# http, http2
ARG SERVER_PROTOCOL=http

# http, https
ARG DOWNSTREAM_SCHEME=http

# http, http2
ARG DOWNSTREAM_PROTOCOL=http

FROM traefik:latest AS base

ENV DOWNSTREAM_SCHEME http
ENV DOWNSTREAM_ADDRESS localhost
ENV DOWNSTREAM_PORT 8081

ADD testCert.crt /etc/testCert.crt
ADD testCert.rsa /etc/testCert.key

ADD run.sh /
RUN chmod +x /run.sh

# Listening to http connections proxying http
FROM base AS scheme-http-http-to-http-http

# ARG SERVER_SCHEME 
ADD traefik-http.yaml /etc/traefik/traefik.yaml
ADD downstream-http.yaml /etc/traefik/downstream.yaml

FROM base AS scheme-https-http-to-https-http

ADD traefik-https.yaml /etc/traefik/traefik.yaml
ADD downstream-https.yaml /etc/traefik/downstream.yaml

FROM scheme-${SERVER_SCHEME}-${SERVER_PROTOCOL}-to-${DOWNSTREAM_SCHEME}-${DOWNSTREAM_PROTOCOL} AS final

ENTRYPOINT ["/run.sh"]
