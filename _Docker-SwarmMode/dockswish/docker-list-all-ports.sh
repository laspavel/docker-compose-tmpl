#!/bin/sh
# list all used docker ports
for CID in $(docker ps -q)
do
  docker port $CID
done