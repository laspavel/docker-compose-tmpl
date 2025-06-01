#!/bin/sh
# Purpose: Truncate all docker logs to size 0

truncate -s 0 /var/lib/docker/containers/*/*-json.log
