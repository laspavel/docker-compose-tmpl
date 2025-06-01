# HomeLab: [Docker Swarm](https://docs.docker.com/engine/swarm/) Templates

This project is a collection of docker-compose.yml templates for [Docker Swarm](https://docs.docker.com/engine/swarm/), which I use in my HomeLab.

## Disclaimer

Please note that while these templates aim to provide a helpful starting point, they may not cover all use cases or security considerations. It's important to review and adjust the configurations according to your specific requirements and best practices.

## Installation Manual

A step by step series of examples that tell you how to get started.

### Preconditions

The following preconditions must be met, before deploying the [Docker](https://www.docker.com/) stack.

* [Docker](https://www.docker.com/) - Containerization platform
* [Docker Compose](https://docs.docker.com/compose/) - Tool for defining and running multi-container applications
* [Docker Swarm](https://docs.docker.com/engine/swarm/) - Native orchestration solution for Docker

The **overlay network** "public" must be created:

```bash
docker network create --scope=swarm -d overlay public
```

### Cluster Initialization

Initializing of the [Docker Swarm Cluster](https://docs.docker.com/engine/swarm/):
**Data Port** needed to be adjusted when VMWare ESXi is used. More details can be found [here](https://portal.portainer.io/knowledge/known-issues-with-vmware).

```bash
docker swarm init --advertise-addr IP-ADDRESS --data-path-port=9789
```

### Docker Container deployment

Start with the deployment of **Traefik** which acts as **Reverse Proxy**.

Deployment of a [Docker](https://www.docker.com/) stacks.

```bash
docker stack deploy -c docker-compose.yml <your-stack-name>
```
