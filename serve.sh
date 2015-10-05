#!/usr/bin/env sh

# We need an index.html or a directory listing
# By Luc 

set -e

PHARO_VM=${PHARO_VM:-./pharo}
PILLAR_IMAGE=${PILLAR_IMAGE:-./Pillar.image}
DIRECTORY_TO_SERVE=`pwd`/book-result/

${PHARO_VM} --headless ${PILLAR_IMAGE} eval --no-quit "(ZnServer startDefaultOn: 1701) delegate: (ZnStaticFileServerDelegate new directory: '${DIRECTORY_TO_SERVE}' asFileReference; yourself)"
