#!/bin/bash

CONTAINER_VER=6.6-r0
docker build --no-cache --file src/Dockerfile --force-rm -t dockerhub.example.com/bastion/squid:$CONTAINER_VER src
docker tag dockerhub.example.com/bastion/squid:$CONTAINER_VER dockerhub.example.com/bastion/squid:latest
docker push dockerhub.example.com/bastion/squid:$CONTAINER_VER
docker push dockerhub.example.com/bastion/squid:latest

