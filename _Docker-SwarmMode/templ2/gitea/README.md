# Gitea

Gitea is a self-hosted Git service that allows you to easily host and manage your own Git repositories. It is similar to GitHub, but can be run on your own server, giving you full control over your data and infrastructure.

Features include:

- Support for Git and SSH protocols
- Web-based code browsing and review
- Built-in issue tracking and project management
- Multi-language support
- Easy installation and configuration

Gitea is open-source software, which means it's free to use and modify. You can find the source code and installation instructions on [gitea.io](https://gitea.io/)

Host and manage your own Git repositories with Gitea!

## Getting Started

These instructions will get you a copy of the project up and running.

### Prerequisites

What things you need to install the software and how to install them

- [Docker](https://www.docker.com/) - Containerization platform
- [Docker Compose](https://docs.docker.com/compose/) - Tool for defining and running multi-container applications
- [Docker Swarm](https://docs.docker.com/engine/swarm/) - Native orchestration solution for Docker
- [Traefik](https://traefik.io/) - Modern HTTP reverse proxy and load balancer

### Installing

Deploy the stack:

```bash
docker stack deploy -c docker-compose.yml <your-stack-name>
```
