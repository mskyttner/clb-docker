FROM java:8-jre-alpine

ENV JAVA_OPTIONS="-Xmx512m"
ENV CLB_VERSION=2.47-SNAPSHOT

MAINTAINER mdoering@gbif.org
LABEL org.gbif.checklistbank.version="$CLB_VERSION"
LABEL vendor="GBIF"
LABEL version="0.1"

RUN apk add --update --no-cache tini curl

RUN mkdir -p /usr/local/clb/ws/conf && cd /usr/local/clb/ws
WORKDIR /usr/local/clb/ws
ADD application.properties .
ADD conf .

RUN curl -Ls -o checklistbank-ws.jar "http://repository.gbif.org/service/local/artifact/maven/redirect?g=org.gbif.checklistbank&a=checklistbank-ws&r=gbif&v=${CLB_VERSION}"

ENTRYPOINT ["/sbin/tini", "--"]

#CMD ./wait-for-it.sh db:5432 -- \
#	./wait-for-it.sh rabbit:15672 -- \
#	./wait-for-it.sh solr:8983 -- \
#    java -jar checklistbank-ws.jar \
#	-conf application.properties \
#	-httpPort 9000 \
#	-httpAdminPort 9001 \
#	-stopSecret stop	

CMD sleep 5 && \
    java -jar checklistbank-ws.jar -conf application.properties -httpPort 9000 -httpAdminPort 9001 -stopSecret stop



