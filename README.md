# Inception

*This project has been created as part of the 42 curriculum by jamar.*

## Description

Inception is meant to familiarize and expose the student to **containerization** and composition of multiple containers through `docker compose`. The goal is to set up three services, nginx, wordpress, and mariadb, and to set up the data exchange processes between these containers (network, and filesystem, for instance).

The student is meant to manually write the images used to set up the services, and the containers, despite ready-made images existing on Docker's Docker Hub platform. The student will also set up networking and persistent file stores for the containers. This will familiarize the student with the syntax of **Dockerfiles** and the intricacies related to setting up docker images.

## Project Description

**Docker** is a piece of software that facilitates the containerization of processes, akin to a virtual machine for instance, but done using **operating-system-level constructs**, allowing them to remain lean and efficient while giving the guest program the illusion that it is running on its own distinct set of system resources. Furthermore, Docker containers are meant to be reproducible and consistent across all platforms.

This project specifically leverages the `docker compose` tool, which allows to compose multiple containers, and set up data flow between them. It offers secret management, networking between all services, and dependency management to ensure the containers start in the correct order.

### Design choices

**Initialization shell scripts** (entrypoint.sh and such) are used liberally in this project to ensure the image's initialization steps prior to running the script (which often involve downloading resources, or setting up directories/permissions) are cached, and due to the nature of how Docker images work, won't be evaluated again.

**Secrets** are managed through `docker compose`, which is configured in the `./srcs/compose.yaml` file. Said files are injected into the `/run/secrets/` directory in the target container. 

**Make** will not build the project if the files containing the various secrets don't exist at the `./secrets/` directory. The only secret that the Makefile will generate is the SSL certificate pair required for **nginx to function under https**.

### Virtual machines vs Docker containers

Docker containers differ from virtual machines in that they don't virtualize an entire machine, only the environment for the program to run in within the host operating system. Docker uses the Linux native virtualization primitives cgroups and namespaces in order to give the container the illusion that it is running on its own environment and has its own process space, user set and permissions, network interface and filesystem.

### Secrets vs Environment Variables

A service usually runs a program that requires configuration and credentials (think wordpress, postgress, etc...). Environment variables are mainly used for configuration purposes and are passed to the program at launch. They can be used to carry all kinds of information required for the program to start. Secrets on the other hand should never be divulged directly under any circumstance (though this also preferably applies to the environment) and are mainly used for passing passwords, private keys, API keys and other kinds of access control tokens used by the program.

`docker compose` allows you to inject files containing secrets into the container's filesystem at a specific path. This is one of the many prefered ways of managing secrets. It is useful in that it allows better separation of secrets from the environment variables, which are usually stored in a dedicated file named `.env`. Both secrets and environment variables should not be made available to the public and as such are **preferably never commited to a `git` repo**.

### Docker Network vs Host Network

Docker is able to virtualize all resources made available to the guest program, one of those resources being the **network**. Without any configuration in regards to networking, `docker compose` will set up a virtual network interface which will be made available to all containers. In this interface, all containers are assigned a virtual IP address. Said containers are also able to interface with the outside network through the host's real interface. Such networking strategy is called the `bridge` driver.

By contrast, the `host` driver lets the containers inherit the host's networking environment. Virtual IP addresses are not created for containers connected to the `host` network. For instance, if such a container were to bind port 80, requests coming in from the outside world through the host would be able to reach the container.

### Docker Volumes vs Bind Mounts

The process of using a "bind mount" on a file or directory means to make that file or directory on the host available directly to the container, at a given path. Volumes are also way of managing directories that will persist even when the container is shut down but differ from bind mounts in that they are completely managed by Docker. This gives them a few advantages, with the main one being portability. If Docker manages the specifics of how these volumes work, then it can do so consistently regardless of the platform, unlike bind mounts which depend on the host OS and its filesystem's structure.

## Instructions

### Build all containers initially, make them go online

1. Write the following secrets to the `./secrets/` directory:
	- `mariadb_user_password`
	- `mariadb_root_password`
	- `wordpress_admin_password`
	- `wordpress_user_password`
2. Optionally add a certificate for nginx to use while processing https requests. If one is not provided, `make` will generate one automatically using `openssl`.
2. Run the `make [up]` command.

### Rebuild all containers and make them go online

1. Ensure the secrets exist in the `./secrets/` directory.
2. Run the `make build` command.

### Take all containers down

1. Ensure the secrets exist in the `./secrets/` directory.
2. Run the `make build` command.

### Take all containers down and remove volumes (persistent data)

1. Run the `make clean` command.

### Take all containers down and remove volumes, container data, and Docker images

1. Run the `make fclean` command.

## Resources

- [Docker compose file reference](https://docs.docker.com/reference/compose-file)
- [Dockerfile reference](https://docs.docker.com/reference/dockerfile/)
- [Official Docker compose documentation](https://docs.docker.com/compose/)
- [Docker: Get started](https://docs.docker.com/get-started/)
- [Wikipedia: Linux namespaces](https://en.wikipedia.org/wiki/Linux_namespaces)
- [Wikipedia: Cgroups](https://en.wikipedia.org/wiki/Cgroups)
- [Configuring MariaDB with Option Files](https://mariadb.com/docs/server/server-management/install-and-upgrade-mariadb/configuring-mariadb/configuring-mariadb-with-option-files)
- [nginx documentation](https://nginx.org/en/docs/)
- [Alex's Home Network: Installing WordPress on Debian 13](https://alexshomenetwork.com/installing-wordpress-on-debian-13/#Configuring_php-fpm)
- [Official NGINX Docker files](https://github.com/nginx/docker-nginx)
- [Official WordPress Docker files](https://github.com/docker-library/wordpress)
- [Official MariaDB Docker files](https://github.com/MariaDB/mariadb-docker)
- [Choosing Between RUN, CMD, and ENTRYPOINT](https://www.docker.com/blog/docker-best-practices-choosing-between-run-cmd-and-entrypoint/)


### Use of AI

LLMs were only sparingly used in the making of this project and were only asked for assistance when used. Only a few lines of LLM generated code ended up being used. LLMs were not used to make any kind of documentation.
