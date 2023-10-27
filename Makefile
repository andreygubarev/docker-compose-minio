MAKEFILE_DIR := $(realpath $(dir $(firstword $(MAKEFILE_LIST))))

.PHONY: help
help: ## Show this help
	@egrep -h '\s##\s' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

.PHONY: clean
clean: ## Remove Minio server
	@docker compose down -v

.PHONY: build
build: ## Build Minio server
	@docker compose build

.PHONY: up
up: ## Start Minio server
	@docker compose up -d

.PHONY: down
down: ## Stop Minio server
	@docker compose down

.PHONY: restart
restart: down up ## Restart Minio server

.PHONY: logs
logs: ## Show logs
	@docker compose logs -f

.PHONY: cloudflared
cloudflared:  ## Generate cloudflared config
	cloudflared tunnel create minio
	cloudflared tunnel info -o json minio | jq -r '.id'
	cloudflared tunnel route dns minio minio.andreygubarev.cloud
	cloudflared tunnel route dns minio minioconsole.andreygubarev.cloud
	cloudflared tunnel token minio
