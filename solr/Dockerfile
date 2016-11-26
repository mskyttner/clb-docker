FROM solr:5.4.1

LABEL org.gbif.checklistbank.version="${CLBVERSION}"
LABEL vendor="GBIF"
LABEL version="${CLBVERSION}"

#checklistbank-2.46
ENV TAG=master 
ENV SOLRHOME=/opt/solr/server/solr

RUN rmdir $SOLRHOME/mycores && \
    rm -Rf $SOLRHOME/configsets && \
    rm $SOLRHOME/solr.xml && \
    rm $SOLRHOME/zoo.cfg

RUN mkdir -p $SOLRHOME/checklistbank/conf

ADD solr.xml $SOLRHOME/
ADD core.properties $SOLRHOME/checklistbank/
ADD https://raw.githubusercontent.com/gbif/checklistbank/${TAG}/checklistbank-solr/src/main/resources/solr/checklistbank/conf/schema.xml $SOLRHOME/checklistbank/conf/
ADD https://raw.githubusercontent.com/gbif/checklistbank/${TAG}/checklistbank-solr/src/main/resources/solr/checklistbank/conf/solrconfig.xml $SOLRHOME/checklistbank/conf/

WORKDIR $SOLRHOME/lib
RUN curl -Ls -o checklistbank-solr-plugins.jar "http://repository.gbif.org/service/local/artifact/maven/redirect?g=org.gbif.checklistbank&a=checklistbank-solr-plugins&c=shaded&r=gbif&v=${CLBVERSION}"

USER root
RUN chown -R solr:solr $SOLRHOME

WORKDIR /opt/solr
