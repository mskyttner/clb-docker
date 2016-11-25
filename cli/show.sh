#!/usr/bin/env bash


source ../config.sh
java -jar $CLI_HOME/lib/checklistbank-cli.jar show --file tree.txt --log-config $CLI_HOME/config/logback-clb-admin.xml --conf $CLI_HOME/config/clb-show.yaml ${*} 

