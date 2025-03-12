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

    cat $SEDIN | sed "s/$SEDFROM/$SEDTO/g" > $SEDOUT
    cat $SEDOUT > $SEDIN

    cat $SEDIN | tr '\v' '\n' > $SEDOUT
    cat $SEDOUT > $SEDIN
}

####################
# replacements

# section
SEDFROM='<hr \/>'
SEDTO='<p>¢<\/p>'

bth_runsed

# EN dash
# NOTE: pandoc will insert newlines in the html unless --wrap=none is given.
SEDFROM=' - '
SEDTO=' – '

bth_runsed

# blockquote source
# I mark source in markdown with a double:
# >>
# NOTE: the literal \v : i think \v only works in sed within ""
SEDFROM='<blockquote><blockquote><p>'
# NOTE: the extra  to prevent matching again:
SEDTO='<blockquote><blockquote><p>₱'

bth_runsed

# blockquote
SEDFROM='<blockquote><p>'
SEDTO='<blockquote><p>¥'

bth_runsed

# code block indent
SEDFROM='<pre><code><p>'
SEDTO='<pre><code><p>¥'

bth_runsed

# superscript
SEDFROM='<sup>'
SEDTO='<sup>¤'

bth_runsed

# footnote back anchor.
# FIXME: don't know why this regex fails:
# SEDFROM='<a*.*? class=\"footnote-back\" role=\"doc-backlink\">↩︎<\/a>'
# SEDTO=''
SEDFROM='↩︎'
SEDTO=''

bth_runsed

SEDFROM='<h2>'
SEDTO='<h2>£'

bth_runsed

####################
# output
cat $SEDOUT
