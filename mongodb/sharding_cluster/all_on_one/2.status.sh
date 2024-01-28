#!/bin/bash

read -p "Admin user: " usern
read -s -p "Password: " password

# Status docker Mongo sharded cluster

docker exec -it configsvr1 bash -c "mongosh -u '$usern' -p '$password' --authenticationDatabase 'admin' --quiet --eval 'rs.status()'"
docker exec -it shardsvr1_1 bash -c "mongosh --quiet --eval 'rs.status()'"
docker exec -it shardsvr2_1 bash -c "mongosh --quiet --eval 'rs.status()'"
docker exec -it mongos bash -c "mongosh -u '$usern' -p '$password' --authenticationDatabase 'admin' --quiet --eval 'sh.status()'"
