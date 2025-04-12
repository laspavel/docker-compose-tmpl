![](https://img.shields.io/github/v/release/laspavel/tinyproxy-docker) ![](https://img.shields.io/docker/pulls/laspavel/tinyproxy) ![](https://img.shields.io/github/license/laspavel/tinyproxy-docker)

# tinyproxy in Docker
dockerfile for tinyproxy on alpine linux.

# proxy port
port is ```8888```.

# how to use
```docker run -d -p 8888:8888 laspavel/tinyproxy -v tinyproxy.conf:/etc/tinyproxy/tinyproxy.conf```

