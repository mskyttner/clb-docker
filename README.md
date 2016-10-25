# nub-docker

Dockerized build for GBIF taxonomy tools - [checklistbank](https://github.com/gbif/checklistbank)

Beware - this is work in progress!

# Usage

The Makefile provides targets:

	make init  # cache/dl files
	make build  # build using maven
	make up  # start services
	make release # push image to Docker Hub
	
Note: This is Work In Progress - the Makefile will change and everything may not work.

# TODO

- deploy build artefacts (.jar)
- load data from DarwinCare Archives using the cli?
- automate subset extraction from http://dl.dropbox.com/u/523458/Dyntaxa/Archive.zip (dataset from 2012-March-08)

# Further Reading

Documentation here:

- https://github.com/gbif/checklistbank/tree/master/docs
- http://gbif.blogspot.de/2016/04/updating-gbif-backbone.html
- http://gbif.blogspot.de/2016/08/gbif-backbone-august-2016-update.html
http://gbif.blogspot.de/2015/03/improving-gbif-backbone-matching.html

# Known issues

One test fails - seems to require some "rabbitmq" config that currently fails:

- https://github.com/mskyttner/nub-docker/issues/1
