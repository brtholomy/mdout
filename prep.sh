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

cat $SEDOUT
