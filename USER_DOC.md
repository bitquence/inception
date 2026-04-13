# Inception user documentation

## Services

The services Inception provides are as follows:

### nginx

nginx in short, is the website's server. It handles traffic through https and routes it towards the website (wordpress instance), which is contained in the virtual network. The actual website is only exposed within this virtual network, and the only way to access it from outside is through nginx.

### wordpress

wordpress is referred to as the website's code and functionality. PHP-FPM is running within the container and allows the website to execute code to respond to a request. For instance, when a user makes a comment, this triggers the script which commits the data into the database.

### mariadb

mariadb is the data store used by wordpress for persistent data storage. It contains information such as the posts and comments on the website, as well as the different users.

## Instructions

To run Inception, you must first define the following secrets in the `./secrets/` directory:
	- `mariadb_user_password`
	- `mariadb_root_password`
	- `wordpress_admin_password`
	- `wordpress_user_password`
	
Then, you can run `make` in order to build the project and put the website online. To take the website offline, run `make down`, and to clean the project's data store, run `make clean`.

Next, add `127.0.0.1 jamar.42.fr` to your `/etc/hosts` file. The website should now be accessible through your browser of choice.

## Administration and credentials

Administration of wordpress is done on the `https://jamar.42.fr/wp-admin` page. By default, the admin username is `mamiya`, and the password is the one contained in the `./secrets/` directory. A normal is created by default, and it holds the username `pentax`. All users may be managed through the administration page.

## Service health

`docker compose ls` may be used to list the running Docker compose projects. `docker compose -f ./srcs/compose.yaml ps` may be used to list the running containers related to Inception.
