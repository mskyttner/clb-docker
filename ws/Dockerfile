FROM java:8-jre-alpine

ENV JAVA_OPTIONS="-Xmx512m"
ENV CLBVERSION=2.47-SNAPSHOT

MAINTAINER mdoering@gbif.org
LABEL org.gbif.checklistbank.version="${CLBVERSION}"
LABEL vendor="GBIF"
LABEL version="${CLBVERSION}"

RUN apk add --update --no-cache tini bash curl

RUN mkdir -p /etc/clb
ADD default.vcl /etc/clb/

RUN mkdir -p /usr/local/clb/ws/conf && cd /usr/local/clb/ws
WORKDIR /usr/local/clb/ws
ADD application.properties .
ADD conf .

RUN curl -Ls -o checklistbank-ws.jar "http://repository.gbif.org/service/local/artifact/maven/redirect?g=org.gbif.checklistbank&a=checklistbank-ws&r=gbif&v=${CLBVERSION}"

ENTRYPOINT ["/sbin/tini", "--"]

CMD sleep 8 && \
    java -jar checklistbank-ws.jar -conf application.properties -httpPort 9000 -httpAdminPort 9001 -stopSecret stop



