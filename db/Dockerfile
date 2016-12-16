FROM postgres

LABEL org.gbif.checklistbank.version="${CLBVERSION}"
LABEL vendor="GBIF"
LABEL version="${CLBVERSION}"

WORKDIR /docker-entrypoint-initdb.d
ADD schema.sql .
