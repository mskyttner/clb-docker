#! /bin/bash

. functions.sh
check_user

source ../config.sh
nohup java -Xms1G -Xmx12G -server -XX:+UseConcMarkSweepGC -jar $CRAWLER_HOME/lib/checklistbank-cli.jar dataset-matcher --log-config $CRAWLER_HOME/config/logback-clb-matcher.xml --conf $CRAWLER_HOME/config/clb-matcher.yaml &> $CRAWLER_HOME/logs/clb-matcher_stdout.log &

