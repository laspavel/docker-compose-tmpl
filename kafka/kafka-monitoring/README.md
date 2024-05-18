This project demonstrates how to set up monitoring for a Kafka cluster. It includes configurations for jmx_exporter, Prometheus, Grafana with example dashboards, and Kafka UI for comprehensive monitoring capabilities.

# 1. Start the monitoring stack:
```shell
docker compose -f compose.yml up -d
```

This command starts 3-node Kafka cluster configured with jmx_exporter (https://github.com/prometheus/jmx_exporter), Prometheus, Grafana with example dashboards and Kafka UI (https://github.com/provectus/kafka-ui)

Access the services in your web browser:
* Kafka UI: http://localhost:8080/ (credentials - admin:admin)
* Grafana: http://localhost:3000/dashboards

# 2. Generate traffic in the Kafka cluster
Open first terminal session and create ephemeral container for access to standard Kafka console tools:
```shell
docker run -it --rm --network kafka-monitoring_default bitnami/kafka:3.6.1 /bin/bash
```

Inside this container, create a topic named `test.topic`:
```shell
kafka-topics.sh --create --bootstrap-server kafka-1:29092 --replication-factor 3 --partitions 9 --config min.insync.replicas=2 --topic test.topic
```

Run a tool to produce random messages at a constant rate of 1000 messages per second:
```shell
kafka-producer-perf-test.sh --topic test.topic --num-records 1000000 --record-size 500 --throughput 1000 --producer-props bootstrap.servers=kafka-1:29092
```

# 3. Consume produced messages
Open a second terminal session and create a second ephemeral container for access to standard Kafka console tools:
```shell
docker run -it --rm --network kafka-monitoring_default bitnami/kafka:3.6.1 /bin/bash
```

In this container, run the Kafka console consumer and print every 1000th message to avoid overloading the console:
```shell
kafka-console-consumer.sh --bootstrap-server kafka-1:29092 --topic test.topic --group test-consumer-group | awk 'NR % 1000 == 0'
```
# 4. Observe the monitoring dashboards
Finally, visit the following links to observe what happens when the Kafka cluster receives traffic:
* Kafka UI: http://localhost:8080/ (user and password - admin:admin)
* Grafana: http://localhost:3000/dashboards
