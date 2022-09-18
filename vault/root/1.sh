#!/bin/bash

cd /root
vault login
vault auth enable approle
vault write auth/approle/role/jenkins-role token_num_uses=0 secret_id_num_uses=0 policies="jenkins"
vault read auth/approle/role/jenkins-role/role-id
vault write -f auth/approle/role/jenkins-role/secret-id
vault secrets enable -path=secrets kv
vault write secrets/infr-jenkins/ci-cd/prod @prod.json
vault policy write jenkins jenkins-policy.hcl
vault read secrets/infr-jenkins/ci-cd/prod
