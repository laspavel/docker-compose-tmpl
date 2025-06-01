# Traefik

[Traefik](https://traefik.io/) is a reverse proxy and load balancer for a Docker Swarm cluster. Traefik automatically routes traffic to the appropriate service by inspecting the host requested and the corresponding `label` in the service's `docker-compose.yml`.

## Features

- Automatic generation of wildcard SSL certificates from [Let's Encrypt](https://letsencrypt.org/)
- Dynamic configuration using [Docker](https://www.docker.com/) labels
- Automatic service discovery in a [Docker Swarm](https://docs.docker.com/engine/swarm/) cluster
- Automatic cert-resolver using [Cloudflare](https://www.cloudflare.com/)

## Getting Started

These instructions will get you a copy of the project up and running.

### Prerequisites

What things you need to install the software and how to install them

- [Docker](https://www.docker.com/) - Containerization platform
- [Docker Compose](https://docs.docker.com/compose/) - Tool for defining and running multi-container applications
- [Docker Swarm](https://docs.docker.com/engine/swarm/) - Native orchestration solution for Docker

### Installing

Deploy the stack:

```bash
docker stack deploy -c docker-compose.yml <your-stack-name>
```
