#!/bin/sh

SECONDSTOABORT=5
SECONDSTOWAIT=10
SRVNAME=${1}
REPLICAS=$(docker service inspect --format='{{.Spec.Mode.Replicated.Replicas}}' ${SRVNAME})

docker service ps ${SRVNAME}

echo "Current number of replicas for ${SRVNAME}: ${REPLICAS}"

echo "I will try to restart all replicas of ${SRVNAME} in ${SECONDSTOABORT} seconds... (You can abort with Ctrl-C)"
sleep ${SECONDSTOABORT}

echo "Stopping ..."
docker service scale ${SRVNAME}=0

echo "Waiting ${SECONDSTOWAIT} seconds..."
sleep ${SECONDSTOWAIT}

echo "Starting ${REPLICAS} replicas for ${SRVNAME} ..."
docker service scale ${SRVNAME}=${REPLICAS}

docker service ps ${SRVNAME}

echo "Done."
exit