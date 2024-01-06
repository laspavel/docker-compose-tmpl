# docker-squid
Minimalistic Docker image built on Alpine 3.15 in standart configuration

### Run:
```
docker run -p 3128:3128 laspavel/squid
```

### Run in Docker-Compose (conf/squid.conf - you configuration):
```
version: "3.1"
services:
    squid1:
      image: laspavel/squid:latest
      container_name: squid1
      restart: always
      volumes:
        - /etc/localtime:/etc/localtime:ro
        - ./conf/squid.conf:/etc/squid/squid.conf:ro
```

### Thanks for using ! :) ###
