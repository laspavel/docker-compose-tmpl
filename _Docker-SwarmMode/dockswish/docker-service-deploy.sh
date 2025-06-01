#!/bin/bash
# PURPOSE:
# - Meant to be called from Jenkins to build and deploy docker images to docker swarms
# - Detect if this is a prod/test build from GIT_BRANCH if it contains "prod*/test*" patterns
# - Create a service name automatically using Jenks ENVs like GIT_URL, BUILD_NUMBER, GIT_BRANCH etc...
# - Build the docker image, tag and push appropriately, then deploy the created image to appropriate servers or locally
# - Tag test builds with short git commit ids
# TODO:
# - Convert to Python
# - Fix versioning for prod
# - log actions properly
# - Cooperate with projects git repositry (use files like ''.env' from git etc.)
# - ??? Handle services as stacks like: app_bots, app_backend, app_frontend
# USAGE:
# - CLI CALL:
#   - docker-service-deploy.sh  https://dev.MYAPP.app/prjtype/project-name origin/test 26
# - JENKINS JOB:
#   /path-to/file/docker-service-deploy.sh
# REFS:
# - https://docs.docker.com/engine/reference/commandline/push/

set -e # EXIT ON FIRST ERROR

# REF: https://gist.github.com/Ksisu/385497d9b75eb58b6987ef7831070c50
function zulipSend {
  echo "dummy_zulipsend"
  curl  -s -X POST ${ZULIP_MESSAGES_API} \
        ${SEND_TO_STREAM_OR_PRIVATE} \
        -u $ZULIP_BOT_EMAIL_ADDRESS:$ZULIP_BOT_API_KEY \
        --data-urlencode "subject=${GIT_NAME} / ${MY_GIT_BRANCH}" \
        --data-urlencode "content=$1"
}

# Absolute path to this script, e.g. /home/user/bin/foo.sh
ME_REL=${0}
ME_ABS=$(readlink -f "${ME_REL}")
MYFILENAME=$(basename "${ME_ABS}")
MYFULLPATH=$(dirname "${ME_ABS}")
MYDIRNAME=$(basename "${MYFULLPATH}")

echo "
###########################################
### STARTING DOCKER SERVICE AUTO DEPLOY ###
###########################################
MYFILENAME : ${MYFILENAME}
MYDIRNAME  : ${MYDIRNAME}
MYFULLPATH : ${MYFULLPATH}
ME_ABS     : ${ME_ABS}
###########################################
"

ZULIP_MESSAGES_API="https://meet.MYDOMAIN.app/api/v1/messages"
ZULIP_BOT_EMAIL_ADDRESS="devops-bot@meet.MYDOMAIN.app"
ZULIP_BOT_API_KEY="c8bF3oFpLMW5QAtvxSOXn9gsL6j27VJW"
ZULIP_STREAM="DevOps"
ZULIP_DEBUGGER_EMAIL="debug@MYDOMAIN.app"
HUB_URL="hub.MYDOMAIN.app/MYAPP"; VERSION="3.0"
SERVICE_NAME_INIT="cosmos-"
SERVICE_NAME_TEST_INIT="test_"
SEND_TO_STREAM_OR_PRIVATE="--data-urlencode "type=stream" --data-urlencode to=${ZULIP_STREAM}"      # Normal usage for sending messages to a stream

FLAG_DEBUG=true
# FLAG_DEBUG=false
FLAG_SINGLESERVER=true
# FLAG_SINGLESERVER=false
TEST_SERVERS="ta"
PROD_SERVERS="b1 b2 b3"

SETTINGS_FILE="${ME_ABS}.settings"
if test -f ${SETTINGS_FILE}; then            # you may ovverride the above settings by creating this .settings file in $CWD
    source "${SETTINGS_FILE}"               
fi

if ${FLAG_DEBUG}; then
echo "
###########################################
###  DUMPING ALL ENVS & ENABLING DEBUG  ###
###########################################
$(env | sort)
###########################################
"
# export | sort
  set -x # ENABLE DEBUG
  SEND_TO_STREAM_OR_PRIVATE="--data-urlencode type=private --data-urlencode to=${ZULIP_DEBUGGER_EMAIL}"   # For testing & debugging - use private messages
