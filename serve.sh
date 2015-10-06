#!/usr/bin/env sh

# By Luc 

set -e

PHARO_VM=${PHARO_VM:-./pharo}
PILLAR_IMAGE=${PILLAR_IMAGE:-./Pillar.image}
DIRECTORY_TO_SERVE=`pwd`/book-result/
ST_PATCH_TO_LIST_DIRECTORIES=`pwd`/ZnStaticFileServerDelegate-listDirectories.st

${PHARO_VM} --headless ${PILLAR_IMAGE} eval --no-quit "'${ST_PATCH_TO_LIST_DIRECTORIES}' asFileReference fileIn. (ZnServer startDefaultOn: 1701) delegate: (ZnStaticFileServerDelegate new directory: '${DIRECTORY_TO_SERVE}' asFileReference; yourself)"
