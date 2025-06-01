#!/bin/bash

DATETIME=$(date +%Y-%m-%d_%H-%M-%S)
BAKNAME="bak_$DATETIME"
TARGETDIR="/backup"
DATE=$(date +%Y-%m-%d)
DATADIR="$TARGETDIR/$DATE"
MINIO_VOLUME="zdata/minio1"
MOUNTPOINT="/minio"
STATUS='statusfile'
DAYD=3

let ResultCode=0

zfs snapshot "$MINIO_VOLUME@$BAKNAME"
let ResultCode=ResultCode+$?

mkdir -p "$DATADIR"
tar --use-compress-program=lz4 -cvf "$DATADIR/$BAKNAME.tar.lz4" -C "$MOUNTPOINT/.zfs/snapshot/$BAKNAME" .
let ResultCode=ResultCode+$?

zfs destroy "$MINIO_VOLUME@$BAKNAME"
let ResultCode=ResultCode+$?

if [ "$ResultCode" -ne "0" ]; then
  echo "1" > $STATUS
  exit 1
else
  echo "0" > $STATUS
  find $TARGETDIR -name '*.tar.lz4' -type f -atime +$DAYD -delete
  find $TARGETDIR -type d -empty -exec rmdir {} \;
  exit 0;
fi;

