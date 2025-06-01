# Cloudflare Dynamic DNS

Cloudflare Dynamic DNS (DDNS) is a service provided by Cloudflare that allows you to map a subdomain to an IP address that changes dynamically. This is useful for users who have a dynamic IP address assigned by their internet service provider (ISP), as it allows them to keep their subdomain pointing to their current IP address without manually updating DNS records.

Features include:

- Automatic updates of DNS records when your IP address changes
- Easy setup and configuration
- Integration with Cloudflare's other security and performance features

To use Cloudflare Dynamic DNS, you will need a Cloudflare account and a domain with DNS hosted on Cloudflare. You can then add a new DNS record for your subdomain, selecting the "Dynamic DNS" record type.

You can check more details and setup instructions on [developers.cloudflare.com/dns/dynamic-dns/](https://developers.cloudflare.com/dns/dynamic-dns/)

Keep your subdomains pointing to the correct IP address with Cloudflare Dynamic DNS!

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
