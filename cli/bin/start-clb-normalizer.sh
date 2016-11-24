#! /bin/bash


source ../config.sh
nohup java -Xms512M -Xmx2G -server -XX:+UseConcMarkSweepGC -jar $CLI_HOME/lib/checklistbank-cli.jar normalizer --log-config $CLI_HOME/config/logback-clb-normalizer.xml --conf $CLI_HOME/config/clb-normalizer.yaml &> $CLI_HOME/logs/clb-normalizer_stdout.log &

