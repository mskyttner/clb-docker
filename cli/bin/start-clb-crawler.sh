#!/usr/bin/env bash


source ../config.sh
echo "Starting clb-crawler"
nohup java -Xmx256M -jar $CLI_HOME/lib/checklistbank-cli.jar crawler --log-config $CLI_HOME/config/logback-clb-crawler.xml --conf $CLI_HOME/config/clb-crawler.yaml &

