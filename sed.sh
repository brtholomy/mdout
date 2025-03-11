# run sed on pandoc .html output

####################
# replacements

# key: SEDFROM, value: SEDTO
typeset -A replacements=()

# section
replacements['<hr \/>']='<p>¢<\/p>'

# EN dash
# NOTE: pandoc inserts newlines in the html, this can break at the dash, such
# that sed won't find it:
replacements[' -[ ]']=' – '

# blockquote source
# I mark source in markdown with a double:
# >>
# NOTE: the literal \v : i think \v only works in sed within ""
# NOTE: the extra  to prevent this from matching again:
replacements['<blockquote><blockquote><p>']='<blockquote><blockquote><p>₱'

# blockquote
replacements['<blockquote><p>']='<blockquote><p>¥'

# code block indent
replacements['<pre><code><p>']='<pre><code><p>¥'

# superscript
replacements['<sup>']='<sup>¤'

# footnote back anchor.
# FIXME: don't know why this regex fails:
# replacements['<a*.*? class=\"footnote-back\" role=\"doc-backlink\">↩︎<\/a>']=''
replacements['↩︎']=''

# h2
replacements['<h2>']='<h2>£'

####################
# set up tmp files
#
# piping cat like this and then writing to the file will end up with an empty
# file. Use a temp file instead.
#
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
# run it

for key in "${!replacements[@]}"; do
    SEDFROM="$key"
    SEDTO="${replacements[$key]}"
    bth_runsed
done

####################
# output
cat $SEDOUT
