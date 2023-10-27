## Стартовое конфигурирование.

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

## Включение AD авторизации.

    vault login token=<TOKEN>
    vault auth enable ldap
    vault write auth/ldap/config \
        url="ldap://example.com" \
        userattr=sAMAccountName \
        upndomain="example.com" \
        userdn="ou=Users,dc=example,dc=com" \
        groupdn="ou=Users,dc=example,dc=com" \
        groupfilter="(|(memberUid={{.Username}})(member={{.UserDN}})(uniqueMember={{.UserDN}}))" \
        groupattr="memberOf" \
        binddn="cn=vault,ou=users,dc=example,dc=com" \
        bindpass='My$ecrt3tP4ss'

**example:**

       vault write auth/ldap/config \
            url="ldap://mycdserver.com" \
            userattr=sAMAccountName \
            upndomain="mydomain.com" \
            userdn="dc=mydomain,dc=com" \
            groupfilter="(|(memberUid={{.Username}})(member={{.UserDN}})(uniqueMember={{.UserDN}}))" \
            groupattr="cn" \
            binddn="CN=my_ldap_search,OU=myGroup,OU=Service-Accounts,DC=mydomain,DC=com" \
            bindpass='Passss'

## Включение AUDIT:

    vault login token=<TOKEN>
    vault audit enable file file_path=/vault/logs/vault_audit.log

-------
* https://blog.knoldus.com/integrating-jenkins-hashicorp-vault/
* https://www.vaultproject.io/api-docs/index/
