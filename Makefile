SHELL := bash
.SHELLFLAGS := -eu -o pipefail -c
MAKEFLAGS += --warn-undefined-variables
DOCKER_COMPOSE := docker compose

include .env
export PUID ?= $(shell id -u)
export PGID ?= $(shell id -g)

help:
	@echo -e "\033[0;32m Usage: make [target] "
	@echo
	@echo -e "\033[1m targets:\033[0m"
	@egrep '^(.+):*\ ##\ (.+)' ${MAKEFILE_LIST} | column -t -c 2 -s ':#'
.PHONY: help

<---docker------->: ## -----------------------------------------------------------------------
shell: ## Run a shell inside the container
	$(DOCKER_COMPOSE) run --rm -it lane4-php-cli sh
.PHONY: shell

build: ## Builds php image
	$(DOCKER_COMPOSE) build lane4-php-cli
	@docker images --filter dangling=true -q | xargs -r docker rmi
.PHONY: build

push: ## Pushes php image to docker repo
	@docker push lane4digital/lane4-php-cli:latest
.PHONY: build

remove: ## Stops and removes containers, images, network, volumes and caches
	$(DOCKER_COMPOSE) down --volumes --remove-orphans --rmi "all"
	@docker images --filter dangling=true -q | xargs -r docker rmi

<---composer----->: ## -----------------------------------------------------------------------
install: ## Run composer install
	$(DOCKER_COMPOSE) run -u ${PUID}:${PGID} --rm lane4-php-cli composer install --no-cache
.PHONY: install

update: ## run composer update
	$(DOCKER_COMPOSE) run --rm -it -e XDEBUG_MODE=off lane4-php-cli composer update

autoload: ## Run composer dump-autoload
	$(DOCKER_COMPOSE) run -u ${PUID}:${PGID} --rm lane4-php-cli composer dumpautoload
.PHONY: autoload

<---qa tools----->: ## -----------------------------------------------------------------------
phpunit: ## Run all tests -> phpunit.xml
	$(DOCKER_COMPOSE) run -u ${PUID}:${PGID} --rm lane4-php-cli vendor/bin/phpunit /app/tests
.PHONY: phpunit

phpunit-reports: ## Run all tests with reports -> clover and coverage
	$(DOCKER_COMPOSE) run -u ${PUID}:${PGID} --rm -e XDEBUG_MODE=coverage lane4-php-cli vendor/bin/phpunit /app/tests phpunit --coverage-clover tests/reports/clover.xml --coverage-xml tests/reports/coverage-xml
.PHONY: phpunit-reports

phpunit-coverage: ## Run all tests to find test leaks
	$(DOCKER_COMPOSE) run -u ${PUID}:${PGID} --rm -e XDEBUG_MODE=coverage lane4-php-cli vendor/bin/phpunit /app/tests phpunit --coverage-text
.PHONY: phpunit-coverage

phpstan: ## Run analyse source in src -> phpstan.neon
	$(DOCKER_COMPOSE) run -u ${PUID}:${PGID} --rm lane4-php-cli vendor/bin/phpstan analyse /app/src -c phpstan.neon
.PHONY: phpstan

phpcs: ## Run coding standards -> phpcs.cml
	$(DOCKER_COMPOSE) run -u ${PUID}:${PGID} --rm lane4-php-cli vendor/bin/phpcs /app/src
.PHONY: phpcs

<---ssh agent---->: ## -----------------------------------------------------------------------
ssh-agent: ## Get SSH agent ready
	eval `ssh-agent -s`
	ssh-add
.PHONY: ssh-agent
