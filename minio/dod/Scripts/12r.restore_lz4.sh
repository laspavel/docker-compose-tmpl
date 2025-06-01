#!/bin/bash

# Проверка количества параметров
if [[ $# -ne 2 ]]; then
  echo "Usage: $0 <lz4_archive> <extract_path>"
  exit 1
fi 

BAKNAME=$1
MOUNTPOINT=$2

tar --use-compress-program=lz4 -xvf "$BAKNAME" -C "$MOUNTPOINT"

