#!/usr/bin/env bash

set -e

PILLAR_COMMAND="./pillar"

if hash "pillar" 2>/dev/null; then
  PILLAR_COMMAND="pillar"
fi

${PILLAR_COMMAND} export "$@"
bash pillarPostExport.sh
