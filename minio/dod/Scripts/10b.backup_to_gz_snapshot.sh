#!/bin/bash


DATETIME=$(date +%Y-%m-%d_%H-%M-%S)
BAKNAME="bak_$DATETIME"
TARGETDIR="/backup"
DATE=$(date +%Y-%m-%d)
DATADIR="$TARGETDIR/$DATE"
MINIO_VOLUME="zdata/minio1"
MOUNTPOINT="/minio"

let ResultCode=0

zfs snapshot $MINIO_VOLUME@$BAKNAME
let ResultCode=ResultCode+$?

mkdir -p "$DATADIR"

set -o pipefail
zfs send $MINIO_VOLUME@$BAKNAME | gzip > $DATADIR/$BAKNAME.gz
let ResultCode=ResultCode+$?
set +o pipefail

zfs destroy $MINIO_VOLUME@$BAKNAME
let ResultCode=ResultCode+$?

if [ "$ResultCode" -ne "0" ]; then
  echo "1" > $STATUS
  exit 1
else
  echo "0" > $STATUS
  find $TARGETDIR -name '*.gz' -type f -atime +$DAYD -delete
  find $TARGETDIR -type d -empty -exec rmdir {} \;
  exit 0;
fi;

