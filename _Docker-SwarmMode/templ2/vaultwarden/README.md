# Vaultwarden

Vaultwarden is a self-hosted password manager that is based on Bitwarden, but it is not officially affiliated with Bitwarden. It is an open-source implementation of the Bitwarden server that can be run on your own infrastructure. It provides the same functionality as Bitwarden, including password storage and generation, multi-factor authentication, and integration with other apps and services. However, as it is not officially supported by Bitwarden, there may be differences or bugs that are not present in the official version.

## Getting Started

These instructions will get you a copy of the project up and running.

### Prerequisites

What things you need to install the software and how to install them

* [Docker](https://www.docker.com/) - Containerization platform
* [Docker Compose](https://docs.docker.com/compose/) - Tool for defining and running multi-container applications
* [Docker Swarm](https://docs.docker.com/engine/swarm/) - Native orchestration solution for Docker
* [Traefik](https://traefik.io/) - Modern HTTP reverse proxy and load balancer

### Installing

Deploy the stack:

```bash
docker stack deploy -c docker-compose.yml <your-stack-name>
```
