# BookStack

BookStack is an open-source platform for creating and managing documentation. It allows for easy organization, searching, and access to documentation, making it a great solution for teams and organizations.

Features include:

- Easy organization of documentation with hierarchical pages and chapters
- Searching and filtering of documentation
- Role-based access control for managing permissions
- Built-in image, link, and table support in the editor
- Support for markdown formatting
- Multi-language support

BookStack can be easily set up and configured, making it a great solution for documentation management.

You can check more details and download the software on [bookstackapp.com](https://www.bookstackapp.com/)

Keep your documentation organized and easily accessible with BookStack!

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
