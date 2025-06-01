# Docker Swarm Test

**Traefik, Private Registry, Swarmpit, Let's Encrypt SSL**  
**Multi site with auto discovery**

### Building images
```
docker-compose -f docker-compose.yml -f docker-compose.override.yml build
docker-compose -f docker-compose.yml -f docker-compose.override.yml push
```

### Merge cli vars with env to use inside .sh file
```
if [ -f .env ]
then
  export $(cat .env | sed 's/.*//g' | xargs)
fi
```

### Common commands in common order
```
export CLUSTER=cluster-name

export LEADER=$CLUSTER-leader

docker-machine create --driver digitalocean --digitalocean-image ubuntu-18-04-x64 --digitalocean-access-token $DOTOKEN $LEADER

export LEADER_IP=$(docker-machine ip $LEADER)

eval $(docker-machine env $LEADER)

docker swarm init --advertise-addr=$LEADER_IP

export JOIN_TOKEN=$(docker swarm join-token --quiet worker)

for i in 1 2; do
  WORKER=$CLUSTER-$i
  docker-machine create --driver digitalocean --digitalocean-image ubuntu-18-04-x64 --digitalocean-access-token $DOTOKEN $WORKER
  docker-machine ssh $WORKER "docker swarm join --token ${JOIN_TOKEN} ${LEADER_IP}:2377"
done

docker stack deploy -c docker/registry.yml --with-registry-auth registry

docker stack deploy -c docker/traefik.yml --with-registry-auth traefik

docker stack deploy -c docker/swarmpit.yml --with-registry-auth swarmpit

docker stack deploy -c docker-compose.yml --with-registry-auth ${PROJECT:-app}

```

Test in localhost with auto ip  
`docker swarm init --advertise-addr=$(hostname -I  | grep -o '^\S*')`

