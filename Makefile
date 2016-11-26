#!make
include .env

DOCKER_GROUP = gbifs
CLBVERSION = 2.47-SNAPSHOT
NAME = $(DOCKER_GROUP)/clb
VERSION = $(TRAVIS_BUILD_ID)

ME = $(USER)
TS := $(shell date '+%Y_%m_%d_%H_%M')
PWD := $(shell pwd)
USR := $(shell id -u)
GRP := $(shell id -g)

CLB_URL$ = https://github.com/gbif/checklistbank

all: build up
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
	@docker build -t $(DOCKER_GROUP)/clbdb:v$(CLBVERSION) db

start-db:
	@docker-compose up -d dnsdock db
	@./wait-for-it.sh clbdb.docker:5432 -- && \
		docker exec -it db psql -U $(POSTGRES_USER) \
		template1 -c 'create extension if not exists hstore;'

build-ws:
	@echo "Building ws image..."
	@docker build -t $(DOCKER_GROUP)/clbws:v$(CLBVERSION) ws

build-nub-ws:
	@echo "Building nub-ws image..."
	@docker build -t $(DOCKER_GROUP)/nubws:v$(CLBVERSION) nub-ws

build-cli:
	@echo "Building cli image..."
	@docker build -t $(DOCKER_GROUP)/clbcli:v$(CLBVERSION) cli


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
	docker-compose run cli /bin/bash

# make crawl key=a739f783-08c1-4d47-a8cc-2e9e6e874202
clb-crawl:
	docker-compose run --rm cli ./admin.sh CRAWL --key $(key)

clb-analysis:
	docker-compose run --rm \
		-e COMMAND=analysis \
		-e MAX_HEAP=256M \
		cli 

clb-crawler:
	docker-compose run --rm \
		-e COMMAND=crawler \
		-e MAX_HEAP=256M \
		cli

clb-importer:
	docker-compose run --rm \
		-e COMMAND=importer \
		-e MAX_HEAP=1G \
		cli
 
clb-matcher:
	docker-compose run --rm \
		-e COMMAND=dataset-matcher \
		-e MAX_HEAP=2G \
		cli

clb-normalizer:
	docker-compose run --rm \
		-e COMMAND=normalizer \
		-e MAX_HEAP=2G \
		cli

clb-admin:
	docker-compose run --rm \
		-e MAX_HEAP=256M \
		cli bash


test-web:
	@echo "This call uses dnsdock names - image-name.docker "
	@echo "where image-name is last part of the image tag"
	@echo "... we have these active services:"
	@curl -s http://dnsdock.docker/services | json_pp
	@xdg-open http://clbws.docker:9000/species &
	@xdg-open http://nubws.docker:9002/ &
	@xdg-open http://nub.docker &


rm: stop
	@echo "Removing containers and persisted data"
	docker-compose rm -vf

push:
	@docker push $(DOCKER_GROUP)/clbws:v$(CLBVERSION)
	@docker push $(DOCKER_GROUP)/clbcli:v$(CLBVERSION)

release: build push
