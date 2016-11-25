#!/usr/bin/env bash

java -jar ./checklistbank-cli.jar shell --log-config ./logback.xml --conf config/shell.yaml ${*} 

