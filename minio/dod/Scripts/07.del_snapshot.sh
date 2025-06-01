#!/bin/bash

# Проверка входного параметра
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <snapshot_name>"
  exit 1
fi

SNAPSHOT=$1

zfs destroy zdata/minio1@$SNAPSHOT
if [ $? -ne 0 ]; then
  echo "Error: Failed to delete snapshot $SNAPSHOT."
  exit 1
fi

# Вывод информации
echo "Snapshot $SNAPSHOT has been successfully deleted."
