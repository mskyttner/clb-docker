#!/bin/bash -e

source ../config.sh
source update-functions.sh

update-cli checklistbank-cli.jar "http://repository.gbif.org/service/local/artifact/maven/redirect?g=org.gbif.checklistbank&a=checklistbank-cli&r=gbif&c=shaded&v=$CHECKLISTBANK"
