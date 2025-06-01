# Autodiscover Email Settings

Provides Autodiscover capabilities for IMAP/POP/SMTP/LDAP services on Microsoft Outlook/Apple Mail and Autoconfig capabilities for Thunderbird.

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
