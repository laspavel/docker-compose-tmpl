# Overleaf swarm deployment
Overleaf has its own github repository for a community edition of overleaf that can be hosted on a local server. The repository only supports single instance deployment and not deployment in a swarm.

## File structure
The following folder structure is expected in the docker data folder

overleaf
    |- sharelatex
    |- sharelatex_packages
    |- mongo
    |- redis

## Resources
* [](https://www.vultr.com/docs/how-to-install-overleaf-community-edition-on-ubuntu-20-04-lts-74925/)
* [Official overleaf quickstart](https://github.com/overleaf/overleaf/wiki/Quick-Start-Guide)
* [](https://blog.felixviola.de/overleaf-ce-self-host-your-own-latex-server-tutorial/)
* [Overleaf behind traefik](https://github.com/smhaller/ldap-overleaf-sl/blob/master/docker-compose.traefik.yml)
* [Backing up mongodb](https://randulakoralage82.medium.com/how-to-backup-mongodb-in-docker-environment-7d964cba338d)

