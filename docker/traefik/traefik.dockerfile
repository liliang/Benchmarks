# http, https
ARG SERVER_SCHEME=http

# v2.4 is the latest version that honors the environment variable
# 'GODEBUG=x509ignoreCN=0' to work around the following error.
# >>> x509: certificate relies on legacy Common Name field, use SANs or temporarily.
FROM traefik:v2.4 AS base

#ENV GODEBUG x509ignoreCN=0

ENV DOWNSTREAM_SCHEME http
ENV DOWNSTREAM_ADDRESS localhost
ENV DOWNSTREAM_PORT 8081

#ADD testCert.rsa /etc/ssl/private/testCert.rsa
#ADD testCert.crt /etc/ssl/certs/testCert.crt

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
