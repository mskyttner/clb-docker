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

# prefer add as we can then cache builds
# WARN! nexus url changes for snapshots with every build!!!
ADD http://repository.gbif.org/service/local/repositories/snapshots/content/org/gbif/checklistbank/checklistbank-cli/2.47-SNAPSHOT/checklistbank-cli-2.47-20161126.122121-6.jar ./checklistbank-cli.jar
# ADD not working with redirects. Use curl instead
# RUN curl -Ls -o checklistbank-cli.jar "http://repository.gbif.org/service/local/artifact/maven/redirect?g=org.gbif.checklistbank&a=checklistbank-cli&r=gbif&c=shaded&v=${CLBVERSION}"

ENTRYPOINT ["/sbin/tini", "--"]
# simple sleep to wait for PSQL and Rabbit server to start
CMD sleep 6 && \
    java -Xmx${MAX_HEAP} -jar $CLI_HOME/checklistbank-cli.jar $COMMAND --log-config $CLI_HOME/logback.xml --conf $CLI_HOME/config/${COMMAND}.yaml
