FROM java:8-jre-alpine

ENV JAVA_OPTIONS="-Xms256m -Xmx512m -XX:+UseConcMarkSweepGC -XX:CMSInitiatingOccupancyFraction=60"

RUN apk add --update --no-cache tini bash

RUN mkdir -p /usr/src/clb && \
	cd /usr/src/clb && \
	mkdir -p bin lib logs neo dwca

WORKDIR /usr/src/clb

ADD datasets.txt .
ADD config.sh .
ADD bin bin
ADD config config
ADD lib lib
ADD checklistbank-cli.jar lib

WORKDIR /usr/src/clb/bin
ENTRYPOINT ["/sbin/tini", "--"]
CMD ./start-clb.sh



