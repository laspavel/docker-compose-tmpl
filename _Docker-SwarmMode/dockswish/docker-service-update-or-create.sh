#!/usr/bin/env bash
# PURPOSE:
# - Create (if not already existing) or update a service with a given docker image URL (with version)
# TODO:
# - 201128_071138: Read envs from files in git repositories of source code
# REFS:
# - https://github.com/moby/moby/issues/34153#issuecomment-316047924 | swarm service image update
# - https://github.com/docker/swarmkit/issues/1085 | using healtchecks is healty for updates

set -e # EXIT ON FIRST ERROR
set -x # ENABLE DEBUG

UPDATE_PARTS=3
MAX_UPDATE_PARALELISM=8
DOCKER_UPDATE_OPTIONS="--with-registry-auth=true"
ENV_EMAIL_ACTIVE="EMAIL_ACTIVE=true"
ENV_SMTP_SENDER_NAME="SMTP_SENDER_NAME=CUSTOM-Alert-${HOSTNAME}"

SERVICE_NAME=$1
IMAGE_URL=$2
IMAGE_URL_NOVERSION="$(echo $IMAGE_URL | cut -d: -f1):" # ':' prevents partial image-name matching

# Prevent partial servicename matching: different branch tags match with other branches service names, so a service may update from another branch image
SERVICE_ID_LIST=$(docker service ls --filter name=${SERVICE_NAME} --format "{{.ID}} {{.Name}}" | grep ${SERVICE_NAME}'$' | cut -d' ' -f1)

if [ -z "${SERVICE_ID_LIST}" ]
then
  echo "!!! No matching services for service name: ${SERVICE_NAME} using image names as a reference to find service ids..."
  # Lets docker image name to match as starting in image urls, so that old style service names are kept, there may be more than one service using an image, with differents envs etc.
  SERVICE_ID_LIST=$(docker service ls --format "{{.ID}} {{.Image}}" | grep " ${IMAGE_URL_NOVERSION}" | cut -f1 -d' ') # ALT: # SERVICE_ID_LIST=$(docker service ls | tr -s ' ' | cut -f1,2,5 -d' '| grep " ${IMAGE_URL_NOVERSION}" | cut -f1 -d' ') 
fi

echo "SERVICE_IDS=${SERVICE_ID_LIST}"

# If image url contains "test" than it must be a test image, so set TEST to true
if [[ "${IMAGE_URL}" =~ "test" ]]; then
  TEST="true"
else
  TEST="false"
fi

# If hostname contains test than it must be a test server, so set SWARM_MANAGER accordingly
if [[ "${HOSTNAME}" == *"test"* ]]; then
  TEST="true"
  SWARM_MANAGER="infra.test.CUSTOM.app"
else
  SWARM_MANAGER="infra.prod.CUSTOM.app"
fi

if $TEST
then
  # On test systems just pause upon update failure, so that somebody may inspect and fix the problem with the update
  DOCKER_CONSTRAINS='--constraint node.hostname==testa'
  DOCKER_UPDATE_OPTIONS="$DOCKER_UPDATE_OPTIONS --update-failure-action pause"
  ENV_DEBUG='DEBUG=true'
  ENV_SMTP_RECEIVER_MAIL='SMTP_RECEIVER_MAIL=debug@CUSTOM.app'
else
  # On production systems try to rollback upon update failure 
  DOCKER_CONSTRAINS=''
  DOCKER_UPDATE_OPTIONS="$DOCKER_UPDATE_OPTIONS --update-failure-action rollback"
  ENV_DEBUG='DEBUG=false'
  ENV_SMTP_RECEIVER_MAIL='SMTP_RECEIVER_MAIL=sistem@CUSTOM.app'
fi

