#!/usr/bin/env bash


PILLAR_FILES=Slides/4-Done/*.pillar

for file in $PILLAR_FILES
do
	./compile.sh --to='Beamer43' $file
done

rm -fr book-result/Handout
mkdir book-result/Handout
cp -f Handout/handout.tex book-result/Handout/

PDF_FILES=book-result/Slides/4-Done/*.pdf

for file in $PDF_FILES
do
	pdfnup --a4paper --keepinfo --nup 2x4 --delta "2mm 12mm" --frame true --scale 0.92 --no-landscape --suffix 2x4 -o book-result/Handout $file
done

cd book-result/Handout

pdflatex -halt-on-error -file-line-error -interaction batchmode handout.tex 2>&1 1>/dev/null
ret=$?
if [[ $ret -ne 0 ]]; then
  cat handout.log
  echo "Can't generate the PDF!"
  exit 1
fi

pdflatex -halt-on-error -file-line-error -interaction batchmode handout.tex 2>&1 1>/dev/null
ret=$?
if [[ $ret -ne 0 ]]; then
  cat handout.log
  echo "Can't generate the PDF!"
  exit 1
fi