#!/usr/bin/env sh
#echo on
set -x

sed -i "s|DOWNSTREAM_ADDRESS|$DOWNSTREAM_ADDRESS|g" /etc/traefik/downstream.yaml
sed -i "s|DOWNSTREAM_PORT|$DOWNSTREAM_PORT|g" /etc/traefik/downstream.yaml
sed -i "s|DOWNSTREAM_SCHEME|$DOWNSTREAM_SCHEME|g" /etc/traefik/downstream.yaml

cat /etc/traefik/traefik.yaml
cat /etc/traefik/downstream.yaml

/usr/local/bin/traefik --configFile=/etc/traefik/traefik.yaml
