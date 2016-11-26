FROM postgres

LABEL org.gbif.checklistbank.version="${CLBVERSION}"
LABEL vendor="GBIF"
LABEL version="${CLBVERSION}"

WORKDIR /docker-entrypoint-initdb.d
ADD https://raw.githubusercontent.com/gbif/checklistbank/master/docs/schema.sql schema.sql
