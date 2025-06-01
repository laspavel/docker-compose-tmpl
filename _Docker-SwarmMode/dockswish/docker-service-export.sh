#!/bin/bash
# PURPOSE:
# - Export docker service attributes (some) as json (which may be used to restore the service)

MYTIME=$(date +%y%m%d_%H%M%S)
INSTANCE_DIR="/opt/${INSTANCE_NAME}"
EXPORT_DIR="${INSTANCE_DIR}/var/backups/docker-services/${HOSTNAME}/${MYTIME}/"

echo "Started docker service export to: ${EXPORT_DIR}"

mkdir -p ${EXPORT_DIR}
cd ${EXPORT_DIR}

SERVICES=$(docker service ls -q)

for SERVICE_ID in ${SERVICES}; do
	echo "Exporting ${SERVICE_NAME}"
	SERVICE_NAME=$(docker service inspect --format='{{.Spec.Name}}' ${SERVICE_ID})
	OUTPUT_FILE="inspect-${SERVICE_NAME}.json"
	docker service inspect ${SERVICE_NAME} > ${OUTPUT_FILE}
done

echo "Done."
