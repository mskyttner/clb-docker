FROM java:8-jre-alpine

ENV JAVA_OPTIONS="-Xms256m -Xmx512m -XX:+UseConcMarkSweepGC -XX:CMSInitiatingOccupancyFraction=60"

RUN apk add --update --no-cache tini

RUN mkdir -p /usr/src/myapp/conf && cd /usr/src/myapp
WORKDIR /usr/src/myapp
ADD application.properties .
ADD conf .
ADD checklistbank-ws.jar .

ENTRYPOINT ["/sbin/tini", "--"]

CMD java -jar checklistbank-ws.jar -conf application.properties -httpPort 9000 -httpAdminPort 9001 -stopSecret stop



