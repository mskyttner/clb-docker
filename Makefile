#!make
include .env

NAME = dina/nub
VERSION = $(TRAVIS_BUILD_ID)
ME = $(USER)
HOST = nub.local
MVN := maven:3.3.9-jdk-8
TS := $(shell date '+%Y_%m_%d_%H_%M')
PWD := $(shell pwd)
USR := $(shell id -u)
GRP := $(shell id -g)

NUB_URL$ = https://github.com/gbif/checklistbank

all: init build up
.PHONY: all

init:
	@echo "Caching files required for the build..."

	@curl --progress -L -s -o wait-for-it.sh \
		https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh && \
		chmod +x wait-for-it.sh

	@git clone --depth=1 $(NUB_URL)

network:
	docker network create multi-host-network

start-db:
	@docker-compose up -d db
	@docker exec -it nubdocker_db_1 \
		psql -U $(POSTGRES_USER) template1 -c 'create extension hstore;'
	@docker network connect --alias clb multi-host-network nubdocker_db_1

connect-db:
	docker exec -it nubdocker_db_1 \
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

build: start-db build-maven

build-maven: 
	@echo "Building with mvn, be patient... half an hour?"	
	docker pull $(MVN)
	mkdir -p $(PWD)/repository
	cd checklistbank && docker run -it --rm --name my-maven-project \
		--net=multi-host-network \
		-v $(PWD)/checklistbank:/usr/src/mymaven \
		-v $(PWD)/settings.xml:/root/.m2/settings.xml \
		-v $(PWD)/repository:/root/.m2/repository \
		-w /usr/src/mymaven \
		$(MVN) mvn -P clb-local clean install -DskipTests=true
		#mvn -X -P clb-local --resume-from checklistbank-cli install -DskipTests=true
		#mvn -P clb-local liquibase:update
		#mvn -X -P clb-local clean install
		#-u $(USR):$(GRP) \
		#mvn -X clean install -rf :checklistbank-mybatis-service
	@find . -name *.jar | grep "target" | grep -v "surefire" | grep -v "SNAPSHOT"

build-docker:
	@echo "Building image(s)..."
	@docker build -t dina/nub:v0.1 nub

up:
	@echo "Starting services..."
	@docker-compose up -d

test-nub:
	@docker exec -it nub sh -c \
		"curl http://localhost:8983/solr/admin/cores?status" > solr.xml && \
		firefox solr.xml
test:
	@echo "Opening up... did you add ala.local in /etc/hosts?"
	#@curl -H "Host: ala.local" localhost/collectory/
	./wait-for-it.sh ala.local:80 -q -- xdg-open http://ala.local/collectory/ &

stop:
	@echo "Stopping services..."
	@docker-compose stop

clean:
	@echo "Removing downloaded files and build artifacts"
	#rm -f wait-for-it.sh
	#rm -f *.war

rm: stop
	@echo "Removing containers and persisted data"
	docker-compose rm -vf
	#sudo rm -rf mysql-datadir cassandra-datadir initdb lucene-datadir

push:
	@docker push dina/nub:v0.1

release: build push

dox:
	@echo "Rendering API Blueprint into HTLM documentation using aglio"
	docker pull humangeo/aglio
	docker run -ti --rm -v $(PWD)/:/docs humangeo/aglio \
		aglio -i apiary.apib -o nub-reference.html
	sudo chown $(USR):$(USR) nub-reference.html

