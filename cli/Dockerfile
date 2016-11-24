FROM java:8-jre-alpine

ENV CLB_VERSION 2.47-SNAPSHOT

MAINTAINER mdoering@gbif.org
LABEL org.gbif.checklistbank.version="$CLB_VERSION"
LABEL vendor="GBIF"
LABEL version="0.1"

ENV COMMAND analysis
ENV MAX_HEAP 256M
ENV JAVA_OPTIONS="-Xmx${MAX_HEAP} -XX:+UseConcMarkSweepGC -XX:CMSInitiatingOccupancyFraction=60"
ENV CLI_HOME /usr/local/clb/cli

RUN apk add --update --no-cache tini bash

RUN mkdir -p $CLI_HOME && \
	cd $CLI_HOME && \
	mkdir -p bin config neo dwca

WORKDIR $CLI_HOME

ADD datasets.txt .
ADD bin bin
ADD config config
RUN curl -Ls -o checklistbank-cli.jar http://repository.gbif.org/service/local/artifact/maven/redirect?g=org.gbif.checklistbank&a=checklistbank-cli&r=gbif&c=shaded&v=${CLB_VERSION}

ENTRYPOINT ["/sbin/tini", "--"]
CMD java -Xmx${MAX_HEAP} -jar $CLI_HOME/checklistbank-cli.jar $COMMAND --log-config $CLI_HOME/config/logback-${COMMAND}.xml --conf $CLI_HOME/config/${COMMAND}.yaml
