#!/bin/sh

# intended to be run from the project root. eg:
# mdout/run.sh 000.preface.md

PDHTMLOUT=/tmp/pandocout.html
SEDHTMLOUT=/tmp/sedout.html
DOCXOUT=/tmp/$1.docx

# convert md to html, store in tmp
# NOTE: extension auto_identifiers disabled so that <h2> is plain
pandoc -f markdown-auto_identifiers -t html $1 -o $PDHTMLOUT

# mark tags with special chars
mdout/sed.sh $PDHTMLOUT > $SEDHTMLOUT

# convert html to docx
pandoc -f html -t docx $SEDHTMLOUT -o $DOCXOUT

# open it
open $DOCXOUT
