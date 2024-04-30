#!/bin/bash

# Init Sharded Group 1
docker compose -f docker-compose.yaml up -d
sleep 5
docker exec -it shardsvr1_1 bash -c "mongosh --quiet --eval 'rs.initiate({_id : \"shard1_rs\", members: [{ _id : 0, host : \"<your-ip>:20001\" },{ _id : 1, host : \"<your-ip>:20002\" },{ _id : 2, host : \"<your-ip>:20003\" }]})'"

