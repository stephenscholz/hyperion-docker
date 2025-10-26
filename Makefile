.PHONY: build up down restart logs shell clean help

# Variables
IMAGE_NAME := hyperion-ng
CONTAINER_NAME := hyperion
VERSION := latest

# Default target
.DEFAULT_GOAL := help

help: ## Show this help message
	@echo "Hyperion.ng Docker Makefile"
	@echo ""
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  %-15s %s\n", $$1, $$2}'

build: ## Build the Docker image
	@echo "Building $(IMAGE_NAME):$(VERSION)..."
	docker build -t $(IMAGE_NAME):$(VERSION) .

build-dev: ## Build the Docker image with development version
	@echo "Building $(IMAGE_NAME):dev..."
	docker build --build-arg HYPERION_VERSION=development -t $(IMAGE_NAME):dev .

build-nocache: ## Build the Docker image without cache
	@echo "Building $(IMAGE_NAME):$(VERSION) without cache..."
	docker build --no-cache -t $(IMAGE_NAME):$(VERSION) .

up: ## Start the container using docker-compose
	@echo "Starting Hyperion..."
	docker-compose up -d

down: ## Stop the container
	@echo "Stopping Hyperion..."
	docker-compose down

restart: ## Restart the container
	@echo "Restarting Hyperion..."
	docker-compose restart

logs: ## Show container logs
	docker-compose logs -f

logs-tail: ## Show last 100 lines of logs
	docker-compose logs --tail=100 -f

shell: ## Open a shell in the running container
	docker exec -it $(CONTAINER_NAME) /bin/bash

config: ## Open a shell for editing configuration
	@echo "Configuration files are in: ./config/"
	@ls -la ./config/

ps: ## Show running containers
	docker-compose ps

stats: ## Show container resource usage
	docker stats $(CONTAINER_NAME)

clean: ## Remove stopped containers and unused images
	@echo "Cleaning up..."
	docker-compose down -v
	docker image prune -f

clean-all: ## Remove all containers, images, and volumes (DESTRUCTIVE)
	@echo "WARNING: This will remove all Hyperion data!"
	@read -p "Are you sure? [y/N] " -n 1 -r; \
	echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		docker-compose down -v; \
		docker rmi $(IMAGE_NAME):$(VERSION) 2>/dev/null || true; \
		rm -rf ./config/*.json ./config/*.db; \
		echo "Cleanup complete."; \
	fi

test: ## Test the Docker build
	@echo "Testing Docker build..."
	docker build -t $(IMAGE_NAME):test .
	@echo "Build successful!"

pull: ## Pull the latest base images
	docker pull debian:bookworm-slim

backup: ## Backup configuration
	@echo "Backing up configuration..."
	@mkdir -p backups
	tar -czf backups/hyperion-config-$$(date +%Y%m%d-%H%M%S).tar.gz config/
	@echo "Backup created in backups/"

restore: ## Restore configuration from backup (usage: make restore BACKUP=filename)
	@if [ -z "$(BACKUP)" ]; then \
		echo "Usage: make restore BACKUP=backups/hyperion-config-YYYYMMDD-HHMMSS.tar.gz"; \
		ls -1 backups/*.tar.gz 2>/dev/null || echo "No backups found"; \
	else \
		echo "Restoring from $(BACKUP)..."; \
		tar -xzf $(BACKUP); \
		echo "Restore complete. Restart the container to apply changes."; \
	fi

update: ## Update to the latest version
	@echo "Updating Hyperion..."
	docker-compose pull
	docker-compose up -d
	@echo "Update complete!"
