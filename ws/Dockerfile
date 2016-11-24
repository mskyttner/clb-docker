FROM java:8-jre-alpine

ENV JAVA_OPTIONS="-Xms256m -Xmx512m -XX:+UseConcMarkSweepGC -XX:CMSInitiatingOccupancyFraction=60"

RUN apk add --update --no-cache tini

RUN mkdir -p /usr/local/clb/cli/conf && cd /usr/local/clb/cli
WORKDIR /usr/local/clb/cli
ADD application.properties .
ADD conf .
ADD checklistbank-ws.jar .

ENTRYPOINT ["/sbin/tini", "--"]

CMD java -jar checklistbank-ws.jar -conf application.properties -httpPort 9000 -httpAdminPort 9001 -stopSecret stop



