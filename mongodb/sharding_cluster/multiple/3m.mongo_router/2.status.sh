#!/bin/bash

read -p "Admin user: " usern
read -s -p "Password: " password

# Status docker Mongo sharded cluster
docker exec -it mongos bash -c "mongosh -u '$usern' -p '$password' --authenticationDatabase 'admin' --quiet --eval 'sh.status()'"
