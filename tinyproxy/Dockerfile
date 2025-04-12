FROM alpine:3.14
RUN set -xe && apk add --no-cache tinyproxy
COPY tinyproxy.conf /etc/tinyproxy/tinyproxy.conf
VOLUME [/etc/tinyproxy]
EXPOSE 8888
CMD ["tinyproxy","-d"]
