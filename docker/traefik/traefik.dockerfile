# http, https
ARG SERVER_SCHEME=http

FROM traefik:latest AS base

ENV DOWNSTREAM_SCHEME http
ENV DOWNSTREAM_ADDRESS localhost
ENV DOWNSTREAM_PORT 8081

ADD testCert.crt /etc/ssl/certs/testCert.crt

ADD run.sh /
RUN chmod +x /run.sh

ADD downstream.yaml /etc/traefik/downstream.yaml

# Listening to http connections
FROM base AS scheme-http
# ARG SERVER_SCHEME 
ADD traefik-http.yaml /etc/traefik/traefik.yaml

# Listening to https connections
FROM base AS scheme-https
# ARG SERVER_SCHEME 
ADD traefik-https.yaml /etc/traefik/traefik.yaml

FROM scheme-${SERVER_SCHEME} AS final

ENTRYPOINT ["/run.sh"]
