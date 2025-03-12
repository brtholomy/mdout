#!/bin/bash

# piping cat like this and then writing to the file will end up with an empty
# file. Use a temp file instead.

# I do this rather than pipe the seds together, or do an inplace, so that I can
# redefine the variables in between and get a result I can check before
# replacing the source file.

# rather than rely on ordered args, uses named globals. Should be set up like:
# SEDIN='/tmp/in.html'
# SEDOUT='/tmp/out.html'
# SEDRX='foo'
# SEDTX='bar'

bth_runsed () {
    # use tr to translate \n to \v, so that sed can work on it, then back again.
    # https://stackoverflow.com/a/74155806
    cat $SEDIN | tr '\n' '\v' > $SEDOUT
    cat $SEDOUT > $SEDIN

    cat $SEDIN | sed "s/$SEDRX/$SEDTX/g" > $SEDOUT
    cat $SEDOUT > $SEDIN

    cat $SEDIN | tr '\v' '\n' > $SEDOUT
    cat $SEDOUT > $SEDIN
}
