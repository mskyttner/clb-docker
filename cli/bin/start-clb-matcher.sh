#! /bin/bash


source ../config.sh
nohup java -Xms512M -Xmx4G -server -XX:+UseConcMarkSweepGC -jar $CLI_HOME/lib/checklistbank-cli.jar dataset-matcher --log-config $CLI_HOME/config/logback-clb-matcher.xml --conf $CLI_HOME/config/clb-matcher.yaml &> $CLI_HOME/logs/clb-matcher_stdout.log &

