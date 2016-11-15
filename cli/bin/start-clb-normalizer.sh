#! /bin/bash

. functions.sh
check_user

source ../config.sh
nohup java -Xms1G -Xmx6G -server -agentpath:../lib/yjp/libyjpagent.so=port=10001 -XX:+UseConcMarkSweepGC -jar $CRAWLER_HOME/lib/checklistbank-cli.jar normalizer --log-config $CRAWLER_HOME/config/logback-clb-normalizer.xml --conf $CRAWLER_HOME/config/clb-normalizer.yaml &> $CRAWLER_HOME/logs/clb-normalizer_stdout.log &

