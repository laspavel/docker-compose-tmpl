#!/bin/bash

PRJNAME=${PWD##*/}
ENV_FILE=".env"
# MYTAG=$(mytime)
# MYTAG=$(git rev-parse --short HEAD)
MYBRANCH=$(git rev-parse --abbrev-ref HEAD)
MYCOMMID=$(git describe --always)
MYTAG="${MYBRANCH}_${MYCOMMID}"

CONTAINER_NAME="local_${PRJNAME}_${MYBRANCH}"

IMAGE_TAGGED="local_${PRJNAME}:${MYTAG}"
IMAGE_LATEST="local_${PRJNAME}:latest"
IMAGE_PREV01="local_${PRJNAME}:prev01"
IMAGE_PREV02="local_${PRJNAME}:prev02"
IMAGE_PREV03="local_${PRJNAME}:prev03"

docker image tag ${IMAGE_PREV02} ${IMAGE_PREV03}
docker image tag ${IMAGE_PREV01} ${IMAGE_PREV02}
docker image tag ${IMAGE_LATEST} ${IMAGE_PREV01}

echo "Building ${IMAGE_TAGGED} and ${IMAGE_LATEST}"
docker build --tag ${IMAGE_TAGGED} --tag ${IMAGE_LATEST} .

echo "Retagging: ${IMAGE_TAGGED} -> ${IMAGE_LATEST}"
docker image tag ${IMAGE_TAGGED} ${IMAGE_LATEST}

ENV_PARAMS=""
if test -f ${ENV_FILE}; then            # you may use ENV variables in stack.yml creating an ".env" file in same directory
  echo "Will use env file: ${ENV_FILE}"
  cat ${ENV_FILE}
  source "${ENV_FILE}"
  ENV_PARAMS="--env-file=.env"
fi

RUN_CMD='docker run --rm --interactive --tty  '${ENV_PARAMS}' --name '${CONTAINER_NAME}' '${IMAGE_TAGGED}
echo "Running: ${IMAGE_TAGGED} by ${RUN_CMD}"
${RUN_CMD}

# REFS:
# - https://stackoverflow.com/questions/949314/how-to-retrieve-the-hash-for-the-current-commit-in-git
# - https://stackoverflow.com/questions/5188320/how-can-i-get-a-list-of-git-branches-ordered-by-most-recent-commit

exit

REF: https://gist.github.com/jasonrudolph/1810768

for branch in $(git branch -r | grep -v HEAD);do echo -e $(git show --format="%ci %cr" $branch | head -n 1) \\t$branch; done | sort -r
for branch in $(git branch -l | grep -v '*');do echo -e $(git show --format="%ci %cr" $branch | head -n 1) \\t$branch; done | sort -r
git for-each-ref --format='%(committerdate:short),%(authorname),%(refname:short)' --sort=committerdate refs/heads/ | column -t -s ','
git for-each-ref --format='%(committerdate:medium),%(authorname),%(refname:short)' --sort=committerdate refs/heads/ | column -t -s ','
