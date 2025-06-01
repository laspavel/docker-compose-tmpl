# Authentik

Authentik is an open-source multi-factor authentication solution for Django. With Authentik, you can easily add two-factor authentication, social authentication and other advanced features to your Django projects.

Features include:

- Support for TOTP and U2F-based two-factor authentication
- Social authentication with providers like Google, Facebook and more
- User self-service features such as password reset and account management
- Easy integration with Django's built-in authentication
- Support for multiple authentication flows and flexible policy configuration

Authentik can be easily set up and configured, making it a great solution for adding advanced authentication features to your Django projects.

You can check more details and download the software on [Authentik-project/authentik](https://github.com/Authentik-project/authentik)

Keep your users' accounts secure with Authentik!

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
