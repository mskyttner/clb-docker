FROM java:8-jre-alpine

ARG CLBVERSION
ENV CLBVERSION ${CLBVERSION:-2.48}

ENV JAVA_OPTIONS="-Xmx512m"


MAINTAINER mdoering@gbif.org
LABEL org.gbif.checklistbank.version="${CLBVERSION}"
LABEL vendor="GBIF"
LABEL version="${CLBVERSION}"

RUN apk add --update --no-cache tini bash curl

RUN mkdir -p /usr/local/clb/ws/conf && cd /usr/local/clb/ws
WORKDIR /usr/local/clb/ws
ADD application.properties .
ADD conf .

ADD wait-for-it.sh .
ADD ./checklistbank-ws.jar .

ENTRYPOINT ["/sbin/tini", "--"]

RUN mkdir -p /etc/clb
ADD default.vcl /etc/clb/
VOLUME ["/etc/clb"]

CMD ./wait-for-it.sh db:5432 -t 0 -- \
	./wait-for-it.sh elk:5601 -t 0 -- \
	./wait-for-it.sh rabbit:15672 -t 0 -- \
	./wait-for-it.sh solr:8983 -t 0 -- \
	java -jar checklistbank-ws.jar \
	-conf application.properties \
	-httpPort 9000 \
	-httpAdminPort 9001 \
	-stopSecret stop

