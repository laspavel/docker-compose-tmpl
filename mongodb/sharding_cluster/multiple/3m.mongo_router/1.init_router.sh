#!/bin/bash

read -p "Admin user: " usern
read -s -p "Password: " password

if [ -z "$usern" ]
then
   echo 'EMPTY Admin user'
   exit 1
fi

if [ -z "$password" ]
then
   echo 'EMPTY Password'
   exit 1
fi

# Init Router
docker compose -f docker-compose.yaml up -d
sleep 5
docker exec -it mongos bash -c "mongosh --quiet --eval 'sh.addShard(\"shard1_rs/<your-ip>:20001,<your-ip>:20002,<your-ip>:20003\");sh.addShard(\"shard2_rs/<your-ip>:20004,<your-ip>:20005,<your-ip>:20006\")'"
sleep 2

## Enable admin account
docker exec -it mongos bash -c "mongosh --quiet --eval 'admin = db.getSiblingDB(\"admin\");admin.createUser({user: \"$usern\",pwd: \"$password\",roles:[\"root\" ]})'"