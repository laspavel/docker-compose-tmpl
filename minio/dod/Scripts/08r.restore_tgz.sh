#!/bin/bash

# Проверка количества параметров
if [[ $# -ne 2 ]]; then
  echo "Usage: $0 <tgz_archive> <extract_path>"
  exit 1
fi

BAKNAME=$1
MOUNTPOINT=$2

tar -zxvf "$BAKNAME" -C "$MOUNTPOINT"

