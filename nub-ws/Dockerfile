FROM java:8-jre-alpine

ENV JAVA_OPTIONS="-Xmx1g"
ENV CLBVERSION=2.47-SNAPSHOT

MAINTAINER mdoering@gbif.org
LABEL org.gbif.checklistbank.version="${CLBVERSION}"
LABEL vendor="GBIF"
LABEL version="${CLBVERSION}"

RUN apk add --update --no-cache tini curl

RUN mkdir -p /usr/local/clb/nub-ws/conf && cd /usr/local/clb/nub-ws
WORKDIR /usr/local/clb/nub-ws
ADD application.properties .
ADD conf .

RUN curl -Ls -o checklistbank-nub-ws.jar "http://repository.gbif.org/service/local/artifact/maven/redirect?g=org.gbif.checklistbank&a=checklistbank-nub-ws&r=gbif&v=${CLBVERSION}"

ENTRYPOINT ["/sbin/tini", "--"]

CMD sleep 5 && \
    java -jar checklistbank-nub-ws.jar -conf application.properties -httpPort 9002 -httpAdminPort 9003 -stopSecret stop



