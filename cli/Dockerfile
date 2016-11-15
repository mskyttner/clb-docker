FROM java:8-jre-alpine

ENV JAVA_OPTIONS="-Xms256m -Xmx512m -XX:+UseConcMarkSweepGC -XX:CMSInitiatingOccupancyFraction=60"

RUN apk add --update --no-cache tini bash

# use a user called "crap" if possible

RUN mkdir -p /usr/src/myapp && \
	cd /usr/src/myapp && \
	mkdir -p bin lib logs neo storage/dwca

WORKDIR /usr/src/myapp

ADD config.sh .
ADD bin bin
ADD config config
ADD lib lib
ADD checklistbank-cli.jar lib

WORKDIR /usr/src/myapp/bin
ENTRYPOINT ["/sbin/tini", "--"]
CMD ./start-clb.sh



