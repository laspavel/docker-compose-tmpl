# Searxng

Searxng is an open-source metasearch engine that allows users to search the internet securely and anonymously.
It provides the ability to search multiple search engines at once, while also allowing users to customize their search by adding or removing search engines, as well as adjusting various other settings.

Some of the key features of Searxng include:

    - No tracking or personalization of search results
    - Support for multiple search engines
    - Easy customization of search engines and settings
    - Support for different themes and user-agents
    - Easy to deploy with Docker

Searxng is a great choice for anyone who values privacy and wants a more open-source alternative to popular search engines. It's easy to install and customize,

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
