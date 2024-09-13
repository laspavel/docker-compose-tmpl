#!/bin/bash

export CR_PAT=YOUR_TOKEN
echo $CR_PAT | docker login ghcr.io -u laspavel --password-stdin

TODAY=`date +%Y.%m.%d-%H.%M`
CONTAINER_VER=1.0-$TODAY

DOCKER_REPO1=ghcr.io/MYCOMPANY/REPONAME
docker build --no-cache --file Dockerfiles/Dockerfile.repo --force-rm -t $DOCKER_REPO1:$CONTAINER_VER .
docker tag $DOCKER_REPO1:$CONTAINER_VER $DOCKER_REPO1:latest
docker push $DOCKER_REPO1:$CONTAINER_VER
docker push $DOCKER_REPO1:latest

docker logout ghcr.io