#!/usr/bin/env bash


source ../config.sh
echo "Starting clb-importer"
nohup java -Xms256M -Xmx1G -server -XX:+UseConcMarkSweepGC -jar $CLI_HOME/lib/checklistbank-cli.jar importer --log-config $CLI_HOME/config/logback-clb-importer.xml --conf $CLI_HOME/config/clb-importer.yaml &  

