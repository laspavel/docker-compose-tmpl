ui = true
disable_mlock = false

default_lease_ttl = "768h"
max_lease_ttl     = "768h"

# Storage configuration
storage "raft" {
  path = "/vault/raft/"
  node_id = "node_1"
}

api_addr = "http://homebook:8200"
cluster_addr = "http://homebook:8201"

# HTTPS listener
listener "tcp" {
  address       = "0.0.0.0:8200"
  tls_disable     = 1
#  tls_cert_file = "/vault/certs/vault.crt"
#  tls_key_file  = "/vault/certs/vault.key"
#  tls_disable = 0
}

# Prometheus (https://vault/v1/sys/metrics?format=prometheus)
telemetry {
  prometheus_retention_time = "24h"
  disable_hostname = true
}
