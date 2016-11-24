#!make
include .env

NAME = dina/clb
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

	@test -d checklistbank || \
		git clone --depth=1 $(CLB_URL) checklistbank

	#@cp pom.xml checklistbank 

start-db:
	@docker-compose up -d db
	@docker exec -it db \
		psql -U $(POSTGRES_USER) template1 -c 'create extension hstore;'

connect-db:
	docker exec -it db \
		psql -U $(POSTGRES_USER) -d $(POSTGRES_DB)

start-rabbit:
	@docker-compose up -d rabbit
	docker network connect --alias rabbit multi-host-network rabbit

start-neo:
	@docker-compose up -d neo
	docker network connect --alias neo multi-host-network neo

connect-neo:
	docker exec -it neo bin/neo4j-shell

start-solr:
	@docker-compose up -d solr
	docker network connect --alias solr multi-host-network solr

build: start-db build-nub build-clbws build-clbcli

build-nub:
	@docker-compose run maven \
		sh -c "cd /usr/src/mymaven && \
		mvn -P clb-local clean install -DskipTests=true"
	@find . -name *.jar | grep "target"

build-clbws:
	@echo "Building image(s)..."
	@cp checklistbank/checklistbank-ws/target/checklistbank-ws-2.46-SNAPSHOT.jar \
		clb-ws/checklistbank-ws.jar
	@docker build -t dina/clbws:v0.1 clb-ws

build-clbcli:
	@cp checklistbank/checklistbank-cli/target/checklistbank-cli.jar cli
	@docker build -t dina/clbcli:v0.1 cli

up:
	@echo "Starting services..."
	@docker-compose up -d

test-clbws:
	@xdg-open http://nub:9000

test-clbcli:
	@docker-compose run clbcli bash

down:
	@echo "Stopping services..."
	@docker-compose down

clean:
	@echo "Removing downloaded files and build artifacts"
	#rm -f wait-for-it.sh
	#rm -f *.war

rm: stop
	@echo "Removing containers and persisted data"
	docker-compose rm -vf
	#sudo rm -rf mysql-datadir cassandra-datadir initdb lucene-datadir

push:
	@docker push dina/clbws:v0.1
	@docker push dina/clbcli:v0.1

release: build push

dox:
	@echo "Rendering API Blueprint into HTLM documentation using aglio"
	docker pull humangeo/aglio
	docker run -ti --rm -v $(PWD)/:/docs humangeo/aglio \
		aglio -i apiary.apib -o nub-reference.html
	sudo chown $(USR):$(USR) nub-reference.html

