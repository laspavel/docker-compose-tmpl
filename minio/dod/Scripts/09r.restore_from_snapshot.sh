#!/bin/bash

# Проверка количества параметров
if [[ $# -ne 3 ]]; then
  echo "Usage: $0 <backup_file> <mountpoint> >volume>"
  exit 1
fi

VOLUME=$3
MOUNTPOINT=$2
RESTBACKUP=$1
#VOLUME="zdata/minio1"
#MOUNTPOINT="/minio"

zfs set mountpoint=none $VOLUME
if [ $? -ne 0 ]; then
  echo "Error: Failed to umount $VOLUME."
  exit 1
fi

zfs list $VOLUME && zfs destroy -r $VOLUME
if [ $? -ne 0 ]; then
  echo "Error: Failed to destroy $VOLUME."
  exit 1
fi

zfs create $VOLUME
if [ $? -ne 0 ]; then
  echo "Error: Failed to create $VOLUME."
  exit 1
fi

zfs receive -F $VOLUME < $RESTBACKUP
if [ $? -ne 0 ]; then
  echo "Error: Failed to restore $VOLUME."
  exit 1
fi

zfs set mountpoint=$MOUNTPOINT $VOLUME
if [ $? -ne 0 ]; then
  echo "Error: Failed to mount $VOLUME."
  exit 1
fi

let ResultCode=0

zfs set snapdir=visible $VOLUME
let ResultCode=ResultCode+$?

# MinIO работает с объектами размером от 128 KB и выше. 
zfs set recordsize=128K $VOLUME
let ResultCode=ResultCode+$?

# Метод сжатия
zfs set compression=lz4 $VOLUME
let ResultCode=ResultCode+$?

# Выключение обновления времени доступа (atime) предотвращает ненужные операциip aи записи при чтении файлов.
zfs set atime=off $VOLUME
let ResultCode=ResultCode+$?

# Атрибуты файла (xattr) хранятся в "System Attributes". Это ускоряет операции, связанные с метаданными.
zfs set xattr=sa $VOLUME
let ResultCode=ResultCode+$?

# В большинстве случаев для S3-хранилища дедупликация не приносит значительных преимуществ.
zfs set dedup=off $VOLUME
let ResultCode=ResultCode+$?

if [ "$ResultCode" -ne "0" ]; then
  echo "Error: Failed to create $VOLUME."
  exit 1
fi

echo "Finished restore volume: $VOLUME "

zfs list zdata/minio1
echo "All OK !!!"