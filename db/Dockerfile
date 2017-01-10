FROM postgres

ARG CLBVERSION
ENV CLBVERSION ${CLBVERSION:-2.48}

LABEL org.gbif.checklistbank.version="${CLBVERSION}"
LABEL vendor="GBIF"
LABEL version="${CLBVERSION}"

WORKDIR /docker-entrypoint-initdb.d
ADD schema.sql .
