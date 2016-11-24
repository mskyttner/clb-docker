#!/usr/bin/env bash


source ../config.sh
java -jar $CLI_HOME/lib/checklistbank-cli.jar shell --log-config $CLI_HOME/config/logback-clb-admin.xml --conf $CLI_HOME/config/clb-shell.yaml ${*} 

