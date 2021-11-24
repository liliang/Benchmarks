#!/usr/bin/env bash

#echo on
set -x

# "--network host" - Better performance than the default "bridge" driver
docker run \
    -it \
    --init \
    --name benchmarks-downstream \
    --network host \
    --restart always \
    benchmarks-downstream \
    --urls https://*:8081
