#!/usr/bin/env bash

# this version relies on \documentclass[handout]beamer

function clean() {
	rm -fr Slides/Handout
}

function cleanAndExitIfError() {
	if [[ $1 -ne 0 ]]; then
	  echo $2
	  clean
	  exit 1
	fi
}

#----------------------------------------------
# cleaning
#----------------------------------------------

clean
rm -fr book-result/Slides/Handout

# duplicate source files because Pillar would overwrite real slides in book-result
mkdir Slides/Handout
cp -f Slides/4-Done/*.pillar Slides/Handout/

#----------------------------------------------
# copying .pillar with -Handout suffix
#----------------------------------------------

cd Slides/Handout/
for f in *; do
  mv "$f" "${f%.*}-Handout.${f##*.}"
done
cd ../..

#----------------------------------------------
# compiling pillar files to handout pdfs
#----------------------------------------------

PILLAR_FILES=Slides/Handout/*.pillar
# PILLAR_FILES="Slides/Handout/Basic-ArraySetOrderedCollection*.pillar \
	# Slides/Handout/Basic-BooleansAndCondition*.pillar"

for file in $PILLAR_FILES
do
	# ./compile.sh --to='Beamer43' $file
	./compile.sh --to='BeamerHandout' $file
done

#----------------------------------------------
# special processing for .key or .ppt slides
#----------------------------------------------

OTHER_PDFs="Slides/4-Done/Intro-ObjectivesMooc.pdf \
	Slides/4-Done/Intro-WhatIs.pdf \
	Slides/4-Done/Intro-Vision.pdf"

pdfnup --batch --a4paper --keepinfo --nup 2x4 --delta "6mm 6mm" --scale 0.98 --frame true  --no-landscape --suffix Handout -o book-result/Slides/Handout $OTHER_PDFs 2>&1 1>/dev/null

#----------------------------------------------
# Generating Handout.pdf
#----------------------------------------------

cp -f Handout/handout.tex book-result/Slides/Handout/

texfot latexmk -pdf -cd book-result/Slides/Handout/handout.tex
# cleanAndExitIfError $? "Compilation of handout.tex FAILED"

latexmk -c -cd book-result/Slides/Handout/handout.tex

clean

