#!/bin/bash

CONTAINER_VER=5.2-r0
docker build --no-cache --file src/Dockerfile --force-rm -t dockerhub.atbmarket.com/bastion/squid:$CONTAINER_VER src
docker tag dockerhub.atbmarket.com/bastion/squid:$CONTAINER_VER dockerhub.atbmarket.com/bastion/squid:latest
docker push dockerhub.atbmarket.com/bastion/squid:$CONTAINER_VER
docker push dockerhub.atbmarket.com/bastion/squid:latest

