#!make
include .env

DOCKER_GROUP = gbifs
DOCKER_VERSION = v0.1
NAME = $(DOCKER_GROUP)/clb
VERSION = $(TRAVIS_BUILD_ID)
ME = $(USER)
HOST = clb.local
MVN := maven:3.3.9-jdk-8
TS := $(shell date '+%Y_%m_%d_%H_%M')
PWD := $(shell pwd)
USR := $(shell id -u)
GRP := $(shell id -g)

CLB_URL$ = https://github.com/gbif/checklistbank

all: init build up
.PHONY: all

init:
	@echo "Caching files required for the build..."

	@test -f wait-for-it.sh || \
		curl --progress -L -s -o wait-for-it.sh \
			https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh && \
			chmod +x wait-for-it.sh

	@cp wait-for-it.sh nub-ws 
	@cp wait-for-it.sh cli
	@cp wait-for-it.sh ws

build: build-db build-ws build-nub-ws build-cli

build-db:
	@echo "Building db image..."
	@docker build -t $(DOCKER_GROUP)/clbdb:$(DOCKER_VERSION) db

start-db:
	@docker-compose up -d db
	@sleep 5 && docker exec -it db \
		psql -U $(POSTGRES_USER) template1 -c 'create extension if not exists hstore;'

build-ws:
	@echo "Building ws image..."
	@docker build --no-cache -t $(DOCKER_GROUP)/clbws:$(DOCKER_VERSION) ws

build-nub-ws:
	@echo "Building nub-ws image..."
	@docker build --no-cache -t $(DOCKER_GROUP)/nubws:$(DOCKER_VERSION) nub-ws

build-cli:
	@echo "Building cli image..."
	@docker build --no-cache -t $(DOCKER_GROUP)/clbcli:$(DOCKER_VERSION) cli


up:
	@echo "Starting services..."
	@docker-compose up -d

down:
	@echo "Stopping services..."
	@docker-compose down


connect-db:
	docker exec -it db \
		psql -U $(POSTGRES_USER) -d $(POSTGRES_DB)

connect-cli:
	docker-compose run clb-admin /bin/bash

# make crawl key=a739f783-08c1-4d47-a8cc-2e9e6e874202
crawl:
	docker-compose run clb-admin ./admin.sh CRAWL --key $(key)

test-clbws:
	@xdg-open http://nub:9000/species

test-clbcli:
	@docker-compose run clbcli bash



rm: stop
	@echo "Removing containers and persisted data"
	docker-compose rm -vf

push:
	@docker push $(DOCKER_GROUP)/clbws:$(DOCKER_VERSION)
	@docker push $(DOCKER_GROUP)/clbcli:$(DOCKER_VERSION)

release: build push
