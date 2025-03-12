#!/bin/bash

# run sed on pandoc .html output

# piping cat like this and then writing to the file will end up with an empty
# file. Use a temp file instead.

# I do this rather than pipe the seds together, or do an inplace, so that I can
# redefine the variables in between and get a result I can check before
# replacing the source file.

SEDIN='/tmp/in.html'
SEDOUT='/tmp/out.html'
cat $1 > $SEDIN
cat $1 > $SEDOUT

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

####################
# replacements

# two parallel arrays, since bash 3 on OSX lacks associative arrays. And this is
# just simpler in bash anyway.
declare SEDFR=()
declare SEDTO=()

# section
SEDFR+=('<hr \/>')
SEDTO+=('<p>¢<\/p>')

# EN dash
# NOTE: pandoc will insert newlines in the html unless --wrap=none is given.
SEDFR+=(' - ')
SEDTO+=(' – ')

# blockquote source
# I mark source in markdown with a double:
# >>
# NOTE: the literal \v : i think \v only works in sed within ""
SEDFR+=('<blockquote><blockquote><p>')
# NOTE: the extra  to prevent matching again:
SEDTO+=('<blockquote><blockquote><p>₱')

# blockquote
SEDFR+=('<blockquote><p>')
SEDTO+=('<blockquote><p>¥')

# code block indent
SEDFR+=('<pre><code><p>')
SEDTO+=('<pre><code><p>¥')

# superscript
SEDFR+=('<sup>')
SEDTO+=('<sup>¤')

# footnote back anchor.
# FIXME: don't know why this regex fails:
# SEDFR+=('<a*.*? class=\"footnote-back\" role=\"doc-backlink\">↩︎<\/a>')
SEDFR+=('↩︎')
SEDTO+=('')

SEDFR+=('<h2>')
SEDTO+=('<h2>£')

for i in "${!SEDFR[@]}"; do
    SEDRX="${SEDFR[i]}"
    SEDTX="${SEDTO[i]}"
    bth_runsed
done

####################
# output
cat $SEDOUT
