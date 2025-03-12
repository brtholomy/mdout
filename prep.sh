#!/bin/bash

PREPIN='/tmp/tmp_prep.md'
PREPOUT='/tmp/tmp_prepout.md'
cat $1 > $PREPIN
cat $1 > $PREPOUT

bth_runsed () {
    # use tr to translate \n to \v, so that sed can work on it, then back again.
    # https://stackoverflow.com/a/74155806
    cat $PREPIN | tr '\n' '\v' > $PREPOUT
    cat $PREPOUT > $PREPIN

    cat $PREPIN | sed "s/$PREPRX/$PREPTX/g" > $PREPOUT
    cat $PREPOUT > $PREPIN

    cat $PREPIN | tr '\v' '\n' > $PREPOUT
    cat $PREPOUT > $PREPIN
}

# marks successive paragraphs within a blockquote. Can't figure a
# straightforward way to do this in the html.
# NOTE: the first <p> will still need to get marked in the html routine.
PREPRX='>> '
PREPTX='>>¥'

bth_runsed

cat $PREPOUT
