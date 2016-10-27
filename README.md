# nub-docker

Dockerized build for GBIF taxonomy tools from here: [checklistbank](https://github.com/gbif/checklistbank)

Note: This is Work In Progress - the Makefile will change (and other things) and everything may not work.

# Usage

The Makefile provides targets (VERBs), for example:

	make init  # cache/dl files
	make build  # build using maven
	make up  # start services
	make release # push image to Docker Hub	

The docker-compose.yml file provides components (NOUNs), for example:

	postgres
	neo4j
	zookeeper
	solr
	nginx reverse proxy

# TODO

- deploy build artifacts (.jar)
- add zookeeper?
- config rabbitmq
- load data from DarwinCare Archives using the cli?
- automate subset extraction from http://dl.dropbox.com/u/523458/Dyntaxa/Archive.zip (dataset from 2012-March-08)

# Ideas / Discussion

- remove unneeded components
- make it less dependant on some GBIF components (zookeeper)
- you can use NCBI 
- can evolve fuzzy search matching
- name based -- doesn't manage "taxon concepts" in the same way as Dyntaxa, PlutoF -- has preferred name...
- 4 times a year generate the backbone approx 40 sources CoL is the first one others are merged into that one automatically

## Low tech approach to maintain local taxonomy

- Load data from text file, version with git, could get some workflow up in a cuople of months?
- schedule upload to checklistbank
- build a ui to allow export in that format



# Known issues

One test fails - seems to require some "rabbitmq" config that currently fails:

- https://github.com/mskyttner/nub-docker/issues/1

# Further Reading

Documentation here:

- https://github.com/gbif/checklistbank/tree/master/docs
- http://gbif.blogspot.de/2016/04/updating-gbif-backbone.html
- http://gbif.blogspot.de/2016/08/gbif-backbone-august-2016-update.html
- http://gbif.blogspot.de/2015/03/improving-gbif-backbone-matching.html
