#!/bin/bash

TODAY=`date +%Y-%m-%d_%H-%M-%S`
BACKUPDIR="/BACKUP"
export VAULT_ADDR='https://localhost:8200'

mkdir -p $BACKUPDIR
/bin/vault operator raft snapshot save $BACKUPDIR/vault-$TODAY.snap
