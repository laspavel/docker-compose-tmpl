# Actual Budget

Actual is a local-first personal finance tool. It is 100% free and open-source, written in NodeJS, it has a synchronization element so that all your changes can move between devices without any heavy lifting.

Check the [official Repository](https://github.com/actualbudget/actual) for more details.

## Getting Started

These instructions will get you a copy of the project up and running.

### Prerequisites

What things you need to install the software and how to install them

* [Docker](https://www.docker.com/) - Containerization platform
* [Docker Compose](https://docs.docker.com/compose/) - Tool for defining and running multi-container applications
* [Docker Swarm](https://docs.docker.com/engine/swarm/) - Native orchestration solution for Docker
* [Traefik](https://traefik.io/) - Modern HTTP reverse proxy and load balancer

### Installing

Deploy the stack with the following command:

```bash
docker stack deploy -c docker-compose.yml <your-stack-name>
```
