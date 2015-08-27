#!/usr/bin/env bash

rm -f pillarPostExport.sh 2>&1
./pillar export
test -f pillarPostExport.sh && bash pillarPostExport.sh
echo Done
