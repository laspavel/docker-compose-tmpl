#!/bin/sh
# show just running and/or "should be running" services
watch -n1 "docker service ls | grep -v 0/0"