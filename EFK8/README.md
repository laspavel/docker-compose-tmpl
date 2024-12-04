# efk

Docker Compose for EFK (Elasticsearch + Fluentd + Kibana) stack.

## Command

```bash
docker compose up -d --build
```

Kibana: http://localhost:5601

## Verify

1. http://localhost:5601/app/discover#/
2. Create data view
   - Name: `Fluentd`
   - Index pattern: `fluentd-*`
   - Time field: `@timestamp`
3. Go on http://localhost
4. Check logs in Kibana

## References

- https://docs.fluentd.org/container-deployment/docker-compose
