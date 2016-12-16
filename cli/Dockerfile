FROM java:8-jre-alpine

# CLBVERSION to be configured outside
ENV CLBVERSION 2.47-SNAPSHOT

MAINTAINER mdoering@gbif.org
LABEL org.gbif.checklistbank.version="${CLBVERSION}"
LABEL vendor="GBIF"
LABEL version="${CLBVERSION}"

ENV COMMAND analysis
ENV MAX_HEAP 256M
ENV JAVA_OPTIONS="-Xmx${MAX_HEAP} -XX:+UseConcMarkSweepGC -XX:CMSInitiatingOccupancyFraction=60"
ENV CLI_HOME /usr/local/clb/cli

RUN apk add --update --no-cache tini bash curl

RUN mkdir -p $CLI_HOME && \
	cd $CLI_HOME && \
	mkdir -p config neo dwca

ADD datasets.txt /usr/local/clb/data/

WORKDIR $CLI_HOME
ADD *.sh $CLI_HOME/
ADD *.xml $CLI_HOME/
ADD config config

ADD ./wait-for-it.sh $CLI_HOME/
ADD ./checklistbank-cli.jar .

ENTRYPOINT ["/sbin/tini", "--"]

CMD ./wait-for-it.sh db:5432 -t 0 -- \
	./wait-for-it.sh solr:8983 -t 0 -- \
	./wait-for-it.sh elk:5601 -t 0 -- \
	./wait-for-it.sh rabbit:15672 -t 0 -- \
	java -Xmx${MAX_HEAP} -jar $CLI_HOME/checklistbank-cli.jar $COMMAND \
	--log-config $CLI_HOME/logback.xml \
	--conf $CLI_HOME/config/${COMMAND}.yaml
