#!/usr/bin/env bash


source ../config.sh
nohup java -Xms2G -Xmx12G -server -XX:+UseNUMA -XX:+UseParallelGC -jar $CLI_HOME/lib/checklistbank-cli.jar nub-build --log-config $CLI_HOME/config/logback-clb-nub.xml --conf $CLI_HOME/config/clb-nub.yaml &
 

