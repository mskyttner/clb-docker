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

To build, for now do:
	
	git clone --depth=1 $REPOSLUG
	cd nub-docker
	make network
	make build


# TODO

- deploy build artifacts (.jar) or perhaps just provide a "cli" container that allows for automated workflows
- add zookeeper? what is it needed for? see https://github.com/gbif/checklistbank/blob/master/docs/INDEXING.md#messaging-flow
- config rabbitmq properly
- load data from DarwinCare Archives using the cli?
- automate subset extraction from http://dl.dropbox.com/u/523458/Dyntaxa/Archive.zip (dataset from 2012-March-08)

# Ideas / Discussion

- Regarding dl of relevant checklists/classficiations, such as NCBI, what are the urls for those? 

## Low tech approach to maintain local taxonomy or "storage classification" checklist

- Load data from text file in clb, could be versioned with git
- Build a ui to allow export in that format
- Schedule daily(?) upload to checklistbank via text file generated from taxonomy ui

# Known issues

One test fails - seems to require some "rabbitmq" config that currently fails:

- https://github.com/mskyttner/nub-docker/issues/1

# Further Reading

Documentation here:

- https://github.com/gbif/checklistbank/tree/master/docs
- http://gbif.blogspot.de/2016/04/updating-gbif-backbone.html
- http://gbif.blogspot.de/2016/08/gbif-backbone-august-2016-update.html
- http://gbif.blogspot.de/2015/03/improving-gbif-backbone-matching.html
