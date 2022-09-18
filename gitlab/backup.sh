#!/bin/bash

docker exec git-erp_web_1 /usr/bin/gitlab-rake gitlab:backup:create
RES=$?
if [[ $RES -eq 0 ]];then
   find /docker/gitlab/data/opt/backups/* -mtime +10 -exec rm -rf {} \;
   find /mnt/BACKUP/gitlab/*.tar -mtime +10 -exec rm -rf {} \;
   find /mnt/BACKUP/gitlab/*.tgz -mtime +10 -exec rm -rf {} \;
   /usr/bin/cp -f /docker/gitlab/data/opt/backups/* /mnt/BACKUP/gitlab
fi

