#!/bin/sh

docker system prune --force --all --volumes

# REFS:
# - https://www.digitalocean.com/community/tutorials/how-to-remove-docker-images-containers-and-volumes