# AdGuard Home

AdGuard Home is an open-source network-wide software for blocking ads and tracking. It can be run on a variety of platforms, including Windows, macOS, Linux, and Raspberry Pi. With AdGuard Home, you can protect all of your devices connected to your home network from ads and tracking, without the need to install ad-blocking software on each device individually.

Features include:

- Blocking ads and tracking on all devices connected to your network
- Customizable filtering options, including the ability to create your own filtering rules
- Web interface for managing the software and monitoring network activity
- Parental controls to block inappropriate content
- Support for DNS-over-HTTPS and DNS-over-TLS for added security

AdGuard Home can be easily set up and configured using the included docker-compose file, making it a great solution for home network protection.

You can check more details and download the software on [AdguardTeam/AdGuardHome](https://github.com/AdguardTeam/AdGuardHome)

Enjoy ad-free browsing on all of your devices with AdGuard Home!

## Getting Started

These instructions will get you a copy of the project up and running.

### Prerequisites

What things you need to install the software and how to install them

- [Docker](https://www.docker.com/) - Containerization platform
- [Docker Compose](https://docs.docker.com/compose/) - Tool for defining and running multi-container applications
- [Docker Swarm](https://docs.docker.com/engine/swarm/) - Native orchestration solution for Docker
- [Traefik](https://traefik.io/) - Modern HTTP reverse proxy and load balancer

### Installing

Deploy the stack

```bash
docker stack deploy -c docker-compose.yml <your-stack-name>
```
