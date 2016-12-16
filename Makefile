#!make
include .env

DOCKER_GROUP = gbifs
CLBVERSION = 2.47-SNAPSHOT
CLB_URL = https://github.com/gbif/checklistbank
NAME = $(DOCKER_GROUP)/clb
VERSION = $(TRAVIS_BUILD_ID)

ME = $(USER)
HOST = clb.local
MVN := maven:3.3.9-jdk-8
TS := $(shell date '+%Y_%m_%d_%H_%M')
PWD := $(shell pwd)
USR := $(shell id -u)
GRP := $(shell id -g)

SOLR_BASE = https://raw.githubusercontent.com/gbif/checklistbank/master/checklistbank-solr/src/main/resources/solr/checklistbank/conf

MVN_REPO = http://repository.gbif.org/service/local/artifact/maven/redirect?g=org.gbif.checklistbank

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

	@test -f ws/checklistbank-ws.jar || \
		curl --progress -L -o ws/checklistbank-ws.jar \
			"$(MVN_REPO)&a=checklistbank-ws&r=gbif&v=$(CLBVERSION)"

	@test -f cli/checklistbank-cli.jar || \
		curl --progress -L -o cli/checklistbank-cli.jar \
			"$(MVN_REPO)&a=checklistbank-cli&r=gbif&c=shaded&v=$(CLBVERSION)"
	
	@test -f solr/schema.xml || \
		curl --progress -L -o solr/schema.xml \
			"$(SOLR_BASE)/schema.xml"

	@test -f solr/solrconfig.xml || \
		curl --progress -L -o solr/solrconfig.xml \
			"$(SOLR_BASE)/solrconfig.xml"

	@test -f solr/protwords.txt || \
		curl --progress -L -o solr/protwords.txt \
			"$(SOLR_BASE)/protwords.txt"

	@test -f solr/stopwords.txt || \
		curl --progress -L -o solr/stopwords.txt \
			"$(SOLR_BASE)/stopwords.txt"

	@test -f solr/synonyms.txt || \
		curl --progress -L -o solr/synonyms.txt \
			"$(SOLR_BASE)/synonyms.txt"

	@test -f solr/checklistbank-solr-plugins.jar || \
		curl --progress -L -o solr/checklistbank-solr-plugins.jar \
			"$(MVN_REPO)&a=checklistbank-solr-plugins&c=shaded&r=gbif&v=$(CLBVERSION)"

	@test -f db/schema.sql || \
		curl --progress -L -o db/schema.sql \
			"https://raw.githubusercontent.com/gbif/checklistbank/master/docs/schema.sql"

build: build-db build-solr build-ws build-nub-ws build-cli

build-db:
	@echo "Building db image..."
	@docker build -t $(DOCKER_GROUP)/clbdb:$(CLBVERSION) db

build-solr:
	@echo "Building solr image..."
	@docker build -t $(DOCKER_GROUP)/clbsolr:$(CLBVERSION) solr

build-ws:
	@echo "Building ws image..."
	@docker build -t $(DOCKER_GROUP)/clbws:$(CLBVERSION) ws

build-nub-ws:
	@echo "Building nub-ws image..."
	@docker build -t $(DOCKER_GROUP)/nubws:$(CLBVERSION) nub-ws

build-cli:
	@echo "Building cli image..."
	@docker build -t $(DOCKER_GROUP)/clbcli:$(CLBVERSION) cli


up:
	@echo "Starting services..."
	@docker-compose up -d

down:
	@echo "Stopping services..."
	@docker-compose down



connect-db:
	@docker exec -it db \
		psql -U $(POSTGRES_USER) -d $(POSTGRES_DB)

backup-db:
	docker exec -it db \
		bash -c "pg_dump -U $(POSTGRES_USER) -d $(POSTGRES_DB) > /tmp/clb.sql"

restore-db:
	@echo "This will not work if the database already exists"
	docker exec -it db \
		psql $(POSTGRES_USER) -d $(POSTGRES_DB) -f /tmp/clb.sql

connect-cli:
	@docker-compose run admin bash

crawl:
	docker-compose run admin ./admin.sh CRAWL --key $(key)

crawl-dyntaxa:
	docker-compose run admin ./admin.sh CRAWL --key de8934f4-a136-481c-a87a-b0b202b80a31
	
crawl-quick:
	docker-compose run admin ./admin.sh CRAWL --key a739f783-08c1-4d47-a8cc-2e9e6e874202


test:
	@echo "Will open the checklistbank services locally in the browser if you have dnsdock setup"
	@xdg-open http://clb.docker


rm: stop
	@echo "Removing containers and persisted data"
	docker-compose rm -vf

push:
	@docker push $(DOCKER_GROUP)/clbdb:$(CLBVERSION)
	@docker push $(DOCKER_GROUP)/clbsolr:$(CLBVERSION)
	@docker push $(DOCKER_GROUP)/clbws:$(CLBVERSION)
	@docker push $(DOCKER_GROUP)/nubws:$(CLBVERSION)
	@docker push $(DOCKER_GROUP)/clbcli:$(CLBVERSION)

release: build push
