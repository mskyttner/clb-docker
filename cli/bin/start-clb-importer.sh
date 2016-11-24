#! /bin/bash


source ../config.sh
nohup java -Xms256M -Xmx1G -server -XX:+UseConcMarkSweepGC -jar $CLI_HOME/lib/checklistbank-cli.jar importer --log-config $CLI_HOME/config/logback-clb-importer.xml --conf $CLI_HOME/config/clb-importer.yaml &> $CLI_HOME/logs/clb-importer_stdout.log &  

