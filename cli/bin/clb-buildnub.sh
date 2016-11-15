#! /bin/bash

. functions.sh
check_user

source ../config.sh
nohup java -Xms6G -Xmx24G -server -XX:+UseNUMA -XX:+UseParallelGC -jar $CRAWLER_HOME/lib/checklistbank-cli.jar nub-build --log-config $CRAWLER_HOME/config/logback-clb-nub.xml --conf $CRAWLER_HOME/config/clb-nub.yaml &
 

