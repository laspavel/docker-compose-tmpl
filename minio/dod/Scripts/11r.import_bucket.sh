#!/bin/bash

BUCKET_NAME="$1"
IMPORT_PATH="$2"

MINIO_ROOT_USER=XXXXXXXXXXXXXXXXXXX
MINIO_ROOT_PASSWORD=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
MINIO_CONTAINER=minio

# Проверка количества параметров
if [[ $# -ne 2 ]]; then
  echo "Usage: $0 <bucket_name> <import_path>"
  exit 1
fi

# Проверка существования бакета, создание если его нет
docker exec "$MINIO_CONTAINER" sh -c "set -e; mc alias set -q --no-color myminio http://localhost:9000 $MINIO_ROOT_USER $MINIO_ROOT_PASSWORD > /dev/null"
if [[ $? -ne 0 ]]; then
  echo "Error: Failed to set mc alias"
  exit 1
fi

docker exec "$MINIO_CONTAINER" sh -c "mc ls \"myminio/$BUCKET_NAME\" >/dev/null 2>&1"
if [[ $? -ne 0 ]]; then
  docker exec "$MINIO_CONTAINER" sh -c "mc mb \"myminio/$BUCKET_NAME\""
  if [[ $? -ne 0 ]]; then
    echo "Error: Failed to create bucket $BUCKET_NAME"
    exit 1
  fi
  echo "Bucket $BUCKET_NAME created successfully."
else
  echo "Bucket $BUCKET_NAME already exists."
fi

# Импорт данных в бакет через mc mirror
docker exec "$MINIO_CONTAINER" sh -c "mc mirror --quiet --no-color \"$IMPORT_PATH\" \"myminio/$BUCKET_NAME\""
if [[ $? -ne 0 ]]; then
  echo "Error: Failed to import data from $IMPORT_PATH to bucket $BUCKET_NAME"
  exit 1
fi
echo "Data imported successfully from $IMPORT_PATH to bucket $BUCKET_NAME."
