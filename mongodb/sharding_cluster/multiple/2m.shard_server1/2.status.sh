#!/bin/bash

# Status docker Mongo sharded cluster
docker exec -it shardsvr1_1 bash -c "mongosh --quiet --eval 'rs.status()'"
