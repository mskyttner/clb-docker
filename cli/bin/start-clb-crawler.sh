#! /bin/bash


source ../config.sh
nohup java -Xmx256M -jar $CLI_HOME/lib/checklistbank-cli.jar crawler --log-config $CLI_HOME/config/logback-clb-crawler.xml --conf $CLI_HOME/config/clb-crawler.yaml &> $CLI_HOME/logs/clb-crawler_stdout.log &

