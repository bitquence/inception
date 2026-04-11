NAME = inception

DOCKER_COMPOSE_FILE = ./srcs/compose.yaml
DOCKER_COMPOSE_OPTS = -f $(DOCKER_COMPOSE_FILE)

SECRETS_DIR = ./secrets
VOLUMES_DIR = ${HOME}/data
DOMAIN_NAME = jamar.42.fr

VOLUMES = wordpress mariadb
VOLUMES := $(addprefix $(VOLUMES_DIR)/,$(VOLUMES))

SECRETS = $(DOMAIN_NAME).crt \
	$(DOMAIN_NAME).key \
	mariadb_user_password \
	mariadb_root_password \
	wordpress_admin_password \
	wordpress_user_password
SECRETS := $(addprefix $(SECRETS_DIR)/,$(SECRETS))

up: $(SECRETS)
	docker compose $(DOCKER_COMPOSE_OPTS) up

build: $(SECRETS)
	docker compose $(DOCKER_COMPOSE_OPTS) up --build

down:
	docker compose $(DOCKER_COMPOSE_OPTS) down

clean:
	docker image rm "nginx:inception" "wordpress:inception" "mariadb:inception"

$(SECRETS_DIR):
	mkdir -p $@

$(SECRETS_DIR)/$(DOMAIN_NAME).key: $(SECRETS_DIR)/$(DOMAIN_NAME).crt
$(SECRETS_DIR)/$(DOMAIN_NAME).crt: $(SECRETS_DIR)
	openssl req -x509 -newkey rsa:2048 -days 365 \
		-noenc -out $@ -keyout $(@:%.crt=%.key) -subj "/CN=$(DOMAIN_NAME)" \
		-addext "subjectAltName=DNS:$(DOMAIN_NAME),DNS:*.$(DOMAIN_NAME)" &> /dev/null
