FROM solr:5.4.1

ARG CLBVERSION
ENV CLBVERSION ${CLBVERSION:-2.48}

ENV TAG master 
ENV SOLRHOME /opt/solr/server/solr

LABEL org.gbif.checklistbank.version="${CLBVERSION}" \
	vendor="GBIF" \
	version="${CLBVERSION}"

RUN rmdir $SOLRHOME/mycores && \
    rm -Rf $SOLRHOME/configsets && \
    rm $SOLRHOME/solr.xml && \
    rm $SOLRHOME/zoo.cfg

RUN mkdir -p $SOLRHOME/checklistbank/conf

USER root

ADD solr.xml $SOLRHOME/
ADD core.properties $SOLRHOME/checklistbank/
WORKDIR $SOLRHOME/checklistbank/conf/
ADD ./schema.xml .
ADD ./solrconfig.xml .
ADD ./protwords.txt .
ADD ./stopwords.txt .
ADD ./synonyms.txt .

WORKDIR $SOLRHOME/lib
ADD ./checklistbank-solr-plugins.jar .

# update solrconfig
RUN sed -i '5 i\
  <lib dir="/opt/solr/server/solr/lib" regex=".*\.jar" />' $SOLRHOME/checklistbank/conf/solrconfig.xml
RUN sed -i '/^.*lockType.*$/d' $SOLRHOME/checklistbank/conf/solrconfig.xml

RUN chown -R solr:solr $SOLRHOME

WORKDIR /opt/solr
