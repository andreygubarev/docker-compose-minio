MAKEFILE_DIR := $(realpath $(dir $(firstword $(MAKEFILE_LIST))))

.PHONY: help
help: ## Show this help
	@egrep -h '\s##\s' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

.PHONY: clean
clean: ## Remove Minio server
	@docker compose -p $(TUNNEL_NAME) down -v

.PHONY: up
up: ## Start Minio server
	@TUNNEL_TOKEN=$(shell cloudflared tunnel token $(TUNNEL_NAME)) docker compose -p $(TUNNEL_NAME) up -d

.PHONY: down
down: ## Stop Minio server
	@docker compose -p $(TUNNEL_NAME) down

.PHONY: restart
restart: down up ## Restart Minio server

.PHONY: logs
logs: ## Show logs
	@docker compose -p $(TUNNEL_NAME) logs -f

.PHONY: cloudflared
cloudflared:  ## Generate cloudflared config
	cloudflared tunnel create $(TUNNEL_NAME) || true
	cloudflared tunnel route dns $(TUNNEL_NAME) minio.$(TUNNEL_HOSTNAME) || true
	cloudflared tunnel route dns $(TUNNEL_NAME) minioconsole.$(TUNNEL_HOSTNAME) || true
