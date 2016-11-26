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

# ELK

The [ELK stack](http://elk-docker.readthedocs.io/) is configured for central logging.
The CLIs and webservice are logging through the logstash logback appender.
You can access kibana to search for logs on port 5601, e.g. http://192.168.99.100:5601/ on Mac, or 

# Ideas / Discussion

- Regarding dl of relevant checklists/classficiations, such as NCBI, what are the urls for those? 

## Low tech approach to maintain local taxonomy or "storage classification" checklist

- Load data from text (.yaml?) file into clb, could be interim stored in redis
- Build a ui to allow export in that format
- Schedule daily(?) upload to checklistbank via text file generated from taxonomy ui

# Further Reading

Documentation here:

- https://github.com/gbif/checklistbank/tree/master/docs
- http://gbif.blogspot.de/2016/04/updating-gbif-backbone.html
- http://gbif.blogspot.de/2016/08/gbif-backbone-august-2016-update.html
- http://gbif.blogspot.de/2015/03/improving-gbif-backbone-matching.html
