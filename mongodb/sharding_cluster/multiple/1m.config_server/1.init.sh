#!/bin/bash

# Init Config Nodes
docker compose -f docker-compose.yaml up -d
sleep 5
docker exec -it configsvr1 bash -c "mongosh --quiet --eval 'rs.initiate({_id: \"config_rs\",configsvr: true, members: [{ _id : 0, host : \"<your-ip>:10001\" },{ _id : 1, host : \"<your-ip>:10002\" }, { _id : 2, host : \"<your-ip>:10003\" }]})'"

