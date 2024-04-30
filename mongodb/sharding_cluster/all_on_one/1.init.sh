#!/bin/bash

read -p "ROOT user: " usern
read -s -p "ROOT Password: " password

if [ -z "$usern" ]
then
   echo 'EMPTY ROOT user'
   exit 1
fi

if [ -z "$password" ]
then
   echo 'EMPTY ROOT password'
   exit 1
fi

## Generate global auth key between cluster nodes
openssl rand -base64 756 > mongodb.key
chown 999:root mongodb.key
chmod 600 mongodb.key

# Start 
docker compose -f docker-compose.yaml up -d
sleep 5

# Init Config Nodes
docker exec -it configsvr1 bash -c "mongosh --quiet --eval 'rs.initiate({_id: \"config_rs\",configsvr: true, members: [{ _id : 0, host : \"configsvr1:27017\" },{ _id : 1, host : \"configsvr2:27017\" }, { _id : 2, host : \"configsvr3:27017\" }]})'"
sleep 5

# Init Sharded Group 1
docker exec -it shardsvr1_1 bash -c "mongosh --quiet --eval 'rs.initiate({_id : \"shard1_rs\", members: [{ _id : 0, host : \"shardsvr1_1:27017\" },{ _id : 1, host : \"shardsvr1_2:27017\" },{ _id : 2, host : \"shardsvr1_3:27017\" }]})'"
sleep 5

# Init Sharded Group 2
docker exec -it shardsvr2_1 bash -c "mongosh --quiet --eval 'rs.initiate({_id : \"shard2_rs\", members: [{ _id : 0, host : \"shardsvr2_1:27017\" },{ _id : 1, host : \"shardsvr2_2:27017\" },{ _id : 2, host : \"shardsvr2_3:27017\" }]})'"
sleep 5

# Init Router
sleep 5
docker exec -it mongos bash -c "mongosh --quiet --eval 'sh.addShard(\"shard1_rs/shardsvr1_1:27017,shardsvr1_2:27017,shardsvr1_3:27017\");sh.addShard(\"shard2_rs/shardsvr2_1:27017,shardsvr2_2:27017,shardsvr2_3:27017\")'"

## Enable admin account
docker exec -it mongos bash -c "mongosh --quiet --eval 'admin = db.getSiblingDB(\"admin\");admin.createUser({user: \"$usern\",pwd: \"$password\",roles:[\"root\" ]})'"
