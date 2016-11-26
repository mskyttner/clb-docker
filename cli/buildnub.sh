#!/usr/bin/env bash

java -Xms1G -Xmx12G -server -XX:+UseNUMA -XX:+UseParallelGC -jar ./checklistbank-cli.jar nub-build --log-config config/logback.xml --conf config/nub.yaml

