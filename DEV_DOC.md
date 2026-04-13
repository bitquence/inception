# Inception developer documentation

## Set up

Before running `make`, an adequate version of Docker must be installed on the machine, and the following files must exist in the `./secrets/`, and not be empty:
- `mariadb_user_password`
- `mariadb_root_password`
- `wordpress_admin_password`
- `wordpress_user_password`

If needed, the containers can be rebuilt using the `make build` command. This is useful for when secrets have to be rotated. `make clean` clears the volumes' contents.

## Containers and volumes

Containers and volumes can be inspected, respectively, using the `docker ps -a` and `docker volume ls` commands. You can delete one or more volumes using the `docker volume rm` command.

## Project data

By default, the project's data directories are stored in the user's home, at the `data` subdirectory. For instance, MariaDB's stores are present on the host system at "$HOME/data/mariadb". This can be changed by changing the `VOLUMES_DIR` variable in the Makefile.

To read where the volume's data current is, find the name of the volume using `docker volume ls` and get its path using `docker volume inspect $VOLUME_NAME | jq -r '.[].Options.device'`.

The directory is made available to the container using a named volume, therefore it remains persistent and any data written to it will still be available to the container even if restarted.