if [ -z "${SERVICE_ID_LIST}" ] # Does any service with this already exist? If not create one.
then

  ############################
  ### CREATE A NEW SERVICE ###
  ############################
  CREATE_OR_UPDATE="create"
  ENV_PARAM="--env"

  case ${HOSTNAME} in
    "CUSTOMlocal"|"b1"|"b2"|"b3"|"testa")
      echo "### Running on ${HOSTNAME}. Service ${SERVICE_NAME} will be created automatically from image: ${IMAGE_URL}"
      # Set important common envs for test or prod; See dev.CUSTOM.app/bots/*/CUSTOM/CUSTOM/settings/common.py for default values
      # if you are creating a new service don't start any replicas since it may have side effects, admin should start the replicas for the service
      MYCMD="docker service ${CREATE_OR_UPDATE}"
        MYCMD="${MYCMD} --replicas=0"
        MYCMD="${MYCMD} ${DOCKER_CONSTRAINS}"
        MYCMD="${MYCMD} ${ENV_PARAM} ${ENV_DEBUG}"
        MYCMD="${MYCMD} ${ENV_PARAM} ${ENV_EMAIL_ACTIVE}"
        MYCMD="${MYCMD} ${ENV_PARAM} ${ENV_SMTP_RECEIVER_MAIL}"
        MYCMD="${MYCMD} ${ENV_PARAM} ${ENV_SMTP_SENDER_NAME}"
        MYCMD="${MYCMD} ${ENV_PARAM} ELASTICSEARCH_HOST=${SWARM_MANAGER}"
        MYCMD="${MYCMD} ${ENV_PARAM} RABBITMQ_DEFAULT_HOST=${SWARM_MANAGER}"
        MYCMD="${MYCMD} ${ENV_PARAM} MONGODB_HOST=${SWARM_MANAGER}"
        MYCMD="${MYCMD} --name ${SERVICE_NAME}"
        MYCMD="${MYCMD} ${IMAGE_URL}"      
      # --env-file DockerEnvs.lst # [TODO-201128_071138]
      echo "### ${CREATE_OR_UPDATE} service by running CMD: '$MYCMD'"
      $MYCMD
    ;;

    "b4|b5")       # tracker bots
      echo "### Running on ${HOSTNAME}. TRACKER service ${SERVICE_NAME} WILL BE CREATED automatically from image: ${IMAGE_URL}"
      # Set important common envs for tracker; don't start any replicas since it may have side effects
      ELASTIC_TARGET="infra.b5.CUSTOM.app"        # seperate elastic for tracker bots
      MYCMD="docker service ${CREATE_OR_UPDATE}"
        MYCMD="${MYCMD} --replicas=0"
        MYCMD="${MYCMD} ${DOCKER_CONSTRAINS}"
        MYCMD="${MYCMD} ${ENV_PARAM} ${ENV_DEBUG}"
        MYCMD="${MYCMD} ${ENV_PARAM} ${ENV_EMAIL_ACTIVE}"
        MYCMD="${MYCMD} ${ENV_PARAM} ${ENV_SMTP_RECEIVER_MAIL}"
        MYCMD="${MYCMD} ${ENV_PARAM} ${ENV_SMTP_SENDER_NAME}"
        MYCMD="${MYCMD} ${ENV_PARAM} ELASTICSEARCH_HOST=${ELASTIC_TARGET}"
        MYCMD="${MYCMD} ${ENV_PARAM} RABBITMQ_DEFAULT_HOST=${SWARM_MANAGER}"
        MYCMD="${MYCMD} ${ENV_PARAM} MONGODB_HOST=${SWARM_MANAGER}"
        MYCMD="${MYCMD} --name ${SERVICE_NAME}"
        MYCMD="${MYCMD} ${IMAGE_URL}"      
      echo "### ${CREATE_OR_UPDATE} service by running CMD: '$MYCMD'"
      $MYCMD
    ;;

    *)
      echo "### Running on ${HOSTNAME}. Service WILL NOT BE CREATED automatically!!!"
    ;;
  esac

else

  ##################################
  ### UPDATE EXISTING SERVICE(S) ###
  ##################################
  CREATE_OR_UPDATE="update"
  ENV_PARAM="--env-add"

  for SERVICE_ID in $SERVICE_ID_LIST # there may be more than one service using an image, with differents envs etc.
  do
    SERVICE_NAME=$(docker service inspect --format '{{.Spec.Name}}' ${SERVICE_ID})
    MY_REPLICAS=$(docker service inspect --format='{{.Spec.Mode.Replicated.Replicas}}' ${SERVICE_NAME})

    if [ "${MY_REPLICAS}" -gt "0" ]; then
      echo "### There are ${MY_REPLICAS} replicas on ${HOSTNAME} for service ${SERVICE_NAME} (ID: ${SERVICE_ID}). Image will be pre-pulled..."
      echo "### Pulling docker image: ${IMAGE_URL}"
      docker pull ${IMAGE_URL}
    else
      echo "### No replicas on ${HOSTNAME}. Image will not be pre-pulled..."
    fi

    UPDATE_PARALELISM=$(( ( ($UPDATE_PARTS - 1 ) + $MY_REPLICAS) / $UPDATE_PARTS )) # update 1/3 of the replicas in each phase
    if [ "$UPDATE_PARALELISM" -lt "1" ]; then
      UPDATE_PARALELISM=1
    fi
    if [ "$UPDATE_PARALELISM" -gt "$MAX_UPDATE_PARALELISM" ]; then
      UPDATE_PARALELISM=$MAX_UPDATE_PARALELISM
    fi
    echo "### Updating service: ${SERVICE_NAME} (ID: ${SERVICE_ID}) Replicas: ${MY_REPLICAS} ) from: ${IMAGE_URL} in ${UPDATE_PARTS} parts with update-parallelism=${UPDATE_PARALELISM} "
    DOCKER_UPDATE_OPTIONS="$DOCKER_UPDATE_OPTIONS --update-delay=2s --update-parallelism=$UPDATE_PARALELISM"
    MYCMD="docker service ${CREATE_OR_UPDATE} ${SERVICE_NAME} --image=${IMAGE_URL} ${DOCKER_UPDATE_OPTIONS}" # > /dev/null 2>&1
    echo "### ${CREATE_OR_UPDATE} service by running CMD: '$MYCMD'"
    $MYCMD
    # /root/bin/log-and-run.sh "docker service update ${SERVICE_NAME} --image=${IMAGE_URL} $DOCKER_UPDATE_OPTIONS" # !!! Gives errors: /root/bin/log-and-run.sh: line 27: [: too many arguments; /root/bin/log-and-run.sh: line 34: [: too many arguments
  done

fi

# UPDATESTATUS=$(docker service inspect --format='{{.UpdateStatus.State}}' ${SERVICE_NAME}) # when replicas=0 this creates jenkins error messages
# echo "Service update status: $UPDATESTATUS"
docker service ps --no-trunc ${SERVICE_NAME} # !!! bunu açsak hata takibi açısından daha iyi olabilir

exit

# SAMPLE RUNNER-1
${SSH_CMD} "/root/bin/docker-service-update-or-create.sh ${SERVICE_NAME} ${IMAGE_URL}"
# SAMPLE RUNNER-2
/root/bin/docker-service-update-or-create.sh test-bots-twitter-detail-updater hub.CUSTOM.app/CUSTOM/bots/test/test-twitter-detail-updater:3.0.19
