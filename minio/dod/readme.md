# Connect to Bucket
```
docker exec -it minio bash
bash-5.1# mc alias set myminio http://localhost:9000 root_user root_pass
```

# List connections
```
mc alias ls
```

# Create bucket
```
mc mb myminio/d01
mc mb myminio/d02
mc mb myminio/d03
```

# Add Users
```
#user: user1
#pass: 123456789
mc admin user add myminio user1 123456789
```

# Add new access policy
```
mc admin policy create myminio full-access-d01-d02 full-access_d01-d02.json
mc admin policy create myminio readonly-access-d03 readonly-access-d03.json
```

# Attach policy to user
```
mc admin policy attach myminio full-access-d01-d02 --user user1
mc admin policy attach myminio readonly-access-d03 --user user1
```

# List buckets
```
mc alias set userminio http://localhost:9000 user1 123456789
mc ls userminio/d03
```

# Detach access policy
```
mc admin policy detach myminio full-access-d01-d02 --user user1
mc admin policy detach myminio readonly-access-d03 --user user1
mc admin user info myminio user1
```

# Delete user
```
mc admin user remove myminio user1
mc admin user list myminio
```

# Delete access policy
```
mc admin policy remove myminio full-access-d01-d02
mc admin policy remove myminio readonly-access-d03
mc admin policy list myminio
```

