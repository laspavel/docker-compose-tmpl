#!/bin/bash

TODAY=`date +%Y.%m.%d-%H.%M`

DOCKER_REPO=dockerhub.exqmple.com/project1/repo1
CONTAINER_VER=1.0-$TODAY
docker build --no-cache --file Dockerfile --force-rm -t $DOCKER_REPO:$CONTAINER_VER .
docker tag $DOCKER_REPO:$CONTAINER_VER $DOCKER_REPO:latest
docker push $DOCKER_REPO:$CONTAINER_VER
docker push $DOCKER_REPO:latest
