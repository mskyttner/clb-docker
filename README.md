# nub-docker
[![AGPLv3 License](http://img.shields.io/badge/license-AGPLv3-blue.svg) ](https://github.com/mskyttner/nub-docker/blob/master/LICENSE)

Dockerized build for GBIF taxonomy tools: [checklistbank](https://github.com/gbif/checklistbank)

Note: This is Work In Progress - the Makefile will change (and other things) and everything may not work.

# Usage

The `Makefile` provides targets (which are actions, like VERBs), for example you can:

	make  # use to build and launch all services from scratch

... or you can - instead of `make all` - launch the constituent more granular actions step-wise ...

	make init  # to cache/dl files locally
	make build  # to build docker images
	make up  # to start services (currently uses docker-compose)

... or you can release - push images to a remote registry ...

	make release # build and push images to Docker Hub

... or you can debug various services ...

	make connect-db  # get db shell
	make connect-cli  # get shell in checklistbank cli container

... or issue a crawl to get and ingest data into the database ...
	
	make crawl-quick  # for test purposes
	make crawl-dyntaxa  # to load Swedish taxonomy

	# to set up a list of datasets, edit the cli/datasets.txt file
	# use gbif.org to find a dataset, say Dyntaxa and you get src:
	# http://www.gbif.org/dataset/de8934f4-a136-481c-a87a-b0b202b80a31
	# put that identifier into the datasets.txt file or you can do:
	# make crawl key=de8934f4-a136-481c-a87a-b0b202b80a31

The `docker-compose.yml` file provides the various components of the system (NOUNs), for example:

	web
	db

	# core checklistbank services from GBIF
	ws
	admin
	crawler
	importer
	matcher
	normalizer
	analyzer

	# various "infrastructure" services
	proxy 
	dnsdock 
	elk 
	solr
	rabbit
	varnish

The "web" component provides a front or portal to the rest of the services that provide http services or management interfaces, most importantly the various checklistbank services. This component receives traffic from the "proxy" component that routes http traffic from the outside, this is an nginx reverse proxy that provides the only way in from the "outside" (port 80 and 443) so it also provides ssl termination and that way the rest of the services don't have to provide ssl individually. For details, see the "app.conf" file which provides the rules to route the web traffic to the various services available to the outside world.

The core checklistbank services from GBIF includes "ws" with [the GBIF API documented here](http://www.gbif.org/developer/species)... To start a crawl for a dataset you can use make again. See [datasets.txt](cli/datasets.txt) for all registered datasets.

The dnsdock component is used for service discovery from within the host machine, on the "inside" of the software defined network. With this component, it becomes possible for you to reach the various components inside the SDN using commands like "ping rabbitmq.docker". For setting up DNS to work properly on your host machine, please follow the setup instructions at https://github.com/mskyttner/dns-test-docker. The "elk" component is for troubleshooting and looking at all the logs from the various services. This component uses the [ELK stack](http://elk-docker.readthedocs.io/) and is configured for central logging. The CLIs and webservice are logging through the logstash logback appender.

To start all services, test that they run and inspect the logs do:

	make
	make test

# Notes on setting up Docker

The installation requires a docker host under your control, ie a machine with the docker daemon running. 

https://docs.docker.com/engine/installation/

## Alternatives for Mac and Windows: Docker Machine or VirtualBox

You might want to run a local VM if you are on Mac or Windows (at the time of writing Docker for Mac was awefully slow and is not recommended!)

An option is to use VirtualBox on your Mac or Windows machine, install a Linux on it, then install Docker and docker-compose and run everything it there.

Another option is Docker Machine. Please follow https://docs.docker.com/machine/get-started/. If you install it, you can use it to create or start the default virtualbox VM with at least 8g better 12g of memory:

	docker-machine create --driver virtualbox --virtualbox-memory "8192" --virtualbox-cpu-count 2 default
	docker-machine start default

# TODO

 - configure CLB species matching service (nubws)
 - add make target for backbone builds

# Further Reading

Documentation here:

- https://github.com/gbif/checklistbank/tree/master/docs
- http://gbif.blogspot.de/2016/04/updating-gbif-backbone.html
- http://gbif.blogspot.de/2016/08/gbif-backbone-august-2016-update.html
- http://gbif.blogspot.de/2015/03/improving-gbif-backbone-matching.html
