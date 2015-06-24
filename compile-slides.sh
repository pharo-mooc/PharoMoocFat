#!/usr/bin/env bash

SLIDES_DIRECTORY="./Slides/3-ToReview"

set -e

PILLAR_COMMAND="./pillar"

if hash "pillar" 2>/dev/null; then
  PILLAR_COMMAND="pillar"
fi

function pillar_one() {
  input="$1"
  $PILLAR_COMMAND export --to='Beamer' "$input"
  $PILLAR_COMMAND export --to='DeckJS' "$input"
}

function mypdflatex() {
  pillar_file="$1"
  basename=${pillar_file%.*}

  echo "Compiling PDF from $pillar_file..."
  pdflatex -halt-on-error -file-line-error -interaction batchmode "$basename" 2>&1 1>/dev/null
  ret=$?
  if [[ $ret -ne 0 ]]; then
    cat $basename.log
    echo "Can't generate the PDF!"
    exit 1
  fi
}

function produce_pdf() {
  dir="$1"
  pillar_file="$2"

  cd "$dir"         # e.g., cd Zinc/
  mypdflatex "$pillar_file" && mypdflatex "$pillar_file"
  cd -
}

function compile_chapters() {
  chapters=$($PILLAR_COMMAND show inputFiles 2>/dev/null)

  for chapter in $chapters; do
    echo =========================================================
    echo COMPILING $chapter
    echo =========================================================

    # e.g., chapter = Zinc/Zinc.pillar

    pillar_file=$(basename $chapter) # e.g., Zinc.pillar
    dir=$(dirname $chapter) # e.g., Zinc

    produce_pdf "${dir}" "${pillar_file}"
  done
}

function compile_latex_book() {
  echo =========================================================
  echo COMPILING Book
  echo =========================================================
  cd book-result
  produce_pdf . *.tex
}

function latex_enabled() {
  hash pdflatex 2>/dev/null
}

function generate_slide() {
    file="$1"
    echo "Generating slides for "$file
    pillar_one $file
    pillar_file=$(basename "$file") # e.g., Zinc.pillar
    if latex_enabled; then
        produce_pdf "$SLIDES_DIRECTORY" "${pillar_file}"
    fi
}

if [[ $# -eq 1 ]]; then
    generate_slide "$1"
else
    for file in $SLIDES_DIRECTORY/*.pillar; do
        generate_slide $file
    done
fi

echo 'Done'
