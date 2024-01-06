#!/bin/bash

# Stop the processes that are connected to the database
docker exec -it $1 gitlab-ctl stop puma
docker exec -it $1 gitlab-ctl stop sidekiq

# Verify that the processes are all down before continuing
docker exec -it $1 gitlab-ctl status

# Run the restore
docker exec -it $1 gitlab-backup restore BACKUP=$2

# Restart the GitLab container
docker restart $1

# Check GitLab
docker exec -it $1 gitlab-rake gitlab:check SANITIZE=true
docker exec -it $1 gitlab-rake gitlab:doctor:secrets
docker exec -it $1 gitlab-rake gitlab:artifacts:check
docker exec -it $1 gitlab-rake gitlab:lfs:check
docker exec -it $1 gitlab-rake gitlab:uploads:check


