#!/bin/bash -e
#

for i in $@; do
    echo "Checking version of $i"

    echo -n "	$i "
    unzip -p $i META-INF/MANIFEST.MF | grep Implementation-Version || echo 'n/a'
done
