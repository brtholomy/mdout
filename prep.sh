#!/bin/bash

# preprocess markdown before pandoc rendering.

source $(dirname ${BASH_SOURCE-$0})/sed.sh

SEDIN='/tmp/tmp_prep.md'
SEDOUT='/tmp/tmp_prepout.md'
cat $1 > $SEDIN
cat $1 > $SEDOUT

# marks successive paragraphs within a blockquote. Can't figure a
# straightforward way to do this in the html.
# NOTE: the first <p> will still need to get marked in the html routine.
SEDRX='>> '
SEDTX='>>¥'

bth_runsed

# TODO: test this as an alternative to another replace routine:
# perl -CSD -pe 's/([\p{Han}\x{3000}-\x{303F}\x{FF00}-\x{FFEF}]+)/[$1]{custom-style="Chinese"}/g' $SEDIN > $SEDOUT

cat $SEDOUT
