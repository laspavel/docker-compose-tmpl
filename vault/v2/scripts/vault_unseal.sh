#!/bin/bash

export VAULT_ADDR='https://localhost:8200'
key1="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxE"
key2="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx1"
key3="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"


vault_status=$(/usr/bin/vault status -format "json" | jq --raw-output '.sealed')
if [[ $vault_status == 'true' ]]; then
    echo $vault_status
    /usr/bin/vault operator unseal $key1
    /usr/bin/vault operator unseal $key2
    /usr/bin/vault operator unseal $key3
fi

vault_status=$(/usr/bin/vault status -format "json" | jq --raw-output '.sealed')
echo $vault_status
