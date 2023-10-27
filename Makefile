MAKEFILE_DIR := $(realpath $(dir $(firstword $(MAKEFILE_LIST))))

.PHONY: help
help: ## Show this help
	@egrep -h '\s##\s' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

.PHONY: install
install:  ## Generate cloudflared config
	cloudflared tunnel create $(TUNNEL_NAME) || true
	cloudflared tunnel route dns $(TUNNEL_NAME) minio.$(TUNNEL_HOSTNAME) || true
	cloudflared tunnel route dns $(TUNNEL_NAME) minioconsole.$(TUNNEL_HOSTNAME) || true

.PHONY: clean
clean: ## Remove Minio server
	@docker compose -p $(TUNNEL_NAME) down -v

.PHONY: .cache/cloudflared
.cache/cloudflared:
	@rm -rf .cache
	@mkdir -p $(MAKEFILE_DIR)/.cache/cloudflared
	@envsubst < $(MAKEFILE_DIR)/templates/cloudflared/config.yaml > $(MAKEFILE_DIR)/.cache/cloudflared/config.yaml

.PHONY: up
up: .cache/cloudflared ## Start Minio server
	@TUNNEL_TOKEN=$(shell cloudflared tunnel token $(TUNNEL_NAME)) TUNNEL_CONFIG=$(MAKEFILE_DIR)/.cache/cloudflared docker compose -p $(TUNNEL_NAME) up -d

.PHONY: down
down: ## Stop Minio server
	@docker compose -p $(TUNNEL_NAME) down

.PHONY: restart
restart: down up ## Restart Minio server

.PHONY: logs
logs: ## Show logs
	@docker compose -p $(TUNNEL_NAME) logs -f

