## Sharding in MongoDB running on different docker hosts.

### Usage plan:

1) We create a key for authenticating cluster nodes with each other (mongodb.key):

```
bash 0m.genkey.sh
```

> After creating the key, you need to copy it to the folders 1m.config_server, 2m.shard_server1, 2m.shard_server2, 3m.mongo_router.

2) Edit mongod_shardsvr.conf to suit your preferences (Settings are appling to Shard instances)
3) Edit docker-compose.yaml to suit your preferences (localtime, number of replicas, groups, etc.)
4) Copy:
    * directory 1m.config_server on config nodes
    * directory 2m.shard_server1 on shared nodes of group 1
    * directory 2m.shard_server2 on shared nodes of group 2
    * directory 3m.mongo_router on router node
    Run docker-compose:

```
docker compose up -d
```

5) On the node where the configsvr1 container is running, we start initializing the node config (one-time):

```
bash 1.init.sh
```

6) On the node where the shardsvr1_1 container is running, we start the initialization of shard nodes of group 1 (one-time)::

```
bash 1.init.sh
```
7) On the node where the shardsvr2_1 container is running, we start the initialization of shard nodes of group 2 (one-time)::

```
bash 1.init.sh
```

8) On the router node we start cluster initialization (one-time):

```
bash 1.init.sh
```

During the process, you will be asked for the login and password of the root user, which must be installed on the cluster.

9) View the cluster status:
```
bash 2.status.sh
```

10) Uninstall cluster (on each nodes):

```
docker compose down && rm -rf data && rm -f mongodb.key
```

---

