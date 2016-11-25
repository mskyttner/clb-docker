#!/usr/bin/env bash

java -jar ./checklistbank-cli.jar admin --log-config ./logback.xml --conf config/clb-admin.yaml --operation $1 ${*:2} 
