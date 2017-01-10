FROM java:8-jre-alpine

# you can use docker build -t slugfirst/sluglast:version --build-arg CLBVERSION=2.48
# the default if no build-arg is used will be 2.48

ARG CLBVERSION
ENV CLBVERSION ${CLBVERSION:-2.48}

ENV JAVA_OPTIONS="-Xmx1g"

MAINTAINER mdoering@gbif.org
LABEL org.gbif.checklistbank.version="${CLBVERSION}"
LABEL vendor="GBIF"
LABEL version="${CLBVERSION}"

RUN apk add --update --no-cache tini bash curl

RUN mkdir -p /usr/local/clb/nub-ws/conf && cd /usr/local/clb/nub-ws
WORKDIR /usr/local/clb/nub-ws
ADD application.properties .
ADD conf .

#RUN curl -Ls -o checklistbank-nub-ws.jar "http://repository.gbif.org/service/local/artifact/maven/redirect?g=org.gbif.checklistbank&a=checklistbank-nub-ws&r=gbif&v=${CLBVERSION}"

ADD checklistbank-nub-ws.jar .

ENTRYPOINT ["/sbin/tini", "--"]

# TODO: refactor the sleep statement below
CMD sleep 5 && \
    java -jar checklistbank-nub-ws.jar -conf application.properties -httpPort 9002 -httpAdminPort 9003 -stopSecret stop


