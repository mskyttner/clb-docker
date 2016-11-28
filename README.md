# clb-docker
Dockerized build for GBIF taxonomy tools from here: [checklistbank](https://github.com/gbif/checklistbank)

Note: This is Work In Progress - the Makefile will change (and other things) and everything may not work.

# Usage

The Makefile provides targets (VERBs), for example:

	make build  # build docker images
	make up  # start services
	make release # push images to Docker Hub	

To build and start services, for now do:
	
	git clone --depth=1 $REPOSLUG
	cd clb-docker
	make

To start all services and inspect the logs of the checklistbank web service do:

	make up
	docker-compose logs -f clbws

If it started, you should see something like this in the log:

	clbws_1    | 13:37:03.699 [main] INFO org.eclipse.jetty.server.Server - Started @6965ms


## Make admin targets
To start a crawl for a dataset you can use make again. See [datasets.txt](cli/datasets.txt) for all registered datasets

	make crawl key=a739f783-08c1-4d47-a8cc-2e9e6e874202

You can connect to postgres quickly using psql via make:
	connect-db

You can connect to the cli container and run clb shell scripts manually via:
	connect-cli


# Exposed services
The host machine exposes the following ports to the outside world:

 - MACHINE_IP:80 [CLB webservices](http://www.gbif.org/developer/species) exposed through varnish, caching responses for 1h
 - MACHINE_IP:5432 Postgres
 - MACHINE_IP:5601 [Kibana logs](http://elk-docker.readthedocs.io/)
 - MACHINE_IP:8983 Solr
 - MACHINE_IP:9000 [CLB webservices](http://www.gbif.org/developer/species), directly
 - MACHINE_IP:15672 RabbitMQ management plugin

 
# TODO

 - configure CLB species matching service (nubws)
 - add make target for backbone builds


# Further Reading

Documentation here:

- https://github.com/gbif/checklistbank/tree/master/docs
- http://gbif.blogspot.de/2016/04/updating-gbif-backbone.html
- http://gbif.blogspot.de/2016/08/gbif-backbone-august-2016-update.html
- http://gbif.blogspot.de/2015/03/improving-gbif-backbone-matching.html
