#!/bin/bash

# Путь к папке с бэкапом
BACKUP_DIR="/backup"

# Название контейнера с MinIO
MINIO_CONTAINER="minio_container_name"

# Убедиться, что папка бэкапа существует
if [ ! -d "$BACKUP_DIR" ]; then
    echo "Backup directory $BACKUP_DIR does not exist!"
    exit 1
fi

# Найти все подпапки в папке бэкапа
for BUCKET_DIR in "$BACKUP_DIR"/*; do
    if [ -d "$BUCKET_DIR" ]; then
        # Извлечь имя бакета из имени папки
        BUCKET=$(basename "$BUCKET_DIR")
        echo "Restoring bucket: $BUCKET"

        # Создать бакет, если он не существует
        docker exec "$MINIO_CONTAINER" mc mb "myminio/$BUCKET"

        # Рекурсивно копировать содержимое папки обратно в бакет
        docker exec "$MINIO_CONTAINER" mc mirror --overwrite "/backup/$BUCKET" "myminio/$BUCKET"
        if [ $? -eq 0 ]; then
            echo "Restoration of $BUCKET completed successfully."
        else
            echo "Error restoring $BUCKET."
        fi
    fi
done
