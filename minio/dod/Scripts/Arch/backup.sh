#!/bin/bash

TARGETDIR="$(pwd)/backup"
DAYD=3
MINIO_ROOT_USER=XXXXXXXXXXXXXXXXXXX
MINIO_ROOT_PASSWORD=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

DATE=$(date +%Y-%m-%d)
DATADIR="$TARGETDIR/$DATE"
CONTAINERDIR="/backup/$DATE"
MINIO_CONTAINER=minio
STATUS='minio_backup_last_status'

let ResultCode=0
mkdir -p "$DATADIR"
docker exec "$MINIO_CONTAINER" sh -c "set -e; mc alias set -q --no-color myminio http://localhost:9000 $MINIO_ROOT_USER $MINIO_ROOT_PASSWORD > /dev/null" 
let ResultCode=ResultCode+$?

BUCKETS=$(docker exec "$MINIO_CONTAINER" sh -c "set -e; mc ls myminio --json" | jq -r '.key')
let ResultCode=ResultCode+$?

# Проверка наличия бакетов
if [ -z "$BUCKETS" ]; then
    let ResultCode=ResultCode+1
else
    # Цикл по всем бакетам
    for BUCKET in $BUCKETS; do
        mkdir -p "$DATADIR/${BUCKET%/}"
        docker exec "$MINIO_CONTAINER" sh -c "set -e; mc mirror --overwrite --remove myminio/$BUCKET $CONTAINERDIR/${BUCKET%/}"
        let ResultCode=ResultCode+$?
        tar -C $DATADIR -zcvf "$DATADIR/${BUCKET%/}.tgz" --remove-files ${BUCKET%/}
        let ResultCode=ResultCode+$?
    done
    rsync -avz data/.minio.sys $DATADIR
    let ResultCode=ResultCode+$?
    tar -C $DATADIR -zcvf "$DATADIR/.minio.sys.tgz" --remove-files .minio.sys
    let ResultCode=ResultCode+$?
    tar -C $(pwd) -zcvf "$DATADIR/docker-compose.tgz" *.yml *.sh
    let ResultCode=ResultCode+$?
fi;

if [ "$ResultCode" -ne "0" ]; then
  echo "1" > $STATUS
  exit 1
else
  echo "0" > $STATUS
  find $TARGETDIR -name '*.tgz' -type f -atime +$DAYD -delete
  find $TARGETDIR -type d -empty -exec rmdir {} \;
  exit 0;
fi;

