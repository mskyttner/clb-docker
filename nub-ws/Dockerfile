FROM java:8-jre-alpine

ENV JAVA_OPTIONS="-Xmx1g"
ENV CLB_VERSION=2.47-SNAPSHOT

MAINTAINER mdoering@gbif.org
LABEL org.gbif.checklistbank.version="$CLB_VERSION"
LABEL vendor="GBIF"
LABEL version="0.1"

RUN apk add --update --no-cache tini curl

RUN mkdir -p /usr/local/clb/nub-ws/conf && cd /usr/local/clb/nub-ws
WORKDIR /usr/local/clb/nub-ws
ADD application.properties .
ADD conf .

RUN curl -Ls -o checklistbank-nub-ws.jar "http://repository.gbif.org/service/local/artifact/maven/redirect?g=org.gbif.checklistbank&a=checklistbank-nub-ws&r=gbif&v=${CLB_VERSION}"

ENTRYPOINT ["/sbin/tini", "--"]

CMD sleep 5 && \
    java -jar checklistbank-nub-ws.jar -conf application.properties -httpPort 9002 -httpAdminPort 9003 -stopSecret stop



