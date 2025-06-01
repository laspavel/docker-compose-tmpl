#!/bin/bash

DISK="/dev/sdb"
POOLNAME="zdata"
VOLUME="zdata/minio1"
MOUNTPOINT="/minio"

zpool create $POOLNAME $DISK -f
zfs create $VOLUME

zfs set mountpoint=$MOUNTPOINT $VOLUME
zfs set snapdir=visible $VOLUME

# MinIO работает с объектами размером от 128 KB и выше. 
zfs set recordsize=128K $VOLUME

# Метод сжатия
zfs set compression=lz4 $VOLUME

# Выключение обновления времени доступа (atime) предотвращает ненужные операциip aи записи при чтении файлов.
zfs set atime=off $VOLUME

# Атрибуты файла (xattr) хранятся в "System Attributes". Это ускоряет операции, связанные с метаданными.
zfs set xattr=sa $VOLUME

# В большинстве случаев для S3-хранилища дедупликация не приносит значительных преимуществ.
zfs set dedup=off $VOLUME

zpool status
df -h