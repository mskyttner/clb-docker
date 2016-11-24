#!/usr/bin/env bash


source ../config.sh
java -jar $CLI_HOME/lib/checklistbank-cli.jar admin --log-config $CLI_HOME/config/logback-clb-admin.xml --conf $CLI_HOME/config/clb-admin.yaml --operation $1 ${*:2} 

