#! /bin/bash


source ../config.sh
nohup java -Xmx256M -jar $CLI_HOME/lib/checklistbank-cli.jar analysis --log-config $CLI_HOME/config/logback-clb-analysis.xml --conf $CLI_HOME/config/clb-analysis.yaml &> $CLI_HOME/logs/clb-analysis_stdout.log &

