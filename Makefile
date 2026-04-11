NAME = inception

SECRETS_DIR=./secrets
DOMAIN_NAME=jamar.42.fr

up:
	docker compose up --build

$(SECRETS_DIR)/:
	mkdir $(dir $@)

$(SECRETS_DIR)/$(DOMAIN_NAME).key: $(SECRETS_DIR)/$(DOMAIN_NAME).crt
$(SECRETS_DIR)/$(DOMAIN_NAME).crt: $(SECRETS_DIR)
	openssl req -x509 -newkey rsa:2048 -days 365 \
		-noenc -out $@ -keyout $(@:%.crt=%.key) -subj "/CN=$(DOMAIN_NAME)" \
		-addext "subjectAltName=DNS:$(DOMAIN_NAME),DNS:*.$(DOMAIN_NAME)" &> /dev/null
