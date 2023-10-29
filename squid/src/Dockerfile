FROM alpine:3.15.3

LABEL maintainer="Laspavel <laspavel@gmail.com>"

ENV SQUID_VERSION=5.2-r0 \
    CACHE_DIR=/var/spool/squid \
    LOG_DIR=/var/log/squid

RUN apk add --no-cache squid="$SQUID_VERSION"
RUN mkdir -p ${LOG_DIR} \
  && chmod -R 755 ${LOG_DIR} \
  && chown -R squid ${LOG_DIR} \
  && mkdir -p ${CACHE_DIR} \
  && chmod -R 755 ${LOG_DIR} \
  && chown -R squid ${CACHE_DIR} \
  && echo "pid_filename /var/run/squid/squid.pid" >> /etc/squid/squid.conf

COPY start.sh /start.sh

EXPOSE 3128/tcp
USER squid

ENTRYPOINT ["/start.sh"]





