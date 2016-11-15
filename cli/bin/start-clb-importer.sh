#! /bin/bash

. functions.sh
check_user

source ../config.sh
nohup java -Xms512M -Xmx3G -server -agentpath:../lib/yjp/libyjpagent.so=port=10002 -XX:+UseConcMarkSweepGC -jar $CRAWLER_HOME/lib/checklistbank-cli.jar importer --log-config $CRAWLER_HOME/config/logback-clb-importer.xml --conf $CRAWLER_HOME/config/clb-importer.yaml &> $CRAWLER_HOME/logs/clb-importer_stdout.log &  

