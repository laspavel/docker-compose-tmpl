# Paperless NGX

[Paperless NGX](https://github.com/paperless-ngx) is a self-hosted document management system that allows you to manage, tag, and search for your documents using a web interface. It is a fork of the original Paperless project and it uses the latest Angular version. This system uses Gotenberg, Tika, PostgreSQL, and Redis as additional services.

Some of its key features include:

- Automatic OCR and PDF processing: Paperless NGX uses OCR (Optical Character Recognition) to extract text from images and PDFs, making them searchable. It also provides a feature to automatically process PDFs and extract text, images, and metadata.
- Automatic tagging of documents: Paperless NGX allows you to automatically tag your documents based on their content. You can also manually tag documents and search for them using these tags.
- Full-text search: Paperless NGX uses a full-text search engine to quickly find documents based on their content. This allows you to search for specific terms, phrases, or even regular expressions.
- Multi-language support: Paperless NGX supports multiple languages and allows you to switch between them easily. This makes it easier to manage documents in different languages.
- Customizable web interface: Paperless NGX provides a customizable web interface that allows you to adjust the look and feel to your liking.
- Customizable email notifications: Paperless NGX allows you to set up email notifications for various events, such as when new documents are added or when a document has been processed.
- Web API for integration with other services: Paperless NGX provides a web API that allows you to integrate with other services, such as automation tools, monitoring systems, and more

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
