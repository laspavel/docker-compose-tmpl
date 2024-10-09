FROM fluentd:v1.16.2-debian-1.1

# Switch to root user to install plugins
USER root

# Install plugins
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    build-essential \
    ruby-dev \
 && gem install \
    fluent-plugin-elasticsearch \
 && apt-get purge -y --auto-remove \
    build-essential \
    ruby-dev \
 && rm -rf /var/lib/apt/lists/*

# Switch back to fluent user
USER fluent