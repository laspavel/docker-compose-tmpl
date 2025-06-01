#!/bin/bash

BUCKET_NAME="$1"
EXPORT_PATH1="$2"

MINIO_ROOT_USER=XXXXXXXXXXXXXXXXXXX
MINIO_ROOT_PASSWORD=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

DATE=$(date +%Y-%m-%d)
EXPORT_PATH="$EXPORT_PATH1/$DATE/$BUCKET_NAME"
MINIO_CONTAINER=minio

docker exec "$MINIO_CONTAINER" sh -c "set -e; mc alias set -q --no-color myminio http://localhost:9000 $MINIO_ROOT_USER $MINIO_ROOT_PASSWORD > /dev/null"

# Проверка количества параметров
if [[ $# -ne 2 ]]; then
  echo "Usage: $0 <bucket_name> <export_path>"
  exit 1
fi

# Создание папки экспорта
mkdir -p "$EXPORT_PATH"
if [[ $? -ne 0 ]]; then
  echo "Error: Failed to create export directory $EXPORT_PATH"
  exit 1
fi
echo "Export directory $EXPORT_PATH created successfully."

# Экспорт бакета через mc mirror
docker exec "$MINIO_CONTAINER" sh -c "set -e; mc mirror \"myminio/$BUCKET_NAME\" \"$EXPORT_PATH\""

if [[ $? -ne 0 ]]; then
  echo "Error: Failed to export bucket $BUCKET_NAME to $EXPORT_PATH"
  exit 1
fi
echo "Bucket $BUCKET_NAME exported successfully to $EXPORT_PATH."
