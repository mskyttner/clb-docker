#! /bin/bash

. functions.sh
check_user

source ../config.sh
nohup java -Xms256M -Xmx512M -jar $CRAWLER_HOME/lib/checklistbank-cli.jar analysis --log-config $CRAWLER_HOME/config/logback-clb-analysis.xml --conf $CRAWLER_HOME/config/clb-analysis.yaml &> $CRAWLER_HOME/logs/clb-analysis_stdout.log &

