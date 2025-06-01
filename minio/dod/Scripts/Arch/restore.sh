#!/bin/bash

BACKUP_DIR="$(pwd)/backup"
DATE_DIR=$1
MINIO_CONTAINER=minio
MINIO_ROOT_USER=XXXXXXXXXXXXXXXXXXX
MINIO_ROOT_PASSWORD=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

if [ -z "$DATE_DIR" ]; then
  echo "Usage: $0 <backup_date>"
  echo "Example: $0 2023-12-31"
  exit 1
fi

RESTORE_DIR="$BACKUP_DIR/$DATE_DIR"

# Проверка наличия папки с бэкапом
if [ ! -d "$RESTORE_DIR" ]; then
  echo "Backup directory $RESTORE_DIR not found!"
  exit 1
fi

let ResultCode=0

if [ -f "$RESTORE_DIR/.minio.sys.tgz" ]; then
  echo "Restoring MinIO metadata..."
  tar -xvzf "$RESTORE_DIR/.minio.sys.tgz" -C "$RESTORE_DIR"
  let ResultCode=ResultCode+$?
  docker cp "$RESTORE_DIR/.minio.sys" "$MINIO_CONTAINER:/export/.minio.sys"
  let ResultCode=ResultCode+$?
fi

# if [ -f "$RESTORE_DIR/docker-compose.tgz" ]; then
#   echo "Restoring docker-compose files..."
#   tar -xvzf "$RESTORE_DIR/docker-compose.tgz" -C "$(pwd)"
#   let ResultCode=ResultCode+$?
#   continue
# fi


# Распаковать архивы бакетов и восстановить их
for BUCKET_ARCHIVE in "$RESTORE_DIR"/*.tgz; do
  BUCKET_NAME=$(basename "$BUCKET_ARCHIVE" .tgz)
  if [[ "$BUCKET_NAME" == ".minio.sys" || "$BUCKET_NAME" == "docker-compose" ]]; then
    continue
  fi

  echo "Restoring bucket: $BUCKET_NAME"

  # Распаковать архив бакета
  tar -xvzf "$BUCKET_ARCHIVE" -C "$RESTORE_DIR"
  let ResultCode=ResultCode+$?

  # Загрузить данные в MinIO
  docker exec "$MINIO_CONTAINER" sh -c "set -e; mc alias set -q --no-color myminio http://localhost:9000 $MINIO_ROOT_USER $MINIO_ROOT_PASSWORD > /dev/null && mc mirror --overwrite --remove $RESTORE_DIR/$BUCKET_NAME myminio/$BUCKET_NAME"
  let ResultCode=ResultCode+$?
done

if [ "$ResultCode" -ne "0" ]; then
  echo "Error occurred during restore process."
  exit 1
else
  echo "Restore process completed successfully."
  exit 0
fi
