# clb-docker
Dockerized build for GBIF taxonomy tools from here: [checklistbank](https://github.com/gbif/checklistbank)

Note: This is Work In Progress - the Makefile will change (and other things) and everything may not work.

# Installation
The installation requires a running docker host. 
Please follow https://docs.docker.com/machine/get-started/ to run a local VM using docker-machine (at the time of writing Docker for Mac was awefully slow and is not recommended!)

If you have docker machine installed you can create or start the default virtualbox VM with:

	docker-machine create --driver virtualbox default
	docker-machine start default

The Makefile in this project provides simple targets for installation and usage.
To build docker images locally and start up the containers with docker-compose just do:

	make build  # build docker images
	make up  # start services

Alternatively you can start the service with docker compose directly in the foreground to see all logs

	docker-compose up

To see the list of available containers run:

	docker-compose ps

You can view logs of container with

	docker logs solr


## Usage
The host machine exposes various ports to the outside world:

 - MACHINE_IP:80 [CLB webservices](http://www.gbif.org/developer/species) exposed through varnish, caching responses for 1h
 - MACHINE_IP:5432 Postgres
 - MACHINE_IP:5601 [Kibana logs](http://elk-docker.readthedocs.io/)
 - MACHINE_IP:8983 Solr
 - MACHINE_IP:9000 [CLB webservices](http://www.gbif.org/developer/species), directly
 - MACHINE_IP:15672 RabbitMQ management plugin

Please use docker machine to find out the IP of your host VM:

	docker-machine ip default

To start a crawl for a dataset you can use make again. See [datasets.txt](cli/datasets.txt) for all registered datasets

	make crawl key=a739f783-08c1-4d47-a8cc-2e9e6e874202

You can connect to postgres quickly using psql via make:

	connect-db

You can connect to the cli container and run clb shell scripts manually via:

	connect-cli



# TODO

 - configure CLB species matching service (nubws)
 - add make target for backbone builds


# Further Reading

Documentation here:

- https://github.com/gbif/checklistbank/tree/master/docs
- http://gbif.blogspot.de/2016/04/updating-gbif-backbone.html
- http://gbif.blogspot.de/2016/08/gbif-backbone-august-2016-update.html
- http://gbif.blogspot.de/2015/03/improving-gbif-backbone-matching.html