fi

if [[ "$#" -eq 0 ]]; then
  echo "Gettting all params from ENV values."
  MY_GIT_URL=${GIT_URL}
  MY_GIT_BRANCH=$(basename "${GIT_BRANCH}")
  MY_BUILD_NUMBER=${BUILD_NUMBER}
  echo "BUILD_NUMBER=$MY_BUILD_NUMBER, GIT_URL=$MY_GIT_URL, GIT_BRANCH=$MY_GIT_BRANCH"
elif [[ "$#" -eq 3 ]]; then     # Gerekli bilgilerin Jenkins'in set ettiği ENV'ler yerine parametre ile alma durumu
  MY_GIT_URL=$1
  MY_GIT_BRANCH=$(basename "$2")
  MY_BUILD_NUMBER=$3
else
  echo "
  ERROR: Wrong number of arguments. Only 0 or 3 arguments are valid.
  Usage examples:
  $MYFILENAME # must be runned in a state that Jenkins ENV's are set-up
  $MYFILENAME GIT_URL GIT_BRANCH BUILD_NUMBER
  "
  exit
fi

PRJ_TYPE_URL=$(dirname "${MY_GIT_URL}")
PRJ_TYPE=$(basename "${PRJ_TYPE_URL}")
GIT_NAME=$(basename "${MY_GIT_URL}")
PRJ_NAME=$(echo "${GIT_NAME}" | sed -e 's|.git||g')
FLAG_BUILD_TEST=false
FLAG_BUILD_PROD=false

case ${MY_GIT_BRANCH} in
    "draft*"|"master*")
        echo "INFO: This is a draft branch. There will be no build processed. Exitting..."
        exit
    ;;
    "test*")
        FLAG_BUILD_TEST=true
        echo "### TEST BUILD ###"
    ;;
    "prod*")
        FLAG_BUILD_PROD=true
        echo "### PRODUCTION BUILD ###"
    ;;
esac

case ${MY_GIT_BRANCH} in
    "test"|"prod")            # for the main branches (dont add the extra branch tag)
        ADD_TAG=""
    ;;
    "*")
        ADD_TAG="_${MY_GIT_BRANCH}"
        PRJ_NAME="${PRJ_NAME}${ADD_TAG}"
        echo "### Branch tag added to PRJ_NAME: ${PRJ_NAME} ###"
    ;;
esac

PRJ_FULLNAME="${PRJ_TYPE}_${PRJ_NAME}"

if ${FLAG_BUILD_TEST}; then
    VERSION="${MY_GIT_BRANCH}"
    MY_BUILD_NUMBER=$(git describe --always)   # use short commit id as build_number # sample: 'hub.MYDOMAIN.app/MYAPP/backend/test/test-api:test.v2.5.5-1019-g12f988f'
    TARGET_SERVERS=${TEST_SERVERS}
    SERVICE_NAME="${SERVICE_NAME_TEST_INIT}${SERVICE_NAME_INIT}${PRJ_FULLNAME}" # SAMPLE: test_MYAPP-backend_api
else
    TARGET_SERVERS=${PROD_SERVERS}
    SERVICE_NAME="${SERVICE_NAME_INIT}${PRJ_FULLNAME}" # SAMPLE: MYAPP-backend_api
fi

if ${FLAG_SINGLESERVER}; then
    TARGET_SERVERS=$(hostname)
fi

CUSTOM_LOGIC_FILE="${ME_ABS}.custom_logic"
if test -f ${CUSTOM_LOGIC_FILE}; then            # You may ovverride the above variables by creating this ".custom_logic" file in $CWD
    source "${CUSTOM_LOGIC_FILE}"               
fi

BUILD_CONSOLE_URL="${BUILD_URL}consoleFull"
IMAGE_ID_VER=${SERVICE_NAME}:${VERSION}.${MY_BUILD_NUMBER}
IMAGE_ID_LTS=${SERVICE_NAME}:latest

