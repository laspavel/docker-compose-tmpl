* vault login
* vault auth enable approle
* vault write auth/approle/role/jenkins-role  token_num_users=0   secret_id_num_uses=0 policies=“jenkins”
* vault read auth/approle/role/jenkins-role/role-id
* vault write -f auth/approle/role/jenkins-role/secret-id
* vault secrets enable -path=secrets kv
* cd /root

* cat prod.json
```
{ 
  "Key1": "Value1",
  "Key2": "Value2",
   ....
  "KeyN": "ValueN"
}
```

* vault write secrets/infr-jenkins/ci-cd/prod @prod.json
* cat jenkins-policy.hcl

```
path "secrets/infr-jenkins/ci-cd/prod" {
    capabilities = ["read"]
}
```

* vault policy write jenkins jenkins-policy.hcl
* vault read secrets/infr-jenkins/ci-cd/fineapp-deploy secrets/infr-jenkins/ci-cd/fineapp-deploy

##### https://blog.knoldus.com/integrating-jenkins-hashicorp-vault/

