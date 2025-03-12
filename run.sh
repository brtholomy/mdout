#!/bin/bash

# intended to be run from the project root. eg:
# mdout/run.sh 000.preface.md

RUNIN=$1
PREPOUT=/tmp/prepout.md
PDHTMLOUT=/tmp/pandocout.html
SEDHTMLOUT=/tmp/sedout.html
DOCXOUT=/tmp/$1.docx

# preprocessing
# NOTE: would rather not have to do any preprocessing to markdown source, and
# rely on the parser, but not everything can be solved with html tagging. Unless
# I move to a completely different approach, like Go's goquery for nested tags.
mdout/prep.sh $RUNIN > $PREPOUT

# convert md to html, store in tmp
# NOTE: extension auto_identifiers disabled so that <h2> is plain
# NOTE: --wrap=none so html has no non-semantic newlines.
pandoc --wrap=none -f markdown-auto_identifiers -t html $PREPOUT -o $PDHTMLOUT

# mark tags with special chars
mdout/sed.sh $PDHTMLOUT > $SEDHTMLOUT

# convert html to docx
pandoc -f html -t docx $SEDHTMLOUT -o $DOCXOUT

# so open works on Arch:
OPENCMD='open'
if ! command -v $OPENCMD 2>&1 >/dev/null
then
    echo "open not found, using xdg-open"
    OPENCMD='xdg-open'
fi

$OPENCMD $DOCXOUT
