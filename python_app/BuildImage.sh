#!/bin/bash
CONTAINER_VER=1.0
docker build --no-cache --file Dockerfile --force-rm -t dockerhub.exqmple.com/project1/repo1:$CONTAINER_VER .
docker tag dockerhub.example.com/project1/repo1:$CONTAINER_VER dockerhub.example.com/project1/repo1:latest
docker push dockerhub.example.com/project1/repo1:$CONTAINER_VER
docker push dockerhub.example.com/project1/repo1:latest
