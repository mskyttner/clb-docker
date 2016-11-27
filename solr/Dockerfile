FROM solr:5.4.1

LABEL org.gbif.checklistbank.version="${CLBVERSION}"
LABEL vendor="GBIF"
LABEL version="${CLBVERSION}"

# CLBVERSION to be configured outside
ENV CLBVERSION 2.47-SNAPSHOT
#checklistbank-2.46
ENV TAG=master 
ENV SOLRHOME=/opt/solr/server/solr

RUN rmdir $SOLRHOME/mycores && \
    rm -Rf $SOLRHOME/configsets && \
    rm $SOLRHOME/solr.xml && \
    rm $SOLRHOME/zoo.cfg

RUN mkdir -p $SOLRHOME/checklistbank/conf

USER root

ADD solr.xml $SOLRHOME/
ADD core.properties $SOLRHOME/checklistbank/
WORKDIR $SOLRHOME/checklistbank/conf/
ADD https://raw.githubusercontent.com/gbif/checklistbank/${TAG}/checklistbank-solr/src/main/resources/solr/checklistbank/conf/schema.xml .
ADD https://raw.githubusercontent.com/gbif/checklistbank/${TAG}/checklistbank-solr/src/main/resources/solr/checklistbank/conf/solrconfig.xml .
ADD https://raw.githubusercontent.com/gbif/checklistbank/${TAG}/checklistbank-solr/src/main/resources/solr/checklistbank/conf/protwords.txt .
ADD https://raw.githubusercontent.com/gbif/checklistbank/${TAG}/checklistbank-solr/src/main/resources/solr/checklistbank/conf/stopwords.txt .
ADD https://raw.githubusercontent.com/gbif/checklistbank/${TAG}/checklistbank-solr/src/main/resources/solr/checklistbank/conf/synonyms.txt .

WORKDIR $SOLRHOME/lib
RUN curl -Ls -o checklistbank-solr-plugins.jar "http://repository.gbif.org/service/local/artifact/maven/redirect?g=org.gbif.checklistbank&a=checklistbank-solr-plugins&c=shaded&r=gbif&v=${CLBVERSION}"
# update solrconfig
RUN sed -i '5 i\
  <lib dir="/opt/solr/server/solr/lib" regex=".*\.jar" />' $SOLRHOME/checklistbank/conf/solrconfig.xml
RUN sed -i '/^.*lockType.*$/d' $SOLRHOME/checklistbank/conf/solrconfig.xml

RUN chown -R solr:solr $SOLRHOME

WORKDIR /opt/solr
