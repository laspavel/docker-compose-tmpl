#!/bin/bash

DATE=$(date +%Y-%m-%d_%H-%M-%S)
zfs snapshot zdata/minio1@$DATE