echo "================= STARTING ===================
MY_GIT_URL           : ${MY_GIT_URL}
MY_GIT_BRANCH        : ${MY_GIT_BRANCH}
MY_BUILD_NUMBER      : ${MY_BUILD_NUMBER}
FLAG_BUILD_TEST      : ${FLAG_BUILD_TEST}
FLAG_SINGLESERVER    : ${FLAG_SINGLESERVER}
FLAG_BUILD_PROD      : ${FLAG_BUILD_PROD}
PRJ_TYPE             : ${PRJ_TYPE}
PRJ_NAME             : ${PRJ_NAME}
SERVICE_NAME         : ${SERVICE_NAME}
BUILD_URL            : ${BUILD_URL}
"

MESSAGE=':white_flag: Building ['${PRJ_NAME}']('${MY_GIT_URL}'):['${MY_GIT_BRANCH}']('${MY_GIT_URL}'/-/tree/'${MY_GIT_BRANCH}') => [ '${TARGET_SERVERS}' ] (See [log]('${BUILD_CONSOLE_URL}'))'
zulipSend "${MESSAGE}"

DOCKERBUILD_OPTIONS=""          # DOCKERBUILD_OPTIONS="--no-cache"     # !!! Use only when needed, may fix some docker-build problems, bu slows down a lot. 

if BUILD_RESULT=$(docker build ${DOCKERBUILD_OPTIONS} --tag ${IMAGE_ID_VER} .); then
  zulipSend ":working_on_it: Build succesfull: ${IMAGE_URL}"
else
  BUILD_RESULT_TAIL=$(echo ${BUILD_RESULT} | tail -n1)
  MESSAGE=':exclamation: Build failed. => See erros in [jenkins log]('${BUILD_CONSOLE_URL}') <=
```
'${BUILD_RESULT_TAIL}'
```'
  zulipSend "${MESSAGE}"
  exit 101
fi
docker image tag ${IMAGE_ID_VER} ${IMAGE_ID_LTS}

if ${FLAG_SINGLESERVER}; then
  echo "*** STARING DEPLOYEMENT FOR SINGLE SERVER MODE ***"
  IMAGE_URL="local_${IMAGE_ID_VER}"
  docker image tag ${IMAGE_ID_VER} ${IMAGE_URL}
  IMAGE_URL_LATEST=${HUB_URL}/${PRJ_TYPE}/${PRJ_NAME}:latest
  RUNCMD="/root/bin/docker-service-create-update.sh --local ${SERVICE_NAME} ${IMAGE_URL}"
else
  echo "*** STARING DEPLOYEMENT FOR MULTI SERVER MODE ***"
  echo ">>> TARGET_SERVERS => ${TARGET_SERVERS}" 
  IMAGE_URL=${HUB_URL}/${PRJ_TYPE}/${IMAGE_ID_VER}
  IMAGE_URL_LATEST=${HUB_URL}/${PRJ_TYPE}/${PRJ_NAME}:latest
  echo ">>> IMAGE_URL => ${IMAGE_URL}"
  # docker tag ${IMAGE_ID_VER} ${IMAGE_ID_LTS} # ${IMAGE_URL}
  # docker tag ${IMAGE_ID_VER} ${IMAGE_ID_LTS} # ${IMAGE_URL_LATEST}
  docker image push ${IMAGE_URL}
  docker image push ${IMAGE_URL_LATEST}
  zulipSend ":check: Image published as: ${IMAGE_URL}"
  # use mssh (multi ssh script) to update on all docker-swarm servers
  RUNCMD="/root/bin/mssh" "${TARGET_SERVERS}" "/root/bin/docker-service-create-update.sh ${SERVICE_NAME} ${IMAGE_URL}"
fi
DEPLOY_RESULT=$( $RUNCMD )
DEPLOY_EXITCODE=$?

if [ $DEPLOY_EXITCODE -ne 0 ]; then
  echo "!!! ERROR !!!"
  DEPLOY_RESULT_TAIL=$(echo ${DEPLOY_RESULT} | tail -n1)
  MESSAGE=':no_entry: Deploy failed:
```
'${DEPLOY_RESULT_TAIL}'
```'
  zulipSend "${MESSAGE}"
  exit $DEPLOY_EXITCODE
else
  zulipSend ":check_mark: Service deployed: ${SERVICE_NAME}  => [ ${TARGET_SERVERS} ]"
fi

exit