#!/bin/bash

# Init Sharded Group 2
docker compose -f docker-compose.yaml up -d
sleep 5
docker exec -it shardsvr2_1 bash -c "mongosh --quiet --eval 'rs.initiate({_id : \"shard2_rs\", members: [{ _id : 0, host : \"<your-ip>:20004\" },{ _id : 1, host : \"<your-ip>:20005\" },{ _id : 2, host : \"<your-ip>:20006\" }]})'"
