#!/bin/bash
# PURPOSE:
# - Create (if not already existing) or update a services ENV's

set -e # EXIT ON FIRST ERROR
set -x # ENABLE DEBUG

SERVICE_NAME=$1

SERVICE_ID=$(docker service ls --filter name=${SERVICE_NAME} --quiet) # there may be problems with partial servicename matching
#SERVICE_ID=$(docker service ls | grep ${SERVICE_NAME} | cut -f1 -d' ') # lets docker image name to match in image urls, so that old style service names are kept
echo "Found SERVICE_ID=${SERVICE_ID}"

# If hostname contains test than it must be a test server, so set HOST_IP accordingly
if [[ "${HOSTNAME}" == *"test"* ]]; then
  HOST_IP="infra.test.CUSTOM.app"
else
  HOST_IP="infra.prod.CUSTOM.app"
fi

docker service update \
  --env-add "ELASTICSEARCH_HOST=${HOST_IP}" \
  --env-add "RABBITMQ_DEFAULT_HOST=${HOST_IP}" \
  --env-add "MONGODB_HOST=${HOST_IP}" \
${SERVICE_NAME}   # Set envs for test or prod