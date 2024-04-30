## Sharding in MongoDB using one Docker Host.

Usage plan:

1) Edit mongod_shardsvr.conf to suit your preferences (Settings are appling to Shard instances)
2) Edit docker-compose.yaml to suit your preferences (localtime, number of replicas, groups, etc.)
3) Run cluster initialization (one-time):

```
bash 1.init.sh
```

During the process, you will be asked for the login and password of the root user, which must be installed on the cluster.
A key for authenticating nodes with each other will be created automatically. (mongodb.key)

The initialization process may take from 30 seconds to a minute.

4) View the cluster status:

```
bash 2.status.sh
```

The process will ask for the login and password of the root user, which was specified during its initialization.

5) Uninstall cluster:

```
docker compose down && rm -rf data && rm -f mongodb.key
```

---

