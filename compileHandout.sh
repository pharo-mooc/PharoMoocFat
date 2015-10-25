#!/usr/bin/env bash

# this version relies on \documentclass[handout]{beamer} for beamer slides
# relies on pdfnup for other slides

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

mkdir Slides/Handout

#----------------------------------------------
# duplicate source files because Pillar would overwrite real slides in book-result
#----------------------------------------------

PILLAR_FILES="Slides/Week1/C019SD-W1S05-PharoModelInaNushell.pillar \
Slides/Week1/C019SD-W1S06-PharoSyntaxInANutshell.pillar \
Slides/Week2/C019SD-W2S01-Messages.pillar \
Slides/Week2/C019SD-W2S02-Messages-ForTheJavaProgrammers.pillar \
Slides/Week2/C019SD-W2S03-Messages-Precedence.pillar \
Slides/Week2/C019SD-W2S04-Messages-Sequence.pillar \
Slides/Week2/C019SD-W2S07-Blocks.pillar \
Slides/Week2/C019SD-W2S08-Blocks-Loops.pillar \
Slides/Week2/C019SD-W2S09-Loops.pillar \
Slides/Week2/C019SD-W2S10-BooleansAndCondition.pillar \
Slides/Week2/C019SD-W2S11-ParenthesisVsSquareBrackets.pillar \
Slides/Week2/C019SD-W2S12-Design-EssenceOfDispatchExo.pillar"

cp -f ${PILLAR_FILES} Slides/Handout/

#----------------------------------------------
# copying .pillar with -Handout suffix
#----------------------------------------------

# cd Slides/Handout/
# for f in *; do
#   mv "$f" "${f%.*}-Handout.${f##*.}"
# done
# cd ../..

#----------------------------------------------
# compiling pillar files to handout pdfs
#----------------------------------------------

PILLAR_FILES=Slides/Handout/*.pillar

for file in $PILLAR_FILES
do
	echo
	./compile.sh --to='BeamerHandout' $file
	cleanAndExitIfError $? "Pillar compilation of $file FAILED"
done

#----------------------------------------------
# special processing for .key or .ppt slides
#----------------------------------------------

OTHER_PDFs="Slides/Week1/C019SD-W1S01-ObjectivesMooc.pdf \
	Slides/Week1/C019SD-W1S02-WhatIsPharo.pdf \
	Slides/Week1/C019SD-W1S03-PharoVision.pdf"

pdfnup --batch --a4paper --keepinfo --nup 2x4 --delta "6mm 6mm" --scale 0.98 --frame true  --no-landscape -o book-result/Slides/Handout/ $OTHER_PDFs 2>&1 1>/dev/null
cleanAndExitIfError $? "Pdfnup of PDF FAILED"
	
for file in $OTHER_PDFs
do	
	mv -f book-result/Slides/Handout/`basename $file .pdf`-nup.pdf book-result/Slides/Handout/`basename $file` 
	cleanAndExitIfError $? "copying Handouts FAILED"
done

#----------------------------------------------
# Generating Handout.pdf
#----------------------------------------------

cp -f Handout/handout.tex book-result/Slides/Handout/

texfot latexmk -pdf -cd book-result/Slides/Handout/handout.tex
cleanAndExitIfError $? "Compilation of handout.tex FAILED"

clean

