# nub-docker
[![AGPLv3 License](http://img.shields.io/badge/license-AGPLv3-blue.svg) ](https://github.com/mskyttner/nub-docker/blob/master/LICENSE)

Dockerized build for GBIF taxonomy tools: [checklistbank](https://github.com/gbif/checklistbank)

Note: This is Work In Progress - the Makefile will change (and other things) and everything may not work.

# Usage

The Makefile provides targets (VERBs), for example you can:

	make  # use to build and launch all services from scratch

... or you can instead of `make all` launch granular actions step by step ...

	make init  # cache/dl files locally
	make build  # build docker images
	make up  # start services (currently uses docker-compose)

... or push a binary to a remote registry ...

	make release # build and push images to Docker Hub

... or debug various services ...

	make connect-db  # get db shell
	make connect-cli  # get shell in checklistbank cli container

... or issue a crawl ...
	
	# use gbif.org to find a dataset, say Dyntaxa and you get src:
	# http://www.gbif.org/dataset/de8934f4-a136-481c-a87a-b0b202b80a31
	# then issue crawl command with this identifier

	make crawl key=de8934f4-a136-481c-a87a-b0b202b80a31


The docker-compose.yml file provides components (NOUNs), for example:

	proxy (nginx reverse proxy, provides the only ports open to the "outside", used for ssl termination and routing http traffic)
	dnsdock (for service discovery from the host machine, on the "inside" of the software defined network)
	elk (for troubleshooting and looking at logs)

	solr (for search)
	db (uses postgres)
	web (nginx front-end to web services)
	rabbit (message bus)
	cli (checklistbank cli container)

	... etc ...

To start all services, test that they run and inspect the logs do:

	make up
	make connect-db
	make connect-cli
	make test-web # launches ELK to show logs

# Setting up the Docker host

The installation requires a docker host, ie the docker daemon running on a machine under your control. Please follow https://docs.docker.com/machine/get-started/ to run a local VM using docker-machine (at the time of writing Docker for Mac was awefully slow and is not recommended!)

## Alternatives for Mac: Docker Machine or VirtualBox

An option is to use VirtualBox on your Mac, install a Linux on it, install Docker and docker-compose and run everything it there.

Another option is Docker Machine. If you install it, you can use it to create or start the default virtualbox VM with at least 8g better 12g of memory:

	docker-machine create --driver virtualbox --virtualbox-memory "8192" --virtualbox-cpu-count 2 default
	docker-machine start default

## Building and running the services locally

The Makefile in this project provides simple targets for building and usage.

To build docker images locally and start up the containers with docker-compose just do:

	make build  # build docker images
	make up  # start services

Alternatively you can start the service with docker compose directly in the foreground to see all logs

	docker-compose up

To see the list of available containers run:

	docker-compose ps

You can view logs of container with

	docker logs solr

# ELK

The [ELK stack](http://elk-docker.readthedocs.io/) is configured for central logging.
The CLIs and webservice are logging through the logstash logback appender.
You can access kibana to search for logs on port 5601, e.g. http://192.168.99.100:5601/ on Mac, or 

# Services

The app.conf file routes web traffic to the various services available to the outside world:

 - nub.docker/clbcache [CLB webservices](http://www.gbif.org/developer/species) exposed through varnish, caching responses for 1h
 - nub.docker/ [Kibana logs](http://elk-docker.readthedocs.io/)
 - nub.docker/solr
 - nub.docker/clb [CLB webservices](http://www.gbif.org/developer/species), directly
 - nub.docker/rabbit RabbitMQ management plugin

To start a crawl for a dataset you can use make again. See [datasets.txt](cli/datasets.txt) for all registered datasets

	make crawl key=a739f783-08c1-4d47-a8cc-2e9e6e874202

# TODO

 - configure CLB species matching service (nubws)
 - add make target for backbone builds

# Further Reading

Documentation here:

- https://github.com/gbif/checklistbank/tree/master/docs
- http://gbif.blogspot.de/2016/04/updating-gbif-backbone.html
- http://gbif.blogspot.de/2016/08/gbif-backbone-august-2016-update.html
- http://gbif.blogspot.de/2015/03/improving-gbif-backbone-matching.html
