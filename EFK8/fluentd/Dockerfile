FROM fluent/fluentd:v1.17-1

USER root
RUN gem uninstall -I elasticsearch && gem install elasticsearch -v 8.13.4
RUN ["gem", "install", "fluent-plugin-elasticsearch", "--no-document", "--version", "5.4.3"]

RUN gem sources --clear-all \
  && rm -rf /tmp/* /var/tmp/* /usr/lib/ruby/gems/*/cache/*.gem

COPY fluent.conf /fluentd/etc/

USER fluent
